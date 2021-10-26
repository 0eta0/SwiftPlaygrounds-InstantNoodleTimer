import PlaygroundSupport
import SwiftUI
import UIKit
import Combine

let model = TimerModel()
let contentView = ContentView(model: model)
let vc = UIHostingController(rootView: contentView)
PlaygroundPage.current.liveView = vc

let cancellable = model.alertRelay.sink{ [unowned vc] (title, isInputEnable) in
    guard !title.isEmpty else { return }
    
    let alertVC = UIAlertController(title: title, message: "", preferredStyle: .alert)
    if isInputEnable {
        alertVC.addTextField()
    }
    alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        guard isInputEnable else { return }
        
        guard let value = Int(alertVC.textFields?[0].text ?? "") else { 
            model.alertRelay.send(("Invalid time input", false))
            return
        }
        
        model.addPresetTime(time: value)
    })
    vc.present(alertVC, animated: true)
}
