import Foundation
import SwiftUI

struct ErrorShowingTextField: View {

    @Binding var text: String
    @Binding var placeholderText: String
    @Binding var placeholderColor: Color

    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Text(placeholderText)
                    .foregroundColor(placeholderColor)
                    .transition(.opacity)
                    .font(.secondary)
                    .multilineTextAlignment(.center)

                TextField("", text: $text)
                    .keyboardType(.numberPad)
                    .font(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityIdentifier(
                        "MainView.InputTextField"
                    )
            }
            .animation(
                .easeInOut(
                    duration: 0.5
                ),
                value: text.isEmpty
            )
            Spacer()
        }
    }
}

#Preview {
    ErrorShowingTextField(
        text: Binding<String>.constant("89"),
        placeholderText: Binding<String>.constant("gij"),
        placeholderColor: Binding<Color>.constant(.gray)
    )
}
