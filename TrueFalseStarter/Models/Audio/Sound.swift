//
//  Sound.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 11/21/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation
import AVFoundation

protocol Playable{
    var duration: TimeInterval{get}
    func prepare() -> Void
    func play() -> Void
}

class Sound: Playable{
    private let player: AVAudioPlayer
    var duration: TimeInterval{
        get{
            return player.duration
        }
    }

    init(file: URL, type: AVFileType? = nil) throws{
        player = try AVAudioPlayer(contentsOf: file, fileTypeHint: type?.rawValue)
    }

    init(data: Data, type: AVFileType? = nil) throws{
        player = try AVAudioPlayer(data: data, fileTypeHint: type?.rawValue)
    }

    func prepare() -> Void{
        player.prepareToPlay()
    }

    func play() -> Void{
        player.play()
    }
}
