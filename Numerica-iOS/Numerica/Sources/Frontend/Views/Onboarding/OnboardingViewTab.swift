//
//  OnboardingViewTab.swift
//  Numerica
//
//  Created by Emil Shpeklord on 06.10.2024.
//

import SwiftUI

// TODO: - refactor to own file and make a real VM
struct OnboardingViewTabModel {
    var image: Image
    var statement: String
}

struct OnboardingViewTab: View {
    let image: Image
    let statement: String

    init(model: OnboardingViewTabModel) {
        self.image = model.image
        self.statement = model.statement
    }

    var body: some View {
        VStack {
            Spacer()
            image
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.white)
            Spacer()
            Text(statement)
                .font(.basicText)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.vertical, 100)
    }
}
