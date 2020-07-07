//
//  Timer.swift
//  Ramble
//
//  Created by Peter Keating on 7/6/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

class TimerManager: ObservableObject {
    
    @Published var secondsElapsed = 0.0
    @Published var mode: timerMode = .stopped
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
               self.secondsElapsed += 0.1
           }
       }
    
    func stop() {
        timer.invalidate()
        mode = .paused
    }
    
    func reset(){
        secondsElapsed = 0
        mode = .stopped
    }
}

enum timerMode {
    case running
    case stopped
    case paused
}
