//
//  QuizTimer.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 11/14/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation

class QuizTimer{ // I wanna subclass `Timer` here instead of maintain my own internal timer, but the documentation says I shouldn't :(
    private(set) var remainingSeconds: TimeInterval = 15
    private(set) var running = true
    private var shouldStop = false

    init(countdownHandler: @escaping (TimeInterval) -> Void){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) in
            guard self.remainingSeconds >= 0 && !self.shouldStop else{
                timer.invalidate()
                return
            }
            self.remainingSeconds -= 1
            countdownHandler(self.remainingSeconds)
        })
    }

    func stop() -> Void{
        shouldStop = true
        running = false
    }
}
