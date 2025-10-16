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
    enum Style { case primary, secondary }
    let style: Style
    let isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .font(Typography.buttonPrimary)
            .foregroundColor(style == .primary ? .white : AppColors.primaryText)
            .frame(maxWidth: .infinity)
            .frame(height: Sizing.buttonHeightSmall)
            .background(style == .primary ? AppColors.primaryText : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(style == .secondary ? AppColors.borderDefault : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
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
        TabView(selection: $currentScreen) {
            LandingView(onGetStarted: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentScreen = 1
                }
            })
            .tag(0)
            
            UserInfoView(
                name: $userName,
                birthday: $userBirthday,
                timeOfBirth: $userTimeOfBirth,
                onContinue: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = 2
                    }
                },
                onBack: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = 0
                    }
                }
            )
            .tag(1)
            
            PartnerInfoView(
                name: $partnerName,
                birthday: $partnerBirthday,
                timeOfBirth: $partnerTimeOfBirth,
                onSubmit: {
                    fetchCompatibilityData()
                },
                onBack: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = 1
                    }
                }
            )
            .tag(2)
            
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
                        currentScreen = 0
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
            .tag(3)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.all)
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
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.currentScreen = 3
                    }
                case .failure(_):
                    let fallbackCompatibility = SupabaseService.CompatibilityResponse(
                        Sign1: userSign,
                        Sign2: partnerSign,
                        CompatibilityScore: 75,
                        Blurb: "Unable to load detailed compatibility data. Your signs show good potential for connection."
                    )
                    self.compatibilityData = fallbackCompatibility
                    self.storePairingData(compatibility: fallbackCompatibility)
                    withAnimation(.easeInOut(duration: 0.5)) {
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
        ) { result in
            // Handle result silently
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
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Time of birth")
                                .font(Typography.labelSmall)
                                .foregroundColor(AppColors.secondaryText)
                            DatePicker("", selection: $timeOfBirth, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.compact)
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
                .appButtonStyle(.secondary, isPressed: buttonPressed)
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
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Time of birth")
                                .font(Typography.labelSmall)
                                .foregroundColor(AppColors.secondaryText)
                            DatePicker("", selection: $timeOfBirth, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.compact)
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
                .appButtonStyle(.secondary, isPressed: buttonPressed)
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
