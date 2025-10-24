//
//  ContentView.swift
//  astrologymatch
//
//  Created by Anantika Mannby on 10/7/25.
//

//
//  ContentView.swift
//  astrologymatch
//
//  Created by Anantika Mannby on 10/7/25.
//

import SwiftUI

// MARK: - Design System
enum AppColors {
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let tertiaryText = Color.gray.opacity(0.6)
    static let backgroundPrimary = Color.white
    static let backgroundGradientTop = Color(red: 0.05, green: 0.05, blue: 0.15)
    static let backgroundGradientMiddle = Color(red: 0.1, green: 0.08, blue: 0.2)
    static let backgroundGradientBottom = Color(red: 0.15, green: 0.1, blue: 0.25)
    static let starWhite = Color.white
    static let moonGlow = Color(red: 0.9, green: 0.9, blue: 1.0)
    static let sunYellow = Color(red: 1.0, green: 0.95, blue: 0.7)
    static let sunOrange = Color(red: 1.0, green: 0.8, blue: 0.4)
    static let cosmicPurple = Color(red: 0.4, green: 0.2, blue: 0.8)
    static let cosmicBlue = Color(red: 0.2, green: 0.4, blue: 0.9)
    static let dividerDefault = Color.gray.opacity(0.3)
    static let dividerFocused = Color.black
    static let inputText = Color.black
    static let disabledButton = Color.gray.opacity(0.3)
}

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
}

enum Typography {
    static let displayLarge = Font.system(size: 52, weight: .thin, design: .serif)
    static let displayMedium = Font.system(size: 36, weight: .light, design: .serif)
    static let displaySmall = Font.system(size: 28, weight: .light, design: .serif)
    static let bodyLarge = Font.system(size: 18, weight: .regular)
    static let bodyMedium = Font.system(size: 16, weight: .regular)
    static let bodySmall = Font.system(size: 14, weight: .regular)
    static let labelSmall = Font.system(size: 11, weight: .medium)
    static let buttonPrimary = Font.system(size: 15, weight: .semibold)
    static let zodiacSymbol = Font.system(size: 24)
}

enum Sizing {
    static let iconMedium: CGFloat = 100
    static let wheelMedium: CGFloat = 280
    static let buttonHeightSmall: CGFloat = 52
    static let buttonHeightMedium: CGFloat = 56
}

enum AnimationDuration {
    static let verySlow: Double = 1.2
    static let wheelRotation: Double = 40.0
    static let moonRotation: Double = 25.0
}

// MARK: - View Modifiers
struct GlassButton: ViewModifier {
    let isPressed: Bool
    var isDisabled: Bool = false
    var isPrimary: Bool = true
    
    func body(content: Content) -> some View {
        content
            .font(Typography.buttonPrimary)
            .foregroundColor(isPrimary ? .white : AppColors.primaryText)
            .frame(maxWidth: .infinity)
            .frame(height: Sizing.buttonHeightSmall)
            .background(
                ZStack {
                    if isPrimary {
                        RoundedRectangle(cornerRadius: 26)
                            .fill(LinearGradient(
                                colors: isDisabled ? [AppColors.disabledButton] : [AppColors.primaryText, Color.black.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                    } else {
                        RoundedRectangle(cornerRadius: 26)
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 26)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
            )
            .scaleEffect(isPressed && !isDisabled ? 0.96 : 1.0)
            .opacity(isDisabled ? 0.5 : 1.0)
            .shadow(color: isPrimary ? Color.black.opacity(0.3) : Color.clear, radius: 8, y: 4)
    }
}

struct CosmicButton: ViewModifier {
    let isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(Typography.buttonPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: Sizing.buttonHeightSmall)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 26)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
    }
}

struct EnhancedFormField: ViewModifier {
    let label: String
    let isFocused: Bool
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(Typography.labelSmall)
                .foregroundColor(AppColors.secondaryText)
                .textCase(.uppercase)
                .tracking(0.5)
            
            content
                .font(Typography.bodyMedium)
                .foregroundColor(AppColors.inputText)
                .padding(.vertical, Spacing.sm)
                .padding(.horizontal, Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? AppColors.primaryText : Color.clear, lineWidth: 1.5)
                )
        }
    }
}

extension View {
    func glassButton(isPressed: Bool = false, isDisabled: Bool = false, isPrimary: Bool = true) -> some View {
        self.modifier(GlassButton(isPressed: isPressed, isDisabled: isDisabled, isPrimary: isPrimary))
    }
    
    func cosmicButton(isPressed: Bool = false) -> some View {
        self.modifier(CosmicButton(isPressed: isPressed))
    }
    
