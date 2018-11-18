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
    private static let highlightedColorFactor: CGFloat = 0.6

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

            let scale: CGFloat = isHighlighted ? StyledButton.shrunkenScale : 1
            UIView.animateSpring {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }

    func setBackgroundColor(_ color: UIColor, forState state: UIControl.State) -> Void{
        backgroundColors[state] = color

        defer{
            updateAppearance()
        }

        // If we're setting a color for the normal state, we want the highlighted state to be 40% or so darker
        
        guard state == .normal, let normal = backgroundColor(for: .normal) else{
            return
        }

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        guard normal.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else{
            return
        }

        setBackgroundColor(UIColor(hue: hue, saturation: saturation, brightness: brightness * StyledButton.highlightedColorFactor, alpha: alpha), forState: .highlighted)
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

        // If we're setting a color for the normal state, we want the highlighted state to be 40% or so darker

        guard state == .normal, let new = color else{
            return
        }

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        guard new.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else{
            return
        }

        super.setTitleColor(UIColor(hue: hue, saturation: saturation, brightness: brightness * StyledButton.highlightedColorFactor, alpha: alpha), for: .highlighted)
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

extension UIView{
    class func animateSpring(duration: TimeInterval = 0.2, damping: CGFloat = 0.5, initialVelocity: CGFloat = 0, changes: @escaping () -> Void) -> Void{
        if !UIAccessibility.isReduceMotionEnabled{
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: [.allowAnimatedContent, .beginFromCurrentState], animations: changes, completion: nil)
        }
    }
}

extension UIControl.State: Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
