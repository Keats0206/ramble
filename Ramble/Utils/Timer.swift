//
//  Timer.swift
//  Ramble
//
//  Created by Peter Keating on 10/26/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

enum TimerMode {
    case running
    case stopped
    case paused
}

class TimerManager: ObservableObject {
    @Published var mode: TimerMode = .stopped
    @Published var secondsElapsed = 0.0
    
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            swiftlint:disable shorthand_operator
            self.secondsElapsed = self.secondsElapsed + 0.1
//            swiftlint:enable shorthand_operator
        }
    }
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        mode = .stopped
    }
}
