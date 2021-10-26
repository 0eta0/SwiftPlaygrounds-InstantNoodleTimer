
import SwiftUI
import Combine

final public class TimerModel: ObservableObject {
    
    @Published var preset: [Int] = [1, 3, 5]
    public let alertRelay: CurrentValueSubject<(String, Bool), Never> = .init(("", false))
    
    public init() {}
    
    public func addPresetTime(time: Int) {
        preset.append(time)
    }
}