    func enhancedFormField(label: String, isFocused: Bool = false) -> some View {
        self.modifier(EnhancedFormField(label: label, isFocused: isFocused))
    }
}

extension LinearGradient {
    static var cosmicBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                AppColors.backgroundGradientTop,
                AppColors.backgroundGradientMiddle,
                AppColors.backgroundGradientBottom,
                Color(red: 0.1, green: 0.05, blue: 0.2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Main App
struct ContentView: View {
    @State private var currentScreen = 0
    @State private var userName: String = ""
    @State private var userBirthday: Date = Date()
    @State private var userTimeOfBirth: Date = Date()
    @State private var partnerName: String = ""
    @State private var partnerBirthday: Date = Date()
    @State private var partnerTimeOfBirth: Date = Date()
    @State private var compatibilityData: SupabaseService.CompatibilityResponse?
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case 0:
                LandingView(onGetStarted: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        currentScreen = 1
                    }
                })
                .transition(.opacity)
            case 1:
                UserInfoView(
                    name: $userName,
                    birthday: $userBirthday,
                    timeOfBirth: $userTimeOfBirth,
                    onContinue: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            currentScreen = 2
                        }
                    },
                    onBack: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            currentScreen = 0
                        }
                    }
                )
                .transition(.opacity)
            case 2:
                PartnerInfoView(
                    name: $partnerName,
                    birthday: $partnerBirthday,
                    timeOfBirth: $partnerTimeOfBirth,
                    onSubmit: {
                        fetchCompatibilityData()
                    },
                    onBack: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            currentScreen = 1
                        }
                    }
                )
                .transition(.opacity)
            case 3:
                ResultsView(
                    userName: userName,
                    partnerName: partnerName,
                    userBirthday: userBirthday,
                    partnerBirthday: partnerBirthday,
                    userTimeOfBirth: userTimeOfBirth,
                    partnerTimeOfBirth: partnerTimeOfBirth,
                    compatibilityData: compatibilityData,
                    onStartOver: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            resetApp()
                        }
                    }
                )
                .transition(.opacity)
            default:
                EmptyView()
            }
        }
        .ignoresSafeArea()
    }
    
    private func resetApp() {
        currentScreen = 0
        userName = ""
        userBirthday = Date()
        userTimeOfBirth = Date()
        partnerName = ""
        partnerBirthday = Date()
        partnerTimeOfBirth = Date()
        compatibilityData = nil
    }
    
    private func fetchCompatibilityData() {
        let userSign = ZodiacUtils.zodiacSignName(from: userBirthday)
        let partnerSign = ZodiacUtils.zodiacSignName(from: partnerBirthday)
        
        SupabaseService.shared.getCompatibility(sign1: userSign, sign2: partnerSign) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let compatibility):
                    self.compatibilityData = compatibility
                    self.storePairingData(compatibility: compatibility)
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        self.currentScreen = 3
                    }
                case .failure(_):
                    let fallbackCompatibility = SupabaseService.CompatibilityResponse(
                        Sign1: userSign,
                        Sign2: partnerSign,
                        CompatibilityScore: 75,
                        Blurb: "Your cosmic connection shows promising alignment. The stars suggest a natural harmony between your energies."
                    )
                    self.compatibilityData = fallbackCompatibility
                    self.storePairingData(compatibility: fallbackCompatibility)
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        self.currentScreen = 3
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
        ) { _ in }
    }
}

// MARK: - Landing View
struct LandingView: View {
    let onGetStarted: () -> Void
    @State private var isAnimating = false
    @State private var moonRotation = 0.0
    @State private var contentOpacity = 0.0
    @State private var contentScale = 0.9
    @State private var buttonPressed = false
    @State private var particleOffset: [CGFloat] = Array(repeating: 0, count: 30)
    
