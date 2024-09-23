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
