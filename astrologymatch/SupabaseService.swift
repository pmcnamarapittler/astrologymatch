import Foundation

final class SupabaseService {
	static let shared = SupabaseService()
	private let projectUrl = ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? ""
	private let anonKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""
	private let tableName = "pairings"

	private lazy var jsonEncoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		return encoder
	}()

	struct PairingPayload: Encodable {
		let a_name: String
		let b_name: String
		let a_date: Date
		let b_date: Date
		let score: Int
		let insights: String
	}
	
	struct CompatibilityResponse: Decodable, Identifiable {
		let Sign1: String
		let Sign2: String
		let CompatibilityScore: Int
		let Blurb: String
		
		var sign1: String { Sign1 }
		var sign2: String { Sign2 }
		var score: Int { CompatibilityScore }
		var blurb: String { Blurb }
		
		var id: String { "\(Sign1)-\(Sign2)" }
	}

	func createPairing(aName: String, aDate: Date, bName: String, bDate: Date, compatibilityScore: Int, insights: String, completion: @escaping (Result<Void, Error>) -> Void) {
		guard !projectUrl.isEmpty, !anonKey.isEmpty, let url = URL(string: "\(projectUrl)/rest/v1/\(tableName)") else {
			completion(.failure(NSError(domain: "SupabaseConfig", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing SUPABASE_URL or SUPABASE_ANON_KEY"])))
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
		request.setValue("\(anonKey)", forHTTPHeaderField: "apikey")
		request.setValue("return=representation", forHTTPHeaderField: "Prefer")

		let payload = PairingPayload(a_name: aName, b_name: bName, a_date: aDate, b_date: bDate, score: compatibilityScore, insights: insights)
		do {
			request.httpBody = try jsonEncoder.encode(payload)
		} catch {
			completion(.failure(error))
			return
		}

		URLSession.shared.dataTask(with: request) { _, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
				let status = (response as? HTTPURLResponse)?.statusCode ?? -1
				completion(.failure(NSError(domain: "SupabaseHTTP", code: status, userInfo: [NSLocalizedDescriptionKey: "Request failed with code \(status)"])) )
				return
			}
			completion(.success(()))
		}.resume()
	}
	
	func getCompatibility(sign1: String, sign2: String, completion: @escaping (Result<CompatibilityResponse, Error>) -> Void) {
		guard !projectUrl.isEmpty, !anonKey.isEmpty else {
			completion(.failure(NSError(domain: "SupabaseConfig", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing SUPABASE_URL or SUPABASE_ANON_KEY"])))
			return
		}
		
		let combinations = [
			(sign1, sign2),
			(sign2, sign1)
		]
		
		func tryCombination(_ combo: (String, String), index: Int) {
			let (firstSign, secondSign) = combo
			let query = "Sign1=eq.\(firstSign)&Sign2=eq.\(secondSign)"
			guard let url = URL(string: "\(projectUrl)/rest/v1/compatibility?\(query)") else {
				completion(.failure(NSError(domain: "URL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
				return
			}
			
			var request = URLRequest(url: url)
			request.httpMethod = "GET"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
			request.setValue("\(anonKey)", forHTTPHeaderField: "apikey")
			
			URLSession.shared.dataTask(with: request) { data, response, error in
				if let error = error {
					if index == combinations.count - 1 {
						completion(.failure(error))
					} else {
						tryCombination(combinations[index + 1], index: index + 1)
					}
					return
				}
				
				guard let httpResponse = response as? HTTPURLResponse else {
					if index == combinations.count - 1 {
						completion(.failure(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
					} else {
						tryCombination(combinations[index + 1], index: index + 1)
					}
					return
				}
				
				guard httpResponse.statusCode == 200 else {
					if index == combinations.count - 1 {
						completion(.failure(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with code \(httpResponse.statusCode)"])))
					} else {
						tryCombination(combinations[index + 1], index: index + 1)
					}
					return
				}
				
				guard let data = data else {
					if index == combinations.count - 1 {
						completion(.failure(NSError(domain: "Data", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
					} else {
						tryCombination(combinations[index + 1], index: index + 1)
					}
					return
				}
				
				do {
					let decoder = JSONDecoder()
					let responses = try decoder.decode([CompatibilityResponse].self, from: data)
					
					if let compatibility = responses.first {
						completion(.success(compatibility))
					} else {
						if index < combinations.count - 1 {
							tryCombination(combinations[index + 1], index: index + 1)
						} else {
							completion(.failure(NSError(domain: "NotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Compatibility data not found for \(sign1) and \(sign2)"])))
						}
					}
				} catch {
					if index == combinations.count - 1 {
						completion(.failure(error))
					} else {
						tryCombination(combinations[index + 1], index: index + 1)
					}
				}
			}.resume()
		}
		
		tryCombination(combinations[0], index: 0)
	}
	
	func getAllCompatibilityData(completion: @escaping (Result<[CompatibilityResponse], Error>) -> Void) {
		guard !projectUrl.isEmpty, !anonKey.isEmpty else {
			completion(.failure(NSError(domain: "SupabaseConfig", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing SUPABASE_URL or SUPABASE_ANON_KEY"])))
			return
		}
		
		guard let url = URL(string: "\(projectUrl)/rest/v1/compatibility?order=CompatibilityScore.desc") else {
			completion(.failure(NSError(domain: "URL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
		request.setValue("\(anonKey)", forHTTPHeaderField: "apikey")
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(.failure(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
				return
			}
			
			guard httpResponse.statusCode == 200 else {
				completion(.failure(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with code \(httpResponse.statusCode)"])))
				return
			}
			
			guard let data = data else {
				completion(.failure(NSError(domain: "Data", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let responses = try decoder.decode([CompatibilityResponse].self, from: data)
				completion(.success(responses))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
}