    var body: some View {
        ZStack {
            LinearGradient.cosmicBackground
                .ignoresSafeArea()
            
            EnhancedStarfieldView(isAnimating: isAnimating)
            CosmicParticlesView(offsets: particleOffset)
            
            VStack(spacing: 0) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColors.moonGlow.opacity(0.3), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .blur(radius: 20)
                    
                    EnhancedCrescentMoonView(rotation: moonRotation)
                        .frame(width: Sizing.iconMedium, height: Sizing.iconMedium)
                }
                .scaleEffect(contentScale)
                .opacity(contentOpacity)
                
                Spacer().frame(height: Spacing.xxxl)
                
                VStack(spacing: Spacing.md) {
                    Text("Astrology")
                        .font(Typography.displayLarge)
                        .foregroundColor(.white)
                    
                    Text("Match")
                        .font(Typography.displayLarge)
                        .foregroundColor(.white)
                        .overlay(
                            LinearGradient(
                                colors: [.white, AppColors.moonGlow, AppColors.cosmicPurple.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(
                                Text("Match")
                                    .font(Typography.displayLarge)
                            )
                        )
                    
                    Text("Discover your cosmic connection")
                        .font(Typography.bodyMedium)
                        .foregroundColor(Color.white.opacity(0.7))
                        .padding(.top, Spacing.xs)
                }
                .multilineTextAlignment(.center)
                .scaleEffect(contentScale)
                .opacity(contentOpacity)
                
                Spacer()
                
                Button(action: {
                    let haptic = UIImpactFeedbackGenerator(style: .medium)
                    haptic.impactOccurred()
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        buttonPressed = false
                        onGetStarted()
                    }
                }) {
                    Text("Begin Your Journey")
                }
                .cosmicButton(isPressed: buttonPressed)
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.huge)
                .scaleEffect(contentScale)
                .opacity(contentOpacity)
            }
        }
        .onAppear {
            isAnimating = true
            
            withAnimation(.easeOut(duration: AnimationDuration.verySlow)) {
                contentOpacity = 1.0
                contentScale = 1.0
            }
            
            withAnimation(.linear(duration: AnimationDuration.moonRotation).repeatForever(autoreverses: false)) {
                moonRotation = 360
            }
            
            for i in 0..<30 {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 2...4))
                    .repeatForever(autoreverses: true)
                    .delay(Double(i) * 0.1)
                ) {
                    particleOffset[i] = CGFloat.random(in: -30...30)
                }
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
    @State private var contentScale = 0.85
    @State private var contentOpacity = 0.0
    @State private var buttonPressed = false
    @State private var birthdaySet = false
    @State private var timeSet = false
    @FocusState private var isNameFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    let onContinue: () -> Void
    let onBack: () -> Void

    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && birthdaySet && timeSet
    }

    private var userZodiacSign: String? {
        birthdaySet ? ZodiacUtils.zodiacSignName(from: birthday) : nil
    }

    var body: some View {
        ZStack {
            LinearGradient.cosmicBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        let haptic = UIImpactFeedbackGenerator(style: .light)
                        haptic.impactOccurred()
                        onBack()
                    }) {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(Typography.bodyMedium)
                        }
                        .foregroundColor(AppColors.backgroundPrimary)
                    }
                    Spacer()
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.md)
                .frame(height: Sizing.buttonHeightMedium)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.lg) {
                        Spacer().frame(height: Spacing.xs)

                        VStack(spacing: Spacing.sm) {
                            Text("Tell us about you")
                                .font(Typography.displaySmall)
                                .foregroundColor(AppColors.backgroundPrimary)

                            if let zodiacSign = userZodiacSign {
                                HStack(spacing: Spacing.xs) {
                                    Text(ZodiacUtils.zodiacEmoji(zodiacSign))
                                        .font(.system(size: 20))
                                    Text(zodiacSign)
                                        .font(Typography.bodyLarge)
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }

                        EnhancedAstrologyWheel(rotation: wheelRotation, highlightedSign: userZodiacSign)
                            .frame(width: Sizing.wheelMedium, height: Sizing.wheelMedium)
                            .padding(.vertical, Spacing.md)

                        VStack(spacing: Spacing.lg) {
                            TextField("", text: $name, prompt: Text("Enter your name").foregroundColor(AppColors.tertiaryText))
                                .focused($isNameFocused)
                                .enhancedFormField(label: "Your Name", isFocused: isNameFocused)

                            HStack(spacing: Spacing.md) {
                                VStack(alignment: .leading, spacing: Spacing.xs) {
                                    Text("Birthday")
                                        .font(Typography.labelSmall)
                                        .foregroundColor(AppColors.secondaryText)
                                        .textCase(.uppercase)
                                        .tracking(0.5)

                                    if !birthdaySet {
                                        Button(action: {
                                            birthdaySet = true
                                            let haptic = UIImpactFeedbackGenerator(style: .light)
                                            haptic.impactOccurred()
                                        }) {
                                            Text("Select date")
                                                .font(Typography.bodyMedium)
                                                .foregroundColor(AppColors.tertiaryText)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.vertical, Spacing.sm)
                                                .padding(.horizontal, Spacing.md)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.white)
                                                        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                                                )
                                        }
                                    } else {
                                        DatePicker("", selection: $birthday, displayedComponents: .date)
                                            .labelsHidden()
                                            .datePickerStyle(.compact)
                                            .accentColor(AppColors.primaryText)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.vertical, Spacing.xs)
                                            .padding(.horizontal, Spacing.sm)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white)
                                                    .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                                            )
                                            .onChange(of: birthday) { _, _ in
                                                updateWheelRotation()
                                            }
                                    }
                                }

                                VStack(alignment: .leading, spacing: Spacing.xs) {
                                    Text("Time")
                                        .font(Typography.labelSmall)
                                        .foregroundColor(AppColors.secondaryText)
                                        .textCase(.uppercase)
                                        .tracking(0.5)

                                    if !timeSet {
                                        Button(action: {
                                            timeSet = true
                                            let haptic = UIImpactFeedbackGenerator(style: .light)
                                            haptic.impactOccurred()
                                        }) {
                                            Text("Select time")
                                                .font(Typography.bodyMedium)
                                                .foregroundColor(AppColors.tertiaryText)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.vertical, Spacing.sm)
                                                .padding(.horizontal, Spacing.md)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.white)
                                                        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                                                )
                                        }
                                    } else {
                                        DatePicker("", selection: $timeOfBirth, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .datePickerStyle(.compact)
                                            .accentColor(AppColors.primaryText)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.vertical, Spacing.xs)
                                            .padding(.horizontal, Spacing.sm)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white)
                                                    .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                                            )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.xl)

                        Button(action: {
                            guard isFormValid else { return }
                            let haptic = UIImpactFeedbackGenerator(style: .medium)
                            haptic.impactOccurred()

                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                buttonPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                buttonPressed = false
                                onContinue()
                            }
                        }) {
                            HStack(spacing: Spacing.xs) {
                                Text("Continue")
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                        .glassButton(isPressed: buttonPressed, isDisabled: !isFormValid)
                        .disabled(!isFormValid)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.lg)
                        .padding(.bottom, Spacing.huge)
                    }
                    .padding(.bottom, keyboardHeight)
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            .scaleEffect(contentScale)
            .opacity(contentOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                contentScale = 1.0
                contentOpacity = 1.0
            }
            startInitialRotation()
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.keyboardHeight = frame.height
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }
    }

    private func startInitialRotation() {
        withAnimation(.linear(duration: AnimationDuration.wheelRotation).repeatForever(autoreverses: false)) {
            wheelRotation = 360
        }
    }

    private func updateWheelRotation() {
        guard let sign = userZodiacSign else { return }
        let signIndex = ZodiacUtils.zodiacSignIndex(sign)
        let targetRotation = Double(signIndex) * 30

        withAnimation(.spring(response: 1.2, dampingFraction: 0.7)) {
            wheelRotation = targetRotation
        }
    }
}

