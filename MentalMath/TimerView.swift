import SwiftUI
import Combine

struct CountdownTimerView: View {
    
    @State private var remainingTime: Int = 60
    @State private var timerActive = false
    private var timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        Text("\(timeString(from: remainingTime))")
            .font(.system(size: 60, weight: .bold, design: .monospaced))
            .padding()
            .onReceive(timer) { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                }
            }
            .padding()
            .foregroundColor(.white)
    }

    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    CountdownTimerView()
}
