//
//  AnswerButton.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 10/16/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit

class AnswerButton: StyledButton {
    let answer: Question.Answer
    private var haptic: UINotificationFeedbackGenerator? = nil

    init(answer: Question.Answer){
        self.answer = answer
        super.init(frame: .zero)
        setTitle(answer.value, for: .normal)
        setTitleColor(.white, for: .normal)
        setBackgroundColor(#colorLiteral(red: 1, green: 0.831372549, blue: 0.4745098039, alpha: 1), forState: .normal)

        addTarget(self, action: #selector(prepareHaptic), for: .touchDown)
        addTarget(self, action: #selector(prepareHaptic), for: .touchDragEnter)
        addTarget(self, action: #selector(cancelHaptic), for: .touchCancel)
        addTarget(self, action: #selector(cancelHaptic), for: .touchDragExit)
    }

    func displayForAnswerCorectness(_ correct: Bool) -> Void{
        isEnabled = false

        haptic?.notificationOccurred(correct ? .success : .error)

        func opacityChange() -> Void {
            self.setOpacity(0.2, for: .disabled)
        }

        if UIAccessibility.isReduceMotionEnabled{
            UIView.animate(withDuration: 0.2, animations: opacityChange)
        }
        else{
            let scale: CGFloat = correct ? 1 + (1 - AnswerButton.shrunkenScale) : AnswerButton.shrunkenScale
            UIView.animateSpring {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
                if !correct{
                    opacityChange()
                }
            }
        }
    }

    @objc private func prepareHaptic() -> Void{
        haptic = UINotificationFeedbackGenerator()
        haptic?.prepare()
    }

    @objc private func cancelHaptic() -> Void{
        haptic = nil
    }

    required init?(coder aDecoder: NSCoder){
        if let decodedAnswer = aDecoder.decodeObject(forKey: "answer") as? Question.Answer{
            self.answer = decodedAnswer
        }
        else{
            return nil
        }
        super.init(coder: aDecoder)
    }
}
