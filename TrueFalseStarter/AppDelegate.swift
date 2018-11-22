//
//  AppDelegate.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool{

        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true, options: [])

        // This whole song-and dance is so I can present the welcome view modally on launch without animation. I'm getting a copy of my launch screen, showing it, loading the welcome screen, and then fading out the launch screen

        guard let welcome = window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "welcome"), let launch = UIStoryboard(name: "LaunchScreen", bundle: .main).instantiateInitialViewController() else{
            return true
        }

        launch.view.frame = welcome.view.bounds
        launch.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window?.makeKeyAndVisible()
        window?.addSubview(launch.view)

        // At this point, the main queue doesn't exist yet, so we have to make a global queue create it

        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.window?.rootViewController?.present(welcome, animated: false, completion: {
                    UIView.animate(withDuration: 0.5, animations: {
                        launch.view.alpha = 0
                    }, completion: { (finished: Bool) in
                        launch.view.removeFromSuperview()
                    })
                })
            }
        }
        return true
    }
}
