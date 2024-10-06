import Foundation
import SwiftUI

extension Font {

    static let primary: Self = .system(
        size: 60,
        weight: .bold,
        design: .monospaced
    )

    static let secondary: Self = .system(
        size: 30,
        weight: .bold,
        design: .monospaced
    )
    
    static let basicText: Self = .system(
        size: 20,
        weight: .regular,
        design: .monospaced
    )
}

extension View {

    static var semanticBackground: some View {
        Color(.defaultBackground)
    }
}
