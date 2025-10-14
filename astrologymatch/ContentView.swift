//
//  ContentView.swift
//  astrologymatch
//
//  Created by Anantika Mannby on 10/7/25.
//

import SwiftUI

/ MARK: - Main App Structure
struct ContentView: View {
    @State private var currentScreen = 0
    
    var body: some View {
        TabView(selection: $currentScreen) {
            LandingView(onGetStarted: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentScreen = 1
                }
            })
            .tag(0)
            
            UserInfoView(
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
            
            PartnerInfoView(onBack: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentScreen = 1
                }
            })
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.all)
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
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.2, blue: 0.25),
                    Color(red: 0.15, green: 0.15, blue: 0.2),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Animated Twinkling Stars
            GeometryReader { geometry in
                ForEach(0..<20, id: \.self) { i in
                    StarShape()
                        .fill(Color.white)
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
            
            VStack(spacing: 16) {
                Spacer()
                    .frame(height: 100)
                
                // Animated Moon Icon
                AnimatedCrescentMoonView(rotation: moonRotation)
                    .frame(width: 80, height: 80)
                    .scaleEffect(contentOpacity)
                
                Spacer()
                    .frame(height: 30)
                
                // Title with fade-in
                Text("Astrology Match")
                    .font(.system(size: 48, weight: .light, design: .serif))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(contentOpacity)
                
                // Subtitle with fade-in
                Text("The Social Astrology App")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(contentOpacity)
                
                Spacer()
                
                // Get Started Button with press animation
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onGetStarted()
                        buttonPressed = false
                    }
                }) {
                    Text("GET STARTED")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.black)
                        .scaleEffect(buttonPressed ? 0.95 : 1.0)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(contentOpacity)
            }
        }
        .onAppear {
            // Start animations
            isAnimating = true
            withAnimation(.easeIn(duration: 1.0)) {
                contentOpacity = 1.0
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                moonRotation = 360
            }
        }
    }
}

// MARK: - User Info View
struct UserInfoView: View {
    @State private var name = ""
    @State private var birthday = Date()
    @State private var timeOfBirth = Date()
    @State private var wheelRotation = 0.0
    @State private var contentScale = 0.8
    @State private var buttonPressed = false
    @State private var backButtonPressed = false
    @FocusState private var focusedField: Field?
    @Environment(\.presentationMode) var presentationMode
    
    enum Field {
        case name
    }
    
    let onContinue: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                // Title at top with back button
                ZStack {
                    Text("Astrology Match")
                        .font(.system(size: 32, weight: .light, design: .serif))
                        .foregroundColor(.black)
                    
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                backButtonPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onBack()
                                backButtonPressed = false
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Back")
                                    .font(.system(size: 16, weight: .regular))
                            }
                            .foregroundColor(.black)
                            .scaleEffect(backButtonPressed ? 0.9 : 1.0)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 40)
                
                // Content Section
                VStack(spacing: 16) {
                    Text("Lets get to know you.")
                        .font(.system(size: 32, weight: .light, design: .serif))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Just tell us your birthday and the exact time you were born.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .scaleEffect(contentScale)
                
                // Animated Astrology Wheel
                AstrologyWheelView(rotation: wheelRotation)
                    .frame(width: 250, height: 250)
                    .padding(.vertical, 20)
                    .scaleEffect(contentScale)
                
                // Form Fields
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Name")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        TextField("Name", text: $name)
                            .font(.system(size: 16))
                            .padding(.bottom, 4)
                            .focused($focusedField, equals: .name)
                        Divider()
                            .background(focusedField == .name ? Color.black : Color.gray.opacity(0.3))
                    }
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Birthday")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            DatePicker("", selection: $birthday, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time of birth")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            DatePicker("", selection: $timeOfBirth, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .scaleEffect(contentScale)
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onContinue()
                        buttonPressed = false
                    }
                }) {
                    HStack {
                        Text("CONTINUE")
                            .font(.system(size: 14, weight: .medium))
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .scaleEffect(buttonPressed ? 0.95 : 1.0)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .scaleEffect(contentScale)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                contentScale = 1.0
            }
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                wheelRotation = 360
            }
        }
    }
}

