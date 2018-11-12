//
//  AnswerButton.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 10/16/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit

class AnswerButton: UIButton {
    let answer: Question.Answer

    init(answer: Question.Answer){
        self.answer = answer
        super.init(frame: .zero)
        setTitle(answer.value, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .highlighted)
        showsTouchWhenHighlighted = true
        backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
    }

    override var intrinsicContentSize: CGSize{
        get{
            return CGSize(width: super.intrinsicContentSize.width, height: CGFloat.maximum(50, super.intrinsicContentSize.height))
        }
    }

    override var isHighlighted: Bool{
        didSet{
            UIView.animate(withDuration: isHighlighted ? 0.1 : 0.5) {
                self.backgroundColor = self.isHighlighted ? #colorLiteral(red: 0.6363664622, green: 0.5305625917, blue: 0.3027452583, alpha: 1) : #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
            }
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