// MARK: - Partner Info View
struct PartnerInfoView: View {
    @Binding var name: String
    @Binding var birthday: Date
    @Binding var timeOfBirth: Date
    @State private var wheelRotation = 0.0
    @State private var contentScale = 0.85
    @State private var contentOpacity = 0.0
    @State private var buttonPressed = false
    @State private var birthdaySet = false
    @State private var timeSet = false
    @State private var isLoading = false
    @FocusState private var isNameFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    let onSubmit: () -> Void
    let onBack: () -> Void

    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && birthdaySet && timeSet
    }

    private var partnerZodiacSign: String? {
        birthdaySet ? ZodiacUtils.zodiacSignName(from: birthday) : nil
    }

    var body: some View {
        ZStack {
            LinearGradient.cosmicBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        let haptic = UIImpactFeedbackGenerator(style: .light)
                        haptic.impactOccurred()
                        onBack()
                    }) {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(Typography.bodyMedium)
                        }
                        .foregroundColor(AppColors.backgroundPrimary)
                    }
                    Spacer()
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.md)
                .frame(height: Sizing.buttonHeightMedium)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.lg) {
                        Spacer().frame(height: Spacing.xs)

                        VStack(spacing: Spacing.sm) {
                            Text("Tell us about them")
                                .font(Typography.displaySmall)
                                .foregroundColor(AppColors.backgroundPrimary)

                            if let zodiacSign = partnerZodiacSign {
                                HStack(spacing: Spacing.xs) {
                                    Text(ZodiacUtils.zodiacEmoji(zodiacSign))
                                        .font(.system(size: 20))
                                    Text(zodiacSign)
                                        .font(Typography.bodyLarge)
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }

                        EnhancedAstrologyWheel(rotation: wheelRotation, highlightedSign: partnerZodiacSign)
                            .frame(width: Sizing.wheelMedium, height: Sizing.wheelMedium)
                            .padding(.vertical, Spacing.md)

                        VStack(spacing: Spacing.lg) {
                            TextField("", text: $name, prompt: Text("Enter their name").foregroundColor(AppColors.tertiaryText))
                                .focused($isNameFocused)
                                .enhancedFormField(label: "Their Name", isFocused: isNameFocused)

                            HStack(spacing: Spacing.md) {
                                VStack(alignment: .leading, spacing: Spacing.xs) {
                                    Text("Birthday")
                                        .font(Typography.labelSmall)
                                        .foregroundColor(AppColors.secondaryText)
                                        .textCase(.uppercase)
                                        .tracking(0.5)

                                    if !birthdaySet {
                                        Button(action: {
                                            birthdaySet = true
                                            let haptic = UIImpactFeedbackGenerator(style: .light)
                                            haptic.impactOccurred()
                                        }) {
                                            Text("Select date")
                                                .font(Typography.bodyMedium)
                                                .foregroundColor(AppColors.tertiaryText)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.vertical, Spacing.sm)
                                                .padding(.horizontal, Spacing.md)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.white)
                                                        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                                                )
                                        }
                                    } else {
                                        DatePicker("", selection: $birthday, displayedComponents: .date)
                                            .labelsHidden()
                                            .datePickerStyle(.compact)
                                            .accentColor(AppColors.primaryText)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.vertical, Spacing.xs)
                                            .padding(.horizontal, Spacing.sm)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white)
                                                    .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                                            )
                                            .onChange(of: birthday) { _, _ in
                                                updateWheelRotation()
                                            }
                                    }
                                }

                                VStack(alignment: .leading, spacing: Spacing.xs) {
                                    Text("Time")
                                        .font(Typography.labelSmall)
                                        .foregroundColor(AppColors.secondaryText)
                                        .textCase(.uppercase)
                                        .tracking(0.5)

                                    if !timeSet {
                                        Button(action: {
                                            timeSet = true
                                            let haptic = UIImpactFeedbackGenerator(style: .light)
                                            haptic.impactOccurred()
                                        }) {
                                            Text("Select time")
                                                .font(Typography.bodyMedium)
                                                .foregroundColor(AppColors.tertiaryText)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.vertical, Spacing.sm)
                                                .padding(.horizontal, Spacing.md)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.white)
                                                        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                                                )
                                        }
                                    } else {
                                        DatePicker("", selection: $timeOfBirth, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .datePickerStyle(.compact)
                                            .accentColor(AppColors.primaryText)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.vertical, Spacing.xs)
                                            .padding(.horizontal, Spacing.sm)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white)
                                                    .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                                            )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.xl)

                        Button(action: {
                            guard isFormValid else { return }
                            let haptic = UIImpactFeedbackGenerator(style: .medium)
                            haptic.impactOccurred()

                            isLoading = true
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                buttonPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                buttonPressed = false
                                onSubmit()
                            }
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                HStack(spacing: Spacing.xs) {
                                    Text("See Your Match")
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                        }
                        .glassButton(isPressed: buttonPressed, isDisabled: !isFormValid)
                        .disabled(!isFormValid || isLoading)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.top, Spacing.lg)
                        .padding(.bottom, Spacing.huge)
                    }
                    .padding(.bottom, keyboardHeight)
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            .scaleEffect(contentScale)
            .opacity(contentOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                contentScale = 1.0
                contentOpacity = 1.0
            }
            startInitialRotation()
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.keyboardHeight = frame.height
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }
    }

    private func startInitialRotation() {
        withAnimation(.linear(duration: AnimationDuration.wheelRotation).repeatForever(autoreverses: false)) {
            wheelRotation = 360
        }
    }

    private func updateWheelRotation() {
        guard let sign = partnerZodiacSign else { return }
        let signIndex = ZodiacUtils.zodiacSignIndex(sign)
        let targetRotation = Double(signIndex) * 30

        withAnimation(.spring(response: 1.2, dampingFraction: 0.7)) {
            wheelRotation = targetRotation
        }
    }
}

