//
//  ActionButton.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 05.09.2024.
//

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
