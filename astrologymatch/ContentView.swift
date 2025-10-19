//
//  ContentView.swift
//  astrologymatch
//
//  Created by Anantika Mannby on 10/7/25.
//

import SwiftUI

// MARK: - Design System

// MARK: - Colors
enum AppColors {
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let tertiaryText = Color.gray.opacity(0.6)
    static let backgroundPrimary = Color.white
    static let backgroundGradientTop = Color(red: 0.2, green: 0.2, blue: 0.25)
    static let backgroundGradientMiddle = Color(red: 0.15, green: 0.15, blue: 0.2)
    static let starWhite = Color.white
    static let moonGlow = Color.white.opacity(0.5)
    static let sunYellow = Color.yellow.opacity(0.3)
    static let sunOrange = Color.orange.opacity(0.6)
    static let dividerDefault = Color.gray.opacity(0.3)
    static let dividerFocused = Color.black
    static let borderDefault = Color.black
    static let overlayLight = Color.white.opacity(0.9)
}

// MARK: - Spacing
enum Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
    static let huge: CGFloat = 60
    static let sectionSmall: CGFloat = 16
    static let sectionMedium: CGFloat = 24
    static let sectionLarge: CGFloat = 32
}

// MARK: - Typography
enum Typography {
    static let displayLarge = Font.system(size: 48, weight: .light, design: .serif)
    static let displayMedium = Font.system(size: 36, weight: .light, design: .serif)
    static let displaySmall = Font.system(size: 32, weight: .light, design: .serif)
    static let bodyLarge = Font.system(size: 18, weight: .regular)
    static let bodyMedium = Font.system(size: 16, weight: .regular)
    static let bodySmall = Font.system(size: 14, weight: .regular)
    static let labelLarge = Font.system(size: 14, weight: .medium)
    static let labelMedium = Font.system(size: 12, weight: .medium)
    static let labelSmall = Font.system(size: 12, weight: .regular)
    static let buttonPrimary = Font.system(size: 14, weight: .medium)
    static let buttonSecondary = Font.system(size: 16, weight: .regular)
    static let zodiacSymbol = Font.system(size: 20)
}

// MARK: - Sizing
enum Sizing {
    static let iconSmall: CGFloat = 60
    static let iconMedium: CGFloat = 80
    static let iconLarge: CGFloat = 120
    static let wheelSmall: CGFloat = 200
    static let wheelMedium: CGFloat = 250
    static let wheelLarge: CGFloat = 300
    static let buttonHeightSmall: CGFloat = 44
    static let buttonHeightMedium: CGFloat = 48
    static let buttonHeightLarge: CGFloat = 56
}

// MARK: - Animation Durations
enum AnimationDuration {
    static let fast: Double = 0.2
    static let medium: Double = 0.3
    static let slow: Double = 0.5
    static let verySlow: Double = 1.0
    static let fadeIn: Double = 1.0
    static let wheelRotation: Double = 30.0
    static let moonRotation: Double = 20.0
}

// MARK: - Shadow Styles
enum ShadowStyle {
    case soft, medium, strong, glow
    
    var color: Color {
        switch self {
        case .soft: return Color.black.opacity(0.1)
        case .medium: return Color.black.opacity(0.2)
        case .strong: return Color.black.opacity(0.3)
        case .glow: return Color.white.opacity(0.5)
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .soft: return 4
        case .medium: return 8
        case .strong: return 12
        case .glow: return 20
        }
    }
}

// MARK: - View Modifiers
struct AppButtonStyle: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled
    enum Style { case primary, secondary }
    let style: Style
    let isPressed: Bool
    
    func body(content: Content) -> some View {
        // Compute colors based on style and enabled state
        let fg: Color
        let bg: Color
        let border: Color
        switch style {
        case .primary:
            fg = isEnabled ? .white : Color.white.opacity(0.7)
            bg = isEnabled ? AppColors.primaryText : AppColors.primaryText.opacity(0.2)
            border = .clear
        case .secondary:
            fg = isEnabled ? AppColors.primaryText : AppColors.secondaryText.opacity(0.6)
            bg = Color.clear
            border = isEnabled ? AppColors.borderDefault : AppColors.dividerDefault
        }
        // Disabled override: filled gray pill and muted foreground
        let effectiveBG = isEnabled ? bg : AppColors.dividerDefault
        let effectiveFG = isEnabled ? fg : AppColors.secondaryText.opacity(0.8)
        let effectiveBorder = isEnabled ? border : Color.clear
        
        return content
            .font(Typography.buttonPrimary)
            .foregroundColor(effectiveFG)
            .frame(maxWidth: .infinity)
            .frame(height: Sizing.buttonHeightLarge)
            .background(
                Rectangle()
                    .fill(effectiveBG)
            )
            .overlay(
                Rectangle()
                    .stroke(effectiveBorder, lineWidth: 1)
            )
            .opacity(isEnabled ? 1 : 0.55)
            .scaleEffect((isPressed && isEnabled) ? 0.95 : 1.0)
    }
}