// MARK: - Partner Info View
struct PartnerInfoView: View {
    @State private var name = ""
    @State private var birthday = Date()
    @State private var timeOfBirth = Date()
    @State private var wheelRotation = 0.0
    @State private var contentScale = 0.8
    @State private var buttonPressed = false
    @State private var backButtonPressed = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name
    }
    
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                // Title at top with back button
                ZStack {
                    Text("Astrology Match")
                        .font(.system(size: 32, weight: .light, design: .serif))
                        .foregroundColor(.black)
                    
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                backButtonPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onBack()
                                backButtonPressed = false
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Back")
                                    .font(.system(size: 16, weight: .regular))
                            }
                            .foregroundColor(.black)
                            .scaleEffect(backButtonPressed ? 0.9 : 1.0)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 40)
                
                VStack(spacing: 16) {
                    Text("Now tell us about them.")
                        .font(.system(size: 32, weight: .light, design: .serif))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Just tell us their birthday and the exact time they were born.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .scaleEffect(contentScale)
                
                AstrologyWheelView(rotation: wheelRotation)
                    .frame(width: 250, height: 250)
                    .padding(.vertical, 20)
                    .scaleEffect(contentScale)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Their Name")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        TextField("Name", text: $name)
                            .font(.system(size: 16))
                            .padding(.bottom, 4)
                            .focused($focusedField, equals: .name)
                        Divider()
                            .background(focusedField == .name ? Color.black : Color.gray.opacity(0.3))
                    }
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Birthday")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            DatePicker("", selection: $birthday, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time of birth")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            DatePicker("", selection: $timeOfBirth, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .scaleEffect(contentScale)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        // Handle completion
                        buttonPressed = false
                    }
                }) {
                    HStack {
                        Text("CONTINUE")
                            .font(.system(size: 14, weight: .medium))
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .scaleEffect(buttonPressed ? 0.95 : 1.0)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .scaleEffect(contentScale)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                contentScale = 1.0
            }
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                wheelRotation = 360
            }
        }
    }
}

// MARK: - Animated Astrology Wheel
struct AstrologyWheelView: View {
    let rotation: Double
    let zodiacSymbols = ["♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓"]
    
    var body: some View {
        ZStack {
            // Outer circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            
            // 12 division lines
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 1, height: 125)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            
            // Zodiac symbols on the outer ring
            ForEach(0..<12) { i in
                Text(zodiacSymbols[i])
                    .font(.system(size: 20))
                    .foregroundColor(.gray.opacity(0.6))
                    .offset(y: -95)
                    .rotationEffect(.degrees(Double(i) * 30))
                    .rotationEffect(.degrees(-rotation))
            }
            .rotationEffect(.degrees(rotation))
            
            // Inner sun circle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [Color.yellow.opacity(0.3), Color.white]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 30
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    ZStack {
                        // Sun rays as dots
                        ForEach(0..<12) { i in
                            Circle()
                                .fill(Color.orange.opacity(0.6))
                                .frame(width: 3, height: 3)
                                .offset(y: -25)
                                .rotationEffect(.degrees(Double(i) * 30 + rotation))
                        }
                    }
                )
                .shadow(color: .yellow.opacity(0.3), radius: 10)
        }
    }
}

// MARK: - Animated Crescent Moon
struct AnimatedCrescentMoonView: View {
    let rotation: Double
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .shadow(color: .white.opacity(0.5), radius: 20)
            
            Circle()
                .fill(Color(red: 0.2, green: 0.2, blue: 0.25))
                .offset(x: 15)
            
            // Animated rays around the moon
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

// MARK: - Custom Star Shape
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
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
