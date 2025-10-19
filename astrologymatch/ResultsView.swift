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
    private enum BottomTab: Int, CaseIterable { case home, explore, pairings }
    @State private var selectedTab: BottomTab = .home
    @State private var topButtonsPressed = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                // Top Nav Bar
                HStack(alignment: .center) {
                    Text("Compatibility Results")
                        .font(Typography.displaySmall)
                        .foregroundColor(AppColors.primaryText)
                    Spacer()
                    // Share
                    ShareLink(item: shareText) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                    }
                    .padding(.trailing, Spacing.md)
                    // Restart
                    Button(action: {
                        withAnimation(.spring(response: AnimationDuration.medium, dampingFraction: 0.6)) {
                            topButtonsPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.fast) {
                            onStartOver()
                            topButtonsPressed = false
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xxxl)
                .padding(.bottom, Spacing.md)
                .overlay(Rectangle().frame(height: 1).foregroundColor(AppColors.dividerDefault), alignment: .bottom)

                // Content area switches by tab
                Group {
                    switch selectedTab {
                    case .home:
                        ResultsHomeSection(
                            userName: userName,
                            partnerName: partnerName,
                            userBirthday: userBirthday,
                            partnerBirthday: partnerBirthday,
                            compatibilityData: compatibilityData,
                            onExploreTapped: { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .explore } },
                            onPairingsTapped: { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .pairings } }
                        )
                    case .explore:
                        let userSign = ZodiacUtils.zodiacSignName(from: userBirthday)
                        CompatibilityListView(userSign: userSign, showDone: false)
                            .padding(.horizontal, Spacing.xl)
                    case .pairings:
                        PairingsListView(showDone: false)
                            .padding(.horizontal, Spacing.xl)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                // Bottom Nav Bar
                HStack {
                    BottomTabButton(title: "Home", systemImage: "house", isSelected: selectedTab == .home) {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .home }
                    }
                    BottomTabButton(title: "Explore", systemImage: "magnifyingglass", isSelected: selectedTab == .explore) {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .explore }
                    }
                    BottomTabButton(title: "My Pairings", systemImage: "person.2", isSelected: selectedTab == .pairings) {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .pairings }
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.lg)
                .background(AppColors.backgroundPrimary)
                .overlay(Rectangle().frame(height: 1).foregroundColor(AppColors.dividerDefault), alignment: .top)
            }
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

    private var shareText: String {
        let scoreText = compatibilityData?.score != nil ? "\(compatibilityData!.score)%" : "great"
        return "Our compatibility is \(scoreText)! — Astrology Match"
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
    var showDone: Bool = true
    @State private var compatibilityData: [SupabaseService.CompatibilityResponse] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Text("\(userSign) Compatibility")
                        .font(Typography.displaySmall)
                        .foregroundColor(AppColors.primaryText)

                    Spacer()

                    if showDone {
                        Button("Done") {
                            withAnimation(.easeInOut(duration: AnimationDuration.medium)) {
                                dismiss()
                            }
                        }
                        .font(Typography.bodyMedium)
                        .foregroundColor(.blue)
                    }
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
    var showDone: Bool = true
    @State private var pairingsData: [SupabaseService.PairingResponse] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Text("All User Pairings")
                        .font(Typography.displaySmall)
                        .foregroundColor(AppColors.primaryText)

                    Spacer()

                    if showDone {
                        Button("Done") {
                            withAnimation(.easeInOut(duration: AnimationDuration.medium)) {
                                dismiss()
                            }
                        }
                        .font(Typography.bodyMedium)
                        .foregroundColor(.blue)
                    }
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

private struct BottomTabButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: systemImage)
                Text(title).font(Typography.labelSmall)
            }
            .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
            .frame(maxWidth: .infinity)
        }
    }
}

private struct ResultsHomeSection: View {
    let userName: String
    let partnerName: String
    let userBirthday: Date
    let partnerBirthday: Date
    let compatibilityData: SupabaseService.CompatibilityResponse?
    let onExploreTapped: () -> Void
    let onPairingsTapped: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // Names
                Text("\(userName.isEmpty ? "You" : userName) & \(partnerName.isEmpty ? "Partner" : partnerName)")
                    .font(Typography.displaySmall)
                    .foregroundColor(AppColors.primaryText)

                // Score card
                VStack(spacing: Spacing.md) {
                    Text("\(ZodiacUtils.zodiacSignName(from: userBirthday)) & \(ZodiacUtils.zodiacSignName(from: partnerBirthday))")
                        .font(Typography.bodyLarge)
                        .foregroundColor(AppColors.primaryText)
                    Text("\(compatibilityData?.score ?? 0)%")
                        .font(.system(size: 56, weight: .light))
                        .foregroundColor(AppColors.primaryText)
                    Text("\((compatibilityData?.score ?? 0) >= 80 ? "Highly Compatible" : "Compatible")")
                        .font(Typography.bodyMedium)
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(Rectangle().stroke(AppColors.dividerDefault, lineWidth: 1))

                // Romantic Compatibility card
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack(spacing: Spacing.xs) {
                        Text("🔥")
                        Text("Romantic Compatibility").font(Typography.bodyLarge)
                    }
                    Text(compatibilityData?.blurb ?? "Compatibility data unavailable")
                        .font(Typography.bodyMedium)
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding()
                .background(AppColors.dividerDefault.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Quick nav cards
                HStack(spacing: Spacing.lg) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Image(systemName: "magnifyingglass")
                        Text("Explore Signs").font(Typography.bodyLarge)
                        Text("Browse all matches").font(Typography.labelSmall).foregroundColor(AppColors.secondaryText)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.dividerDefault, lineWidth: 1))
                    .onTapGesture { onExploreTapped() }

                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Image(systemName: "person.2")
                        Text("My Pairings").font(Typography.bodyLarge)
                        Text("View all checks").font(Typography.labelSmall).foregroundColor(AppColors.secondaryText)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.dividerDefault, lineWidth: 1))
                    .onTapGesture { onPairingsTapped() }
                }
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.lg)
        }
    }
}
