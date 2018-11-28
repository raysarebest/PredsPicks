//
//  WelcomeViewController.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 11/16/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController{

    // MARK: - Outlets

    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var lightningButton: UIButton!

    // MARK: - UI Management

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }

    // MARK: - Actions

    @IBAction func startGameWithModeButton(_ sender: LightningModeSelectionButton) -> Void{
        guard let presenter = presentingViewController as? ViewController else{ // If we're not presented by a quiz view controller, there's no need to do anything else
            return
        }
        GameSound.gameStart.prepare()
        presenter.newGame(lightning: sender.lightningMode)
        dismiss(animated: true, completion: nil)
    }
}
