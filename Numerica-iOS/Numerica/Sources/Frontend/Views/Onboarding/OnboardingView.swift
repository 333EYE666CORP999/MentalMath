//
//  OnboardingView.swift
//  Numerica
//
//  Created by Emil Shpeklord on 06.10.2024.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        TabView {
            Text("First Page")
                .tabItem { Text("Page 1") }
            Text("Second Page")
                .tabItem { Text("Page 2") }
            Text("Third Page")
                .tabItem { Text("Page 3") }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .tabViewStyle(.page)
    }
}
