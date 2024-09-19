//
//  CountdownTimerView.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import SwiftUI

struct CountdownTimerView: View {

    @Binding var remainingTime: Int

    var body: some View {
        Text("\(remainingTime.timeStringFromSeconds)")
            .font(.primary)
            .padding()
            .padding()
            .foregroundColor(.white)
    }
}
