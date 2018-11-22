//
//  Jukebox.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 11/21/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation
import AVFoundation

private var loadedGameSounds = [GameSound: Sound]()

enum GameSound: String, Hashable, Playable{
    case gameStart = "start"
    case correctAnswer = "correct-answer"
    case incorrectAnswer = "incorrect-answer"

    var duration: TimeInterval{
        get{
            return loaded?.duration ?? Double.signalingNaN
        }
    }

    private var fileType: AVFileType{
        get{
            switch self {
                case .gameStart:
                    return .wav
                case .correctAnswer:
                    return .caf
                case .incorrectAnswer:
                    return .aifc
            }
        }
    }

    private var loaded: Sound?{
        get{
            if let preloaded = loadedGameSounds[self]{
                return preloaded
            }
            else{
                guard let asset = NSDataAsset(name: "Sounds/" + rawValue) else{
                    fatalError("Sound \"\(rawValue)\" not included in bundle")
                }
                if let new = try? Sound(data: asset.data, type: fileType){
                    loadedGameSounds[self] = new
                    return new
                }
                else{
                    return nil
                }
            }
        }
    }

    func prepare() -> Void{
        loaded?.prepare()
    }

    func play() -> Void{
        loaded?.play()
    }
}

import UIKit // I feel bad about doing this here, but it's better than exposing a public API to the internal cache imo, since I don't implement this function anywhere else
extension AppDelegate{
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) -> Void{
        loadedGameSounds.removeAll()
    }
}