struct FormFieldStyle: ViewModifier {
    let label: String
    let isFocused: Bool
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(Typography.labelSmall)
                .foregroundColor(AppColors.secondaryText)
            content
                .font(Typography.bodyMedium)
                .padding(.bottom, Spacing.xxs)
            Divider()
                .background(isFocused ? AppColors.dividerFocused : AppColors.dividerDefault)
        }
    }
}

struct AppNavigationBarStyle: ViewModifier {
    let title: String
    let onBack: (() -> Void)?
    @State private var backButtonPressed = false
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            ZStack {
                Text(title)
                    .font(Typography.displaySmall)
                    .foregroundColor(AppColors.primaryText)
                
                if let onBack = onBack {
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: AnimationDuration.medium, dampingFraction: 0.6)) {
                                backButtonPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.fast) {
                                onBack()
                                backButtonPressed = false
                            }
                        }) {
                            HStack(spacing: Spacing.xxs) {
                                Image(systemName: "chevron.left")
                                    .font(Typography.bodyMedium.weight(.medium))
                                Text("Back")
                                    .font(Typography.bodyMedium)
                            }
                            .foregroundColor(AppColors.primaryText)
                            .scaleEffect(backButtonPressed ? 0.9 : 1.0)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.xl)
                }
            }
            .frame(height: Sizing.buttonHeightLarge)
            .padding(.top, Spacing.xxxl)
            content
        }
    }
}

// MARK: - View Extensions
extension View {
    func appButtonStyle(_ style: AppButtonStyle.Style, isPressed: Bool = false) -> some View {
        self.modifier(AppButtonStyle(style: style, isPressed: isPressed))
    }
    
    func formFieldStyle(label: String, isFocused: Bool = false) -> some View {
        self.modifier(FormFieldStyle(label: label, isFocused: isFocused))
    }
    
    func appNavigationBar(title: String, onBack: (() -> Void)? = nil) -> some View {
        self.modifier(AppNavigationBarStyle(title: title, onBack: onBack))
    }
    
    func cardShadow(_ style: ShadowStyle = .soft) -> some View {
        self.shadow(color: style.color, radius: style.radius)
    }
}

// MARK: - Gradient Extensions
extension LinearGradient {
    static var appBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                AppColors.backgroundGradientTop,
                AppColors.backgroundGradientMiddle,
                AppColors.backgroundPrimary
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension RadialGradient {
    static var sunGlow: RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [AppColors.sunYellow, AppColors.backgroundPrimary]),
            center: .center,
            startRadius: 0,
            endRadius: 30
        )
    }
}

// MARK: - Main App Structure
// MARK: - App Screen Enum
enum AppScreen: Int {
    case landing = 0
    case userInfo = 1
    case partnerInfo = 2
    case calculating = 3
    case results = 4
    
    var title: String {
        switch self {
        case .landing: return "Astrology Match"
        case .userInfo: return "Your Info"
        case .partnerInfo: return "Partner Info"
        case .calculating: return "Calculating"
        case .results: return "Results"
        }
    }
}

struct ContentView: View {
    @State private var currentScreen: AppScreen = .landing
    @State private var userName: String = ""
    @State private var userBirthday: Date = Date()
    @State private var userTimeOfBirth: Date = Date()
    @State private var partnerName: String = ""
    @State private var partnerBirthday: Date = Date()
    @State private var partnerTimeOfBirth: Date = Date()
    @State private var compatibilityData: SupabaseService.CompatibilityResponse?
    
    var body: some View {
        TabView(selection: $currentScreen) {
            LandingView(onGetStarted: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentScreen = .userInfo
                }
            })
            .tag(AppScreen.landing)
            
