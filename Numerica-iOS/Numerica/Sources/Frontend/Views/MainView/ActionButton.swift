import SwiftUI

struct ActionButton: View {

    @Binding var title: String
    var action: () -> Void

    var body: some View {
        Button(
            title,
            action: action
        )
        .font(.primary)
        .foregroundStyle(.white)
    }
}
