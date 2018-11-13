//
//  StyledButton.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 11/12/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit

class StyledButton: UIButton {

    private var backgroundColors = [UIControl.State: UIColor]()
    private var opacities = [UIControl.State: CGFloat]()

    static let shrunkenScale: CGFloat = 0.9
    static let springDamping: CGFloat = 0.8
    static let springDuration: TimeInterval = 0.2

    override func layoutSubviews() -> Void{
        layer.cornerRadius = 5
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        showsTouchWhenHighlighted = true
        super.layoutSubviews()
    }

    override var intrinsicContentSize: CGSize{
        get{
            return CGSize(width: super.intrinsicContentSize.width, height: CGFloat.maximum(50, super.intrinsicContentSize.height))
        }
    }

    var currentState: UIControl.State{
        get{
            if isHighlighted{
                return .highlighted
            }
            else if !isEnabled{
                return .disabled
            }
            else if isSelected{
                return .selected
            }
            else if isFocused{
                return .focused
            }
            else{
                return .normal
            }
        }
    }

    private static let possibleStates: [UIControl.State] = [.normal, .highlighted, .disabled, .selected, .focused]

    override var isHighlighted: Bool{
        didSet{
            updateAppearance()

            if !UIAccessibility.isReduceMotionEnabled{
                let transform: CGFloat = isHighlighted ? StyledButton.shrunkenScale : 1

                UIView.animate(withDuration: StyledButton.springDuration, delay: 0, usingSpringWithDamping: StyledButton.springDamping, initialSpringVelocity: 0, options:
                    [.allowAnimatedContent, .beginFromCurrentState], animations: {
                    self.transform = CGAffineTransform(scaleX: transform, y: transform)
                }, completion: nil)
            }
        }
    }

    func setBackgroundColor(_ color: UIColor, forState state: UIControl.State) -> Void{
        backgroundColors[state] = color
        updateAppearance()
    }

    func backgroundColor(for state: UIControl.State) -> UIColor?{
        return backgroundColors[state]
    }

    func setOpacity(_ alpha: CGFloat, for state: UIControl.State) -> Void{
        opacities[state] = alpha
        setTitleColor(titleColor(for: state), for: state)
        updateAppearance()
    }

    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) -> Void{
        guard let opacity = opacities[state] else{
            super.setTitleColor(color, for: state)
            return
        }

        super.setTitleColor(color?.withAlphaComponent(opacity), for: state)
    }

    private func updateAppearance(shouldAnimate: Bool = true) -> Void{
        let possilbeColor = backgroundColors[currentState] ?? backgroundColors[.normal]
        let possibleOpacity = opacities[currentState] ?? opacities[.normal]

        let changes = {
            if let background = possilbeColor{
                if let opacity = possibleOpacity{
                    self.backgroundColor = background.withAlphaComponent(opacity)
                }
                else{
                    self.backgroundColor = background
                }
            }
        }

        if shouldAnimate{
            UIView.animate(withDuration: currentState == .normal ? 0.5 : 0.1, animations: changes)
        }
        else{
            changes()
        }
    }

}

extension UIControl.State: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