            UserInfoView(
                name: $userName,
                birthday: $userBirthday,
                timeOfBirth: $userTimeOfBirth,
                onContinue: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = .partnerInfo
                    }
                },
                onBack: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = .landing
                    }
                }
            )
            .tag(AppScreen.userInfo)
            
            PartnerInfoView(
                name: $partnerName,
                birthday: $partnerBirthday,
                timeOfBirth: $partnerTimeOfBirth,
                onSubmit: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentScreen = .calculating
                    }
                    fetchCompatibilityData()
                },
                onBack: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = .userInfo
                    }
                }
            )
            .tag(AppScreen.partnerInfo)
            
            CalculatingView(
                userName: userName,
                partnerName: partnerName,
                userBirthday: userBirthday,
                partnerBirthday: partnerBirthday
            )
            .tag(AppScreen.calculating)
            
            ResultsView(
                userName: userName,
                partnerName: partnerName,
                userBirthday: userBirthday,
                partnerBirthday: partnerBirthday,
                userTimeOfBirth: userTimeOfBirth,
                partnerTimeOfBirth: partnerTimeOfBirth,
                compatibilityData: compatibilityData,
                onStartOver: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = .landing
                        userName = ""
                        userBirthday = Date()
                        userTimeOfBirth = Date()
                        partnerName = ""
                        partnerBirthday = Date()
                        partnerTimeOfBirth = Date()
                        compatibilityData = nil
                    }
                }
            )
            .tag(AppScreen.results)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .highPriorityGesture(DragGesture())
        .edgesIgnoringSafeArea(.all)
    }
    
    private func fetchCompatibilityData() {
        let startTime = Date()
        let userSign = ZodiacUtils.zodiacSignName(from: userBirthday)
        let partnerSign = ZodiacUtils.zodiacSignName(from: partnerBirthday)
        
        SupabaseService.shared.getCompatibility(sign1: userSign, sign2: partnerSign) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let compatibility):
                    let elapsed = Date().timeIntervalSince(startTime)
                    let remaining = max(0, 3.0 - elapsed)
                    self.compatibilityData = compatibility
                    self.storePairingData(compatibility: compatibility)
                    DispatchQueue.main.asyncAfter(deadline: .now() + remaining) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.currentScreen = .results
                        }
                    }
                case .failure(_):
                    let fallbackCompatibility = SupabaseService.CompatibilityResponse(
                        Sign1: userSign,
                        Sign2: partnerSign,
                        CompatibilityScore: 75,
                        Blurb: "Unable to load detailed compatibility data. Your signs show good potential for connection."
                    )
                    let elapsed = Date().timeIntervalSince(startTime)
                    let remaining = max(0, 3.0 - elapsed)
                    self.compatibilityData = fallbackCompatibility
                    self.storePairingData(compatibility: fallbackCompatibility)
                    DispatchQueue.main.asyncAfter(deadline: .now() + remaining) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.currentScreen = .results
                        }
                    }
                }
            }
        }
    }
    
    private func storePairingData(compatibility: SupabaseService.CompatibilityResponse) {
        let aDate = combine(date: userBirthday, time: userTimeOfBirth)
        let bDate = combine(date: partnerBirthday, time: partnerTimeOfBirth)
        
        SupabaseService.shared.createPairing(
            aName: userName,
            aDate: aDate,
            bName: partnerName,
            bDate: bDate,
            compatibilityScore: compatibility.CompatibilityScore,
            insights: compatibility.Blurb
        ) { result in
            // Handle result silently
        }
    }
// MARK: - Calculating View
}
struct CalculatingView: View {
    let userName: String
    let partnerName: String
    let userBirthday: Date
    let partnerBirthday: Date
    
    @State private var contentOpacity: Double = 0.0
    @State private var dotsIndex: Int = 0
    private let dotsFrames: [String] = ["", ".", "..", "..."]
    @State private var step: Int = 0
    @State private var stepTimer: Timer?
    
    private var userSignName: String {
        ZodiacUtils.zodiacSignName(from: userBirthday)
    }
    private var partnerSignName: String {
        ZodiacUtils.zodiacSignName(from: partnerBirthday)
    }
    private var userSignGlyph: String { signSymbol(for: userSignName) }
    private var partnerSignGlyph: String { signSymbol(for: partnerSignName) }
    
