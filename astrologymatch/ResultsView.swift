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
    @State private var showPairingsList = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: Spacing.xl) {
                Spacer()
                    .frame(height: Spacing.huge)
                
                VStack(spacing: Spacing.xs) {
                    Text("Compatibility Results")
                        .font(Typography.displaySmall)
                        .foregroundColor(AppColors.primaryText)
                        .opacity(contentOpacity)
                    
                    Text("\(userName) & \(partnerName)")
                        .font(Typography.bodyLarge)
                        .foregroundColor(AppColors.primaryText)
                        .opacity(contentOpacity)
                }
                
                VStack(spacing: Spacing.md) {
                    let userSign = ZodiacUtils.zodiacSignName(from: userBirthday)
                    let partnerSign = ZodiacUtils.zodiacSignName(from: partnerBirthday)
                    
                    Text("\(userSign) & \(partnerSign)")
                        .font(Typography.bodyMedium)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(compatibilityData?.score ?? 0)%")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(compatibilityLevel())
                        .font(Typography.bodyLarge)
                        .foregroundColor(AppColors.primaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xxl)
                .background(
                    Rectangle()
                        .fill(AppColors.backgroundPrimary)
                        .overlay(
                            Rectangle()
                                .stroke(AppColors.borderDefault, lineWidth: 1)
                        )
                )
                .padding(.horizontal, Spacing.xl)
                .opacity(contentOpacity)
                
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Romantic Compatibility")
                            .font(Typography.bodyMedium)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(compatibilityData?.blurb ?? "Compatibility data unavailable")
                            .font(Typography.bodySmall)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.md)
                .background(
                    Rectangle()
                        .fill(AppColors.secondaryText.opacity(0.1))
                )
                .padding(.horizontal, Spacing.xl)
                .opacity(contentOpacity)
                
                Button(action: {
                    showCompatibilityList = true
                }) {
                    HStack {
                        Image(systemName: "list.bullet")
                            .font(Typography.bodyMedium)
                        Text("View All Compatibility Scores")
                            .font(Typography.bodyMedium)
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm)
                    .background(
                        Rectangle()
                            .fill(Color.blue.opacity(0.1))
                            .overlay(
                                Rectangle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, Spacing.xl)
                .opacity(contentOpacity)
                
                Button(action: {
                    showPairingsList = true
                }) {
                    HStack {
                        Image(systemName: "person.2")
                            .font(Typography.bodyMedium)
                        Text("View All User Scores")
                            .font(Typography.bodyMedium)
                    }
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm)
                    .background(
                        Rectangle()
                            .fill(Color.green.opacity(0.1))
                            .overlay(
                                Rectangle()
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, Spacing.xl)
                .opacity(contentOpacity)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: AnimationDuration.medium, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.fast) {
                        onStartOver()
                        buttonPressed = false
                    }
                }) {
                    Text("Start Over")
                }
                .appButtonStyle(.secondary, isPressed: buttonPressed)
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xxxl)
                .opacity(contentOpacity)
            }
        }
        .sheet(isPresented: $showCompatibilityList) {
            let userSign = ZodiacUtils.zodiacSignName(from: userBirthday)
            CompatibilityListView(userSign: userSign)
        }
        .sheet(isPresented: $showPairingsList) {
            PairingsListView()
        }
        .onAppear {
            isAnimating = true
            withAnimation(.easeIn(duration: AnimationDuration.verySlow)) {
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
            AppColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("\(userSign) Compatibility")
                        .font(Typography.displaySmall)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Done") {
                        withAnimation(.easeInOut(duration: AnimationDuration.medium)) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .font(Typography.bodyMedium)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.lg)
                .padding(.bottom, Spacing.md)
                
                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading compatibility data...")
                            .font(Typography.bodyMedium)
                            .foregroundColor(AppColors.secondaryText)
                            .padding(.top, Spacing.md)
                    }
                } else if let error = errorMessage {
                    VStack(spacing: Spacing.md) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        Text("Error Loading Data")
                            .font(Typography.displaySmall)
                        Text(error)
                            .font(Typography.bodyMedium)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.xxl)
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
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("\(compatibility.Sign1) & \(compatibility.Sign2)")
                    .font(Typography.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primaryText)
                
                Text(compatibility.Blurb)
                    .font(Typography.bodySmall)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack {
                Text("\(compatibility.CompatibilityScore)%")
                    .font(Typography.displaySmall)
                    .foregroundColor(scoreColor(compatibility.CompatibilityScore))
                
                Text(compatibilityLevel(compatibility.CompatibilityScore))
                    .font(Typography.labelSmall)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.vertical, Spacing.xs)
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

struct PairingsListView: View {
    @State private var pairingsData: [SupabaseService.PairingResponse] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("All User Pairings")
                        .font(Typography.displaySmall)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Done") {
                        withAnimation(.easeInOut(duration: AnimationDuration.medium)) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .font(Typography.bodyMedium)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.lg)
                .padding(.bottom, Spacing.md)
                
                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading user pairings...")
                            .font(Typography.bodyMedium)
                            .foregroundColor(AppColors.secondaryText)
                            .padding(.top, Spacing.md)
                    }
                } else if let error = errorMessage {
                    VStack(spacing: Spacing.md) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        Text("Error Loading Data")
                            .font(Typography.displaySmall)
                        Text(error)
                            .font(Typography.bodyMedium)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.xxl)
                    }
                } else {
                    List {
                        ForEach(pairingsData, id: \.id) { pairing in
                            PairingRowView(pairing: pairing)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .onAppear {
            loadPairingsData()
        }
    }
    
    private func loadPairingsData() {
        SupabaseService.shared.getAllPairingsData { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.pairingsData = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct PairingRowView: View {
    let pairing: SupabaseService.PairingResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                Text("\(pairing.a_name.isEmpty ? "Unknown" : pairing.a_name) & \(pairing.b_name.isEmpty ? "Unknown" : pairing.b_name)")
                    .font(Typography.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(pairing.score)%")
                    .font(Typography.displaySmall)
                    .foregroundColor(scoreColor(pairing.score))
            }
            
            Text(pairing.insights)
                .font(Typography.bodySmall)
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(2)
            
            HStack {
                Text(formatDate(pairing.a_date))
                    .font(Typography.labelSmall)
                    .foregroundColor(AppColors.secondaryText)
                
                Text("•")
                    .font(Typography.labelSmall)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(formatDate(pairing.b_date))
                    .font(Typography.labelSmall)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
                
                Text(formatCreatedAt(pairing.created_at))
                    .font(Typography.labelSmall)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.vertical, Spacing.xs)
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
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .short
            return displayFormatter.string(from: date)
        }
        return dateString
    }
    
    private func formatCreatedAt(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .short
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return dateString
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
