//
//  Jukebox.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 11/21/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation
import AVFoundation

enum GameSound: String, Hashable, Playable{

    // MARK: - Cases

    case gameStart = "start"
    case correctAnswer = "correct-answer"
    case incorrectAnswer = "incorrect-answer"
    case questionExpired = "time-expired"
    case gameEnd = "time-expired " // A little hack to use the same identifier: Add some whitespace at compile-time and trim it at runtime
    case clockTicked = "tick"

    // MARK: - Helper Properties

    private var fileType: AVFileType{
        get{
            switch self {
                case .gameStart, .clockTicked:
                    return .wav
                case .correctAnswer:
                    return .caf
                case .incorrectAnswer, .questionExpired, .gameEnd:
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
                guard let asset = NSDataAsset(name: "Sounds/" + rawValue.trimmingCharacters(in: .whitespacesAndNewlines)) else{
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

    // MARK: - Playable Conformance

    var duration: TimeInterval{
        get{
            return loaded?.duration ?? Double.signalingNaN
        }
    }

    func prepare() -> Void{
        loaded?.prepare()
    }

    func play() -> Void{
        loaded?.play()
    }
}

// MARK: - Cache Management

private var loadedGameSounds = [GameSound: Sound]()

import UIKit // I feel bad about doing this here, but it's better than exposing a public API to the internal cache imo, since I don't implement this function anywhere else
extension AppDelegate{
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) -> Void{
        loadedGameSounds.removeAll()
    }
}
