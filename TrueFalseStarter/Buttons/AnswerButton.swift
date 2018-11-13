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

    init(answer: Question.Answer){
        self.answer = answer
        super.init(frame: .zero)
        setTitle(answer.value, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .highlighted)
        setBackgroundColor(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), forState: .normal)
        setBackgroundColor(#colorLiteral(red: 0.6363664622, green: 0.5305625917, blue: 0.3027452583, alpha: 1), forState: .highlighted)
    }

    func displayForAnswerCorectness(_ correct: Bool) -> Void{
        isEnabled = false
        let scale: CGFloat = correct ? 1 + (1 - AnswerButton.shrunkenScale) : AnswerButton.shrunkenScale
        let changes = {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            if !correct{
                self.setOpacity(0.2, for: .disabled)
            }
        }
        if UIAccessibility.isReduceMotionEnabled{
            changes()
        }
        else{
            UIView.animate(withDuration: AnswerButton.springDuration, delay: 0, usingSpringWithDamping: AnswerButton.springDamping, initialSpringVelocity: 0, options: [.allowAnimatedContent, .beginFromCurrentState], animations: changes, completion: nil)
        }
        if !correct{

        }
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
