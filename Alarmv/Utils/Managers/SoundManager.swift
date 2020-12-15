//
//  SoundManager.swift
//  Alarmv
//
//  Created by vlsuv on 14.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    var player: AVAudioPlayer?
    var sound: Sound?
    
    func curentlyPlaying() -> Sound? {
        return sound
    }
    
    func play(this sound: Sound) {
        guard let path = Bundle.main.path(forAuxiliaryExecutable: sound.fileName) else {return}
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            self.sound = sound
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func stop() {
        player?.stop()
        player = nil
        sound = nil
    }
}
