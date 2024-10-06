//
//  PageView.swift
//  Numerica
//
//  Created by Emil Shpeklord on 06.10.2024.
//

import SwiftUI
import Combine

struct PageView<Content: View>: View {
    @Binding var currentPage: Int
    var pages: [Content]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<pages.count) { index in
                pages[index]
                    .frame(width: UIScreen.main.bounds.width)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Handle drag changes to update currentPage
                }
                .onEnded { value in
                    // Finalize page change based on drag distance
                }
        )
    }
}
