

import SwiftUI
import Combine

public struct ContentView: View {
    
    @ObservedObject var model: TimerModel
    
    @State private var seconds: Int = 0
    @State private var isPlay: Bool = false
    @State private var timer: Timer? = nil
    @State private var selectedTime: Int = 0
    
    public init(model: TimerModel) {
        self.model = model
    }
    
    public var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 24) {
                ForEach(model.preset, id: \.self) { time in 
                    Button(action: {
                        setTime(time: time)
                    }) {
                        Text("\(time) m")
                            .foregroundColor(selectedTime == time ? Color.black : Color.white)
                            .font(.largeTitle)
                    }
                    .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .background(selectedTime == time ? Color.yellow : Color.gray)
                    .cornerRadius(8.0)
                }
                Button(action: {
                    model.alertRelay.send(("Input new time", true))
                }) {
                    Text("+")
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                }
                .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                .background(Color.gray)
                .cornerRadius(8.0)
            }
            Spacer()
            Text("\(seconds) s")
                .foregroundColor(Color.white)
                .font(.system(size: 64, weight: .bold))
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                isPlay ? stopTimer() : startTimer()
            }) {
                let title = isPlay ? "Stop" : "Start"
                Text(title)
                    .foregroundColor(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.init(top: 8, leading: 32, bottom: 8, trailing: 32))
            .background(isPlay ? Color.yellow : Color.white)
            .cornerRadius(8.0)
            Spacer()
        }
    }
    
    private func setTime(time: Int) {
        stopTimer()
        seconds = time * 60
        selectedTime = time
    }
    
    private func startTimer() {
        guard seconds > 0 else {
            model.alertRelay.send(("Need to set time", false))
            return
        }
        isPlay = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            guard seconds > 0 else {
                model.alertRelay.send(("Done", false))
                setTime(time: selectedTime)
                stopTimer()
                return
            }
            seconds -= 1
        })
    }
    
    private func stopTimer() {
        timer?.invalidate()
        isPlay = false
    }
}
