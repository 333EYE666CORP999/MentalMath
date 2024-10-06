//
//  OnboardingView.swift
//  Numerica
//
//  Created by Emil Shpeklord on 06.10.2024.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
            Spacer()
            TabView {
                OnboardingViewTab(
                    model: .init(
                        image: .firstOnboardingImage,
                        statement: .firstOnboardingStatement
                    )
                )
                OnboardingViewTab(
                    model: .init(
                        image: .secondOnboardingImage,
                        statement: .secondOnboardingStatement
                    )
                )
                OnboardingViewTab(
                    model: .init(
                        image: .thirdOnboardingImage,
                        statement: .thirdOnboardingStatement
                    )
                )
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .tabViewStyle(.page)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            TopAndSideBorder(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 2)
        )
        .background(.black)
    }
}