    var body: some View {
        ZStack {
            // Luxe background reused from Landing
            LinearGradient.appBackground.edgesIgnoringSafeArea(.all)
            StarfieldView(isAnimating: true)
            
            VStack(spacing: Spacing.xl) {
                Spacer().frame(height: Spacing.huge)
                
                // Headline with animated ellipsis
                Text("Hang tight — we're calculating your results\(dotsFrames[dotsIndex])")
                    .font(Typography.displaySmall)
                    .foregroundColor(AppColors.starWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
                    .opacity(contentOpacity)
                
                // Names and zodiac glyphs
                HStack(alignment: .center, spacing: Spacing.lg) {
                    VStack(spacing: Spacing.xs) {
                        Text(userSignGlyph)
                            .font(Typography.displayMedium)
                            .foregroundColor(AppColors.overlayLight)
                        Text(userName.isEmpty ? "You" : userName)
                            .font(Typography.bodyLarge)
                            .foregroundColor(AppColors.starWhite)
                            .lineLimit(1)
                    }
                    Text("✦")
                        .font(Typography.displayMedium)
                        .foregroundColor(AppColors.overlayLight)
                    VStack(spacing: Spacing.xs) {
                        Text(partnerSignGlyph)
                            .font(Typography.displayMedium)
                            .foregroundColor(AppColors.overlayLight)
                        Text(partnerName.isEmpty ? "Partner" : partnerName)
                            .font(Typography.bodyLarge)
                            .foregroundColor(AppColors.starWhite)
                            .lineLimit(1)
                    }
                }
                .opacity(contentOpacity)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.3)
                    .tint(AppColors.starWhite)
                    .opacity(contentOpacity)

                HStack(spacing: Spacing.sm) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(i < step ? AppColors.starWhite : AppColors.starWhite.opacity(0.25))
                            .frame(width: 8, height: 8)
                    }
                }
                .opacity(contentOpacity)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: AnimationDuration.medium)) {
                contentOpacity = 1.0
            }
            // Ellipsis animator (every 0.5s)
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                dotsIndex = (dotsIndex + 1) % dotsFrames.count
            }
            // 3-step progress: one dot per second up to 3
            step = 0
            stepTimer?.invalidate()
            stepTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
                if step < 3 { step += 1 } else { t.invalidate() }
            }
        }
        .onDisappear {
            stepTimer?.invalidate()
            stepTimer = nil
        }
    }
    
    // Map sign names to Unicode glyphs used elsewhere in the app
    private func signSymbol(for name: String) -> String {
        switch name.lowercased() {
        case "aries": return "\u{2648}"
        case "taurus": return "\u{2649}"
        case "gemini": return "\u{264A}"
        case "cancer": return "\u{264B}"
        case "leo": return "\u{264C}"
        case "virgo": return "\u{264D}"
        case "libra": return "\u{264E}"
        case "scorpio": return "\u{264F}"
        case "sagittarius": return "\u{2650}"
        case "capricorn": return "\u{2651}"
        case "aquarius": return "\u{2652}"
        case "pisces": return "\u{2653}"
        default: return "\u{2605}" // star fallback
        }
    }
}

// MARK: - Landing View
struct LandingView: View {
    let onGetStarted: () -> Void
    @State private var isAnimating = false
    @State private var moonRotation = 0.0
    @State private var contentOpacity = 0.0
    @State private var buttonPressed = false
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground.edgesIgnoringSafeArea(.all)
            StarfieldView(isAnimating: isAnimating)
            
            VStack(spacing: Spacing.sectionMedium) {
                Spacer().frame(height: Spacing.huge + Spacing.xxxl)
                
                AnimatedCrescentMoonView(rotation: moonRotation)
                    .frame(width: Sizing.iconMedium, height: Sizing.iconMedium)
                    .scaleEffect(contentOpacity)
                
                Spacer().frame(height: Spacing.xxl)
                
                Text("Astrology Match")
                    .font(Typography.displayLarge)
                    .foregroundColor(AppColors.starWhite)
                    .multilineTextAlignment(.center)
                    .opacity(contentOpacity)
                
                Text("The Social Astrology App")
                    .font(Typography.bodyMedium)
                    .foregroundColor(AppColors.overlayLight)
                    .opacity(contentOpacity)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: AnimationDuration.medium, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.fast) {
                        onGetStarted()
                        buttonPressed = false
                    }
                }) {
                    Text("GET STARTED")
                }
                .appButtonStyle(.primary, isPressed: buttonPressed)
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xxxl)
                .opacity(contentOpacity)
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation(.easeIn(duration: AnimationDuration.verySlow)) {
                contentOpacity = 1.0
            }
            withAnimation(.linear(duration: AnimationDuration.moonRotation).repeatForever(autoreverses: false)) {
                moonRotation = 360
            }
        }
    }
}

