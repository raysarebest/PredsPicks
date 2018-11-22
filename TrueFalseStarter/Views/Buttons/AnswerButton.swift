//
//  AnswerButton.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 10/16/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit

class AnswerButton: StyledButton {

    // MARK: - Properties

    let answer: Question.Answer
    // Making the haptic feedback generator optional guarantees that only the button the user tapped on plays a haptic
    private var haptic: UINotificationFeedbackGenerator? = nil

    // MARK: - Initializers

    init(answer: Question.Answer){
        self.answer = answer
        super.init(frame: .zero)
        setTitle(answer.value, for: .normal)
        setTitleColor(#colorLiteral(red: 0.01568627451, green: 0.1176470588, blue: 0.2588235294, alpha: 1), for: .normal)
        setBackgroundColor(#colorLiteral(red: 1, green: 0.7215686275, blue: 0.1098039216, alpha: 1), forState: .normal)

        addTarget(self, action: #selector(prepareFeedback), for: .touchDown)
        addTarget(self, action: #selector(prepareFeedback), for: .touchDragEnter)
        addTarget(self, action: #selector(cancelHaptic), for: .touchCancel)
        addTarget(self, action: #selector(cancelHaptic), for: .touchDragExit)
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

    // MARK: - UI Helpers

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

    // MARK: - Private Helpers

    @objc private func prepareFeedback() -> Void{
        shouldRenderHighlightedScale = false
        haptic = UINotificationFeedbackGenerator()
        haptic?.prepare()
    }

    @objc private func cancelHaptic() -> Void{
        haptic = nil
    }
}