// MARK: - Results View
struct ResultsView: View {
    let userName: String
    let partnerName: String
    let userBirthday: Date
    let partnerBirthday: Date
    let userTimeOfBirth: Date
    let partnerTimeOfBirth: Date
    let compatibilityData: SupabaseService.CompatibilityResponse?
    let onStartOver: () -> Void
    
    @State private var contentScale = 0.8
    @State private var contentOpacity = 0.0
    @State private var scoreAnimated = 0.0
    @State private var particleOffset: [CGFloat] = Array(repeating: 0, count: 20)
    @State private var buttonPressed = false
    @State private var allCompatibilityData: [SupabaseService.CompatibilityResponse] = []
    @State private var pastPairings: [SupabaseService.PairingResponse] = []
    
    private var userSign: String {
        ZodiacUtils.zodiacSignName(from: userBirthday)
    }
    
    private var partnerSign: String {
        ZodiacUtils.zodiacSignName(from: partnerBirthday)
    }
    
    private var score: Int {
        compatibilityData?.CompatibilityScore ?? 75
    }
    
    private var scoreColor: Color {
        switch score {
        case 80...100: return Color.green
        case 60..<80: return Color.orange
        default: return Color.red
        }
    }
    
    private var formattedUserBirthday: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: userBirthday)
    }
    
    private var formattedPartnerBirthday: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: partnerBirthday)
    }
    
    private var formattedUserTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: userTimeOfBirth)
    }
    
    private var formattedPartnerTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: partnerTimeOfBirth)
    }
    
    private var topCompatibleSigns: [SupabaseService.CompatibilityResponse] {
        allCompatibilityData
            .filter { $0.Sign1 == userSign || $0.Sign2 == userSign }
            .sorted { $0.CompatibilityScore > $1.CompatibilityScore }
            .prefix(3)
            .map { $0 }
    }
    
    var body: some View {
        ZStack {
            LinearGradient.cosmicBackground
                .ignoresSafeArea()
            
            EnhancedStarfieldView(isAnimating: true)
            CosmicParticlesView(offsets: particleOffset)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.xl) {
                    Spacer().frame(height: Spacing.xxxl + 20)
                    
                    VStack(spacing: Spacing.md) {
                        Text("Your Cosmic")
                            .font(Typography.displayMedium)
                            .foregroundColor(.white)
                        
                        Text("Connection")
                            .font(Typography.displayMedium)
                            .foregroundColor(.white)
                            .overlay(
                                LinearGradient(
                                    colors: [.white, AppColors.moonGlow, AppColors.cosmicPurple.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .mask(
                                    Text("Connection")
                                        .font(Typography.displayMedium)
                                )
                            )
                    }
                    .multilineTextAlignment(.center)
                    
                    HStack(spacing: Spacing.xxl) {
                        VStack(spacing: Spacing.xs) {
                            Text(ZodiacUtils.zodiacEmoji(userSign))
                                .font(.system(size: 40))
                            Text(userName)
                                .font(Typography.bodyLarge)
                                .foregroundColor(.white)
                            Text(userSign)
                                .font(Typography.bodySmall)
                                .foregroundColor(.white.opacity(0.6))
                            Text(formattedUserBirthday)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.5))
                            Text(formattedUserTime)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.cosmicPurple.opacity(0.6))
                        
                        VStack(spacing: Spacing.xs) {
                            Text(ZodiacUtils.zodiacEmoji(partnerSign))
                                .font(.system(size: 40))
                            Text(partnerName)
                                .font(Typography.bodyLarge)
                                .foregroundColor(.white)
                            Text(partnerSign)
                                .font(Typography.bodySmall)
                                .foregroundColor(.white.opacity(0.6))
                            Text(formattedPartnerBirthday)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.5))
                            Text(formattedPartnerTime)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }
                    .padding(.vertical, Spacing.lg)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 8)
                            .frame(width: 180, height: 180)
                        
                        Circle()
                            .trim(from: 0, to: scoreAnimated / 100)
                            .stroke(
                                LinearGradient(
                                    colors: [scoreColor, scoreColor.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 180, height: 180)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: Spacing.xxs) {
                            Text("\(Int(scoreAnimated))%")
                                .font(.system(size: 56, weight: .light))
                                .foregroundColor(.white)
                            
                            Text("Compatible")
                                .font(Typography.bodySmall)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.vertical, Spacing.lg)
                    
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        if let blurb = compatibilityData?.Blurb {
                            Text(blurb)
                                .font(Typography.bodyMedium)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)
                                .multilineTextAlignment(.leading)
                                .padding(Spacing.xl)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                        }
                    }
                    .padding(.horizontal, Spacing.xl)
                    
                    // Other Compatible Signs Section
                    if !topCompatibleSigns.isEmpty {
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("Other Compatible Signs for \(userName)")
                                .font(Typography.bodyLarge)
                                .foregroundColor(.white)
                                .padding(.horizontal, Spacing.xl)
                            
                            ForEach(topCompatibleSigns) { compat in
                                let otherSign = compat.Sign1 == userSign ? compat.Sign2 : compat.Sign1
                                
                                HStack(spacing: Spacing.md) {
                                    Text(ZodiacUtils.zodiacEmoji(otherSign))
                                        .font(.system(size: 28))
                                    
                                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                                        Text(otherSign)
                                            .font(Typography.bodyMedium)
                                            .foregroundColor(.white)
                                        Text("\(compat.CompatibilityScore)% Compatible")
                                            .font(Typography.bodySmall)
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .fill(
                                            compat.CompatibilityScore >= 80 ? Color.green.opacity(0.3) :
                                            compat.CompatibilityScore >= 60 ? Color.orange.opacity(0.3) :
                                            Color.red.opacity(0.3)
                                        )
                                        .frame(width: 8, height: 8)
                                }
                                .padding(Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                        )
                                )
                                .padding(.horizontal, Spacing.xl)
                            }
                        }
                    }
                    
                    // Past Connections Section
                    if !pastPairings.isEmpty {
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("Past Connections")
                                .font(Typography.bodyLarge)
                                .foregroundColor(.white)
                                .padding(.horizontal, Spacing.xl)
                            
                            ForEach(pastPairings.prefix(5)) { pairing in
                                VStack(alignment: .leading, spacing: Spacing.xs) {
                                    HStack {
                                        Text("\(pairing.a_name) & \(pairing.b_name)")
                                            .font(Typography.bodyMedium)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text("\(pairing.score)%")
                                            .font(Typography.labelSmall)
                                            .foregroundColor(.white.opacity(0.8))
                                            .padding(.horizontal, Spacing.sm)
                                            .padding(.vertical, Spacing.xxs)
                                            .background(
                                                Capsule()
                                                    .fill(Color.white.opacity(0.2))
                                            )
                                    }
                                    
                                    Text(formatPairingDate(pairing.created_at))
                                        .font(.system(size: 11))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                        )
                                )
                                .padding(.horizontal, Spacing.xl)
                            }
                        }
                    }
                    
                    Button(action: {
                        let haptic = UIImpactFeedbackGenerator(style: .medium)
                        haptic.impactOccurred()
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            buttonPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            buttonPressed = false
                            onStartOver()
                        }
                    }) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Start Over")
                        }
                    }
                    .cosmicButton(isPressed: buttonPressed)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.bottom, Spacing.huge)
                }
            }
            .scaleEffect(contentScale)
            .opacity(contentOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                contentScale = 1.0
                contentOpacity = 1.0
            }
            
            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                scoreAnimated = Double(score)
            }
            
            for i in 0..<20 {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 2...4))
                    .repeatForever(autoreverses: true)
                    .delay(Double(i) * 0.1)
                ) {
                    particleOffset[i] = CGFloat.random(in: -30...30)
                }
            }
            
            // Fetch all compatibility data
            SupabaseService.shared.getAllCompatibilityData { result in
                if case .success(let data) = result {
                    DispatchQueue.main.async {
                        allCompatibilityData = data
                    }
                }
            }
            
            // Fetch past pairings
            SupabaseService.shared.getAllPairingsData { result in
                if case .success(let data) = result {
                    DispatchQueue.main.async {
                        pastPairings = data
                    }
                }
            }
        }
    }
    
    private func formatPairingDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: dateString) else { return dateString }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
                                                        // MARK: - Enhanced Components
                                                        struct EnhancedStarfieldView: View {
                                                            let isAnimating: Bool
                                                            
                                                            var body: some View {
                                                                GeometryReader { geometry in
                                                                    ForEach(0..<50, id: \.self) { i in
                                                                        Circle()
                                                                            .fill(Color.white)
                                                                            .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3))
                                                                            .opacity(isAnimating ? Double.random(in: 0.2...0.9) : 0.4)
                                                                            .position(
                                                                                x: CGFloat.random(in: 0...geometry.size.width),
                                                                                y: CGFloat.random(in: 0...geometry.size.height)
                                                                            )
                                                                            .animation(
                                                                                Animation.easeInOut(duration: Double.random(in: 1.5...3.5))
                                                                                    .repeatForever(autoreverses: true)
                                                                                    .delay(Double.random(in: 0...2)),
                                                                                value: isAnimating
                                                                            )
                                                                    }
                                                                }
                                                            }
                                                        }

                                                        struct CosmicParticlesView: View {
                                                            let offsets: [CGFloat]
                                                            
                                                            var body: some View {
                                                                GeometryReader { geometry in
                                                                    ForEach(0..<offsets.count, id: \.self) { i in
                                                                        Circle()
                                                                            .fill(
                                                                                LinearGradient(
                                                                                    colors: [
                                                                                        AppColors.cosmicPurple.opacity(0.3),
                                                                                        AppColors.cosmicBlue.opacity(0.2)
                                                                                    ],
                                                                                    startPoint: .topLeading,
                                                                                    endPoint: .bottomTrailing
                                                                                )
                                                                            )
                                                                            .frame(width: CGFloat.random(in: 4...12), height: CGFloat.random(in: 4...12))
                                                                            .blur(radius: CGFloat.random(in: 2...6))
                                                                            .position(
                                                                                x: CGFloat.random(in: 0...geometry.size.width),
                                                                                y: CGFloat.random(in: 0...geometry.size.height) + offsets[i]
                                                                            )
                                                                    }
                                                                }
                                                            }
                                                        }

                                                        struct EnhancedAstrologyWheel: View {
                                                            let rotation: Double
                                                            var highlightedSign: String? = nil
                                                            let zodiacSymbols = ["♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓"]
                                                            
                                                            var body: some View {
                                                                ZStack {
                                                                    Circle()
                                                                        .stroke(
                                                                            LinearGradient(
                                                                                colors: [AppColors.dividerDefault, AppColors.dividerDefault.opacity(0.3)],
                                                                                startPoint: .topLeading,
                                                                                endPoint: .bottomTrailing
                                                                            ),
                                                                            lineWidth: 2
                                                                        )
                                                                    
                                                                    ForEach(0..<12) { i in
                                                                        Rectangle()
                                                                            .fill(AppColors.dividerDefault.opacity(0.3))
                                                                            .frame(width: 1, height: 140)
                                                                            .rotationEffect(.degrees(Double(i) * 30))
                                                                    }
                                                                    
                                                                    ForEach(0..<12) { i in
                                                                        let isHighlighted = highlightedSign != nil && ZodiacUtils.zodiacSignIndex(highlightedSign!) == i
                                                                        Text(zodiacSymbols[i])
                                                                            .font(Typography.zodiacSymbol)
                                                                            .fontWeight(isHighlighted ? .bold : .regular)
                                                                            .foregroundColor(isHighlighted ? AppColors.primaryText : AppColors.tertiaryText)
                                                                            .scaleEffect(isHighlighted ? 1.4 : 1.0)
                                                                            .opacity(isHighlighted ? 1.0 : 0.5)
                                                                            .offset(y: -105)
                                                                            .rotationEffect(.degrees(Double(i) * 30))
                                                                            .rotationEffect(.degrees(-rotation))
                                                                            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isHighlighted)
                                                                    }
                                                                    .rotationEffect(.degrees(rotation))
                                                                    
                                                                    Circle()
                                                                        .fill(
                                                                            RadialGradient(
                                                                                colors: [AppColors.sunYellow, AppColors.sunOrange.opacity(0.4), Color.clear],
                                                                                center: .center,
                                                                                startRadius: 0,
                                                                                endRadius: 40
                                                                            )
                                                                        )
                                                                        .frame(width: 80, height: 80)
                                                                        .overlay(
                                                                            ZStack {
                                                                                ForEach(0..<8) { i in
                                                                                    Capsule()
                                                                                        .fill(AppColors.sunOrange.opacity(0.6))
                                                                                        .frame(width: 2, height: 8)
                                                                                        .offset(y: -35)
                                                                                        .rotationEffect(.degrees(Double(i) * 45 + rotation * 0.5))
                                                                                }
                                                                            }
                                                                        )
                                                                        .shadow(color: AppColors.sunYellow.opacity(0.5), radius: 20)
                                                                }
                                                            }
                                                        }

                                                        struct EnhancedCrescentMoonView: View {
                                                            let rotation: Double
                                                            
                                                            var body: some View {
                                                                ZStack {
                                                                    Circle()
                                                                        .fill(AppColors.moonGlow)
                                                                        .shadow(color: AppColors.moonGlow.opacity(0.6), radius: 30)
                                                                    
                                                                    Circle()
                                                                        .fill(AppColors.backgroundGradientTop)
                                                                        .offset(x: 20)
                                                                    
                                                                    ForEach(0..<12) { i in
                                                                        Rectangle()
                                                                            .fill(Color.white.opacity(0.4))
                                                                            .frame(width: 1, height: 20)
                                                                            .offset(y: -55)
                                                                            .rotationEffect(.degrees(Double(i) * 30 + rotation))
                                                                    }
                                                                }
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