// MARK: - User Info View
struct UserInfoView: View {
    @Binding var name: String
    @Binding var birthday: Date
    @Binding var timeOfBirth: Date
    @State private var wheelRotation = 0.0
    @State private var contentScale = 0.8
    @State private var buttonPressed = false
    @FocusState private var isNameFocused: Bool
    @State private var hasSetBirthday = false
    @State private var hasSetTime = false
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && hasSetBirthday && hasSetTime
    }
    let onContinue: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Back button in upper left
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "chevron.left")
                                .font(Typography.bodyMedium.weight(.medium))
                            Text("Back")
                                .font(Typography.bodyMedium)
                        }
                        .foregroundColor(AppColors.primaryText)
                    }
                    Spacer()
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xxxl)
                .frame(height: Sizing.buttonHeightLarge)
                
                Spacer()
                    .frame(height: Spacing.xxl)
                
                VStack(spacing: Spacing.md) {
                    Text("Let's get to know you.")
                        .font(Typography.displaySmall)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                
                }
                .scaleEffect(contentScale)
                
                AstrologyWheelView(rotation: wheelRotation)
                    .frame(width: Sizing.wheelMedium, height: Sizing.wheelMedium)
                    .padding(.vertical, Spacing.lg)
                    .scaleEffect(contentScale)
                
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    TextField("Name", text: $name)
                        .focused($isNameFocused)
                        .formFieldStyle(label: "Your Name", isFocused: isNameFocused)
                    
                    HStack(spacing: Spacing.lg) {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Birthday")
                                .font(Typography.labelSmall)
                                .foregroundColor(AppColors.secondaryText)
                            DatePicker("", selection: $birthday, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .onChange(of: birthday) { _, _ in
                                    hasSetBirthday = true
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Time of birth")
                                .font(Typography.labelSmall)
                                .foregroundColor(AppColors.secondaryText)
                            DatePicker("", selection: $timeOfBirth, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .onChange(of: timeOfBirth) { _, _ in
                                    hasSetTime = true
                                }
                        }
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .scaleEffect(contentScale)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: AnimationDuration.medium, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.fast) {
                        onContinue()
                        buttonPressed = false
                    }
                }) {
                    HStack(spacing: Spacing.xs) {
                        Text("CONTINUE")
                        Image(systemName: "arrow.right")
                    }
                }
                .appButtonStyle(isFormValid ? .primary : .secondary, isPressed: buttonPressed)
                .disabled(!isFormValid)
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xxxl)
                .scaleEffect(contentScale)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: AnimationDuration.slow)) {
                contentScale = 1.0
            }
            withAnimation(.linear(duration: AnimationDuration.wheelRotation).repeatForever(autoreverses: false)) {
                wheelRotation = 360
            }
        }
    }
}

