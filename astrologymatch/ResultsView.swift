//
//  ResultsView.swift
//  astrologymatch
//
//  Created by Anantika Mannby on 10/7/25.
//

import SwiftUI

struct ResultsView: View {
    let userName: String
    let partnerName: String
    let userBirthday: Date
    let partnerBirthday: Date
    let userTimeOfBirth: Date
    let partnerTimeOfBirth: Date
    let compatibilityData: SupabaseService.CompatibilityResponse?
    let onStartOver: () -> Void
    
    @State private var isAnimating = false
    @State private var contentOpacity = 0.0
    @State private var starsRotation = 0.0
    @State private var buttonPressed = false
    @State private var showCompatibilityList = false
    
    var body: some View {
        ZStack {
            // White background
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 8) {
                    Text("Compatibility Results")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .opacity(contentOpacity)
                    
                    Text("\(userName) & \(partnerName)")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.black)
                        .opacity(contentOpacity)
                }
                
                VStack(spacing: 16) {
                    let userSign = ZodiacUtils.zodiacSignName(from: userBirthday)
                    let partnerSign = ZodiacUtils.zodiacSignName(from: partnerBirthday)
                    
                    Text("\(userSign) & \(partnerSign)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text("\(compatibilityData?.score ?? 0)%")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(compatibilityLevel())
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .overlay(
                            Rectangle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                )
                .padding(.horizontal, 24)
                .opacity(contentOpacity)
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Romantic Compatibility")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(compatibilityData?.blurb ?? "Compatibility data unavailable")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                )
                .padding(.horizontal, 24)
                .opacity(contentOpacity)
                
                Button(action: {
                    showCompatibilityList = true
                }) {
                    HStack {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 16, weight: .medium))
                        Text("View All Compatibility Scores")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        Rectangle()
                            .fill(Color.blue.opacity(0.1))
                            .overlay(
                                Rectangle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 24)
                .opacity(contentOpacity)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onStartOver()
                        buttonPressed = false
                    }
                }) {
                    Text("Start Over")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    )
                        .scaleEffect(buttonPressed ? 0.95 : 1.0)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(contentOpacity)
            }
        }
        .sheet(isPresented: $showCompatibilityList) {
            let userSign = ZodiacUtils.zodiacSignName(from: userBirthday)
            CompatibilityListView(userSign: userSign)
        }
        .onAppear {
            isAnimating = true
            withAnimation(.easeIn(duration: 1.0)) {
                contentOpacity = 1.0
            }
            withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
                starsRotation = 360
            }
        }
    }
    
    
    private func compatibilityLevel() -> String {
        guard let score = compatibilityData?.score else {
            return "Loading..."
        }
        
        switch score {
        case 80...100:
            return "Highly Compatible"
        case 60...79:
            return "Good Compatibility"
        case 40...59:
            return "Moderate Compatibility"
        default:
            return "Challenging Match"
        }
    }
    
}

struct CompatibilityListView: View {
    let userSign: String
    @State private var compatibilityData: [SupabaseService.CompatibilityResponse] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("\(userSign) Compatibility")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Done") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading compatibility data...")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.top, 16)
                    }
                } else if let error = errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        Text("Error Loading Data")
                            .font(.system(size: 24, weight: .bold))
                        Text(error)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else {
                    List {
                        ForEach(compatibilityData, id: \.id) { compatibility in
                            CompatibilityRowView(compatibility: compatibility)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .onAppear {
            loadCompatibilityData()
        }
    }
    
    private func loadCompatibilityData() {
        SupabaseService.shared.getAllCompatibilityData { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.compatibilityData = data.filter { compatibility in
                        compatibility.Sign1 == self.userSign || compatibility.Sign2 == self.userSign
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }   
    }
}

struct CompatibilityRowView: View {
    let compatibility: SupabaseService.CompatibilityResponse
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(compatibility.Sign1) & \(compatibility.Sign2)")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(compatibility.Blurb)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack {
                Text("\(compatibility.CompatibilityScore)%")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(scoreColor(compatibility.CompatibilityScore))
                
                Text(compatibilityLevel(compatibility.CompatibilityScore))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func scoreColor(_ score: Int) -> Color {
        switch score {
        case 80...100:
            return .green
        case 60...79:
            return .orange
        case 40...59:
            return .yellow
        default:
            return .red
        }
    }
    
    private func compatibilityLevel(_ score: Int) -> String {
        switch score {
        case 80...100:
            return "Excellent"
        case 60...79:
            return "Good"
        case 40...59:
            return "Fair"
        default:
            return "Poor"
        }
    }
}


struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(
            userName: "Alice",
            partnerName: "Bob",
            userBirthday: Date(),
            partnerBirthday: Date(),
            userTimeOfBirth: Date(),
            partnerTimeOfBirth: Date(),
            compatibilityData: SupabaseService.CompatibilityResponse(
                Sign1: "Leo",
                Sign2: "Sagittarius",
                CompatibilityScore: 95,
                Blurb: "A powerful fire pairing built on creativity, passion, and shared adventures."
            ),
            onStartOver: {}
        )
    }
}
