//
//  CountdownView.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 11/18/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit

class CountdownView: UIView, CAAnimationDelegate{
    @IBOutlet private weak var secondsLabel: UILabel!
    @IBInspectable var ringColor: UIColor = .red{
        didSet{
            ringLayer.strokeColor = ringColor.cgColor
        }
    }
    @IBInspectable var initialCount: Int = 15{
        didSet{
            layoutCircle()
        }
    }
    private(set) var currentCount: Int{
        didSet{
            layoutCircle()
        }
    }
    @objc private let ringLayer = CAShapeLayer()

    override init(frame: CGRect){
        currentCount = initialCount
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder){
        currentCount = 0
        super.init(coder: aDecoder)
        currentCount = initialCount // We have to set this before and after super or the compiler will complain
    }

    private func layoutCircle() -> Void{
        ringLayer.strokeEnd = CGFloat(currentCount) / CGFloat(initialCount)
    }

    override func layoutSubviews() -> Void{
        ringLayer.frame = bounds
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = tintColor.cgColor
        secondsLabel.textColor = tintColor
        ringLayer.lineWidth = 3
        ringLayer.lineCap = .round
        layer.cornerRadius = radius

        // This draws a counter-clockwise circular arc that fits within the view, but only as far as the fraction (currentCount / initialCount). The arc's coordinates along the circle are rotated 90º to the right, for some reason
        let startAngle = CGFloat(270).radians
        ringLayer.path = UIBezierPath(arcCenter: ringLayer.bounds.center, radius: radius - (ringLayer.lineWidth / 2), startAngle: startAngle, endAngle: startAngle - 2 * .pi, clockwise: false).cgPath
        ringLayer.strokeStart = 0

        // The empty if looks sorta weird but it's the only DRY way I can think of to say "if layer.sublayers is nil or doesn't contain this layer"
        if let subs = layer.sublayers, subs.contains(ringLayer){}else{
            layer.addSublayer(ringLayer)
        }
        super.layoutSubviews()
    }

    override func tintColorDidChange() -> Void{
        super.tintColorDidChange()
        ringColor = tintColor
        secondsLabel.textColor = tintColor
    }

    private var radius: CGFloat{
        get{
            return CGFloat.minimum(frame.width, frame.height) / 2
        }
    }

    func tick() -> Void{
        currentCount -= 1
        secondsLabel.text = String(currentCount)
        layoutCircle()
    }

    func resetCount() -> Void{
        secondsLabel.text = String(initialCount)
        currentCount = initialCount
    }
}

extension FloatingPoint{
    var degrees: Self{
        get{
            return self * 180 / .pi
        }
    }
    var radians: Self{
        get{
            return self * .pi / 180
        }
    }
}

extension CGRect{
    var center: CGPoint{
        get{
            return CGPoint(x: midX, y: midY)
        }
    }
}