// MARK: - Partner Info View
struct PartnerInfoView: View {
    @Binding var name: String
    @Binding var birthday: Date
    @Binding var timeOfBirth: Date
    @State private var wheelRotation = 0.0
    @State private var contentScale = 0.8
    @State private var buttonPressed = false
    @FocusState private var isNameFocused: Bool
    @State private var hasSetBirthday = false
    @State private var hasSetTime = false
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && hasSetBirthday && hasSetTime
    }
    let onSubmit: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Back button in upper left
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "chevron.left")
                                .font(Typography.bodyMedium.weight(.medium))
                            Text("Back")
                                .font(Typography.bodyMedium)
                        }
                        .foregroundColor(AppColors.primaryText)
                    }
                    Spacer()
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xxxl)
                .frame(height: Sizing.buttonHeightLarge)
                
                Spacer()
                    .frame(height: Spacing.xxl)
                
                VStack(spacing: Spacing.md) {
                    Text("Now tell us about them.")
                        .font(Typography.displaySmall)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                    
                }
                .scaleEffect(contentScale)
                
                AstrologyWheelView(rotation: wheelRotation)
                    .frame(width: Sizing.wheelMedium, height: Sizing.wheelMedium)
                    .padding(.vertical, Spacing.lg)
                    .scaleEffect(contentScale)
                
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    TextField("Name", text: $name)
                        .focused($isNameFocused)
                        .formFieldStyle(label: "Their Name", isFocused: isNameFocused)
                    
                    HStack(spacing: Spacing.lg) {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Birthday")
                                .font(Typography.labelSmall)
                                .foregroundColor(AppColors.secondaryText)
                            DatePicker("", selection: $birthday, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .onChange(of: birthday) { _, _ in
                                    hasSetBirthday = true
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Time of birth")
                                .font(Typography.labelSmall)
                                .foregroundColor(AppColors.secondaryText)
                            DatePicker("", selection: $timeOfBirth, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .onChange(of: timeOfBirth) { _, _ in
                                    hasSetTime = true
                                }
                        }
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .scaleEffect(contentScale)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: AnimationDuration.medium, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.fast) {
                        onSubmit()
                        buttonPressed = false
                    }
                }) {
                    HStack(spacing: Spacing.xs) {
                        Text("CONTINUE")
                        Image(systemName: "arrow.right")
                    }
                }
                .appButtonStyle(isFormValid ? .primary : .secondary, isPressed: buttonPressed)
                .disabled(!isFormValid)
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xxxl)
                .scaleEffect(contentScale)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: AnimationDuration.slow)) {
                contentScale = 1.0
            }
            withAnimation(.linear(duration: AnimationDuration.wheelRotation).repeatForever(autoreverses: false)) {
                wheelRotation = 360
            }
        }
    }
}

// MARK: - Component Views
struct StarfieldView: View {
    let isAnimating: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<20, id: \.self) { i in
                StarShape()
                    .fill(AppColors.starWhite)
                    .frame(width: CGFloat.random(in: 2...6), height: CGFloat.random(in: 2...6))
                    .opacity(isAnimating ? Double.random(in: 0.3...1.0) : 0.6)
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 50...geometry.size.height * 0.5)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 1...2))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...1)),
                        value: isAnimating
                    )
            }
        }
    }
}

struct AstrologyWheelView: View {
    let rotation: Double
    let zodiacSymbols = ["♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓"]
    
    var body: some View {
        ZStack {
            Circle().stroke(AppColors.dividerDefault, lineWidth: 1)
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(AppColors.dividerDefault)
                    .frame(width: 1, height: 125)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            ForEach(0..<12) { i in
                Text(zodiacSymbols[i])
                    .font(Typography.zodiacSymbol)
                    .foregroundColor(AppColors.tertiaryText)
                    .offset(y: -95)
                    .rotationEffect(.degrees(Double(i) * 30))
                    .rotationEffect(.degrees(-rotation))
            }
            .rotationEffect(.degrees(rotation))
            Circle()
                .fill(RadialGradient.sunGlow)
                .frame(width: Sizing.iconSmall, height: Sizing.iconSmall)
                .overlay(
                    ZStack {
                        ForEach(0..<12) { i in
                            Circle()
                                .fill(AppColors.sunOrange)
                                .frame(width: 3, height: 3)
                                .offset(y: -25)
                                .rotationEffect(.degrees(Double(i) * 30 + rotation))
                        }
                    }
                )
                .cardShadow(.glow)
        }
    }
}

struct AnimatedCrescentMoonView: View {
    let rotation: Double
    
    var body: some View {
        ZStack {
            Circle().fill(AppColors.starWhite).cardShadow(.glow)
            Circle().fill(AppColors.backgroundGradientTop).offset(x: 15)
            ForEach(0..<16) { i in
                Rectangle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 1.5, height: 25)
                    .offset(y: -50)
                    .rotationEffect(.degrees(Double(i) * 22.5 + rotation))
            }
        }
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let angle = CGFloat.pi / 4
        for i in 0..<8 {
            let isOuter = i % 2 == 0
            let radius = isOuter ? outerRadius : innerRadius
            let currentAngle = angle * CGFloat(i) - CGFloat.pi / 2
            let x = center.x + radius * cos(currentAngle)
            let y = center.y + radius * sin(currentAngle)
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
            else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Helper Functions
func combine(date: Date, time: Date) -> Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
    var merged = DateComponents()
    merged.year = dateComponents.year
    merged.month = dateComponents.month
    merged.day = dateComponents.day
    merged.hour = timeComponents.hour
    merged.minute = timeComponents.minute
    merged.second = timeComponents.second
    return calendar.date(from: merged) ?? date
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
