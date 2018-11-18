//
//  WelcomeViewController.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 11/16/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var lightningButton: UIButton!

    override func viewDidLoad() -> Void{
        super.viewDidLoad()
        guard let normal = normalButton as? StyledButton, let normalColor = normal.backgroundColor else{
            return
        }

        normal.setBackgroundColor(normalColor, forState: .normal)

        guard let lightning = lightningButton as? StyledButton, let lightningColor = lightning.backgroundColor else{
            return
        }

        lightning.setBackgroundColor(lightningColor, forState: .normal)
    }

    @IBAction func startGameWithModeButton(_ sender: UIButton) -> Void{
        dismiss(animated: true, completion: nil)
    }
}
