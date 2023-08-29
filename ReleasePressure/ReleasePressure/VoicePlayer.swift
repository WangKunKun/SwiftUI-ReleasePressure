//
//  VoicePlayer.swift
//  ReleasePressure
//
//  Created by 王琨 on 2023/7/22.
//

import Foundation
import AVFoundation
class VoicePlayer {
    
    init(with path:String) {
        self.fileName = path
    }
    var fileName:String
    var player:AVAudioPlayer?
    func playaudio() {
        if player != nil {
            player?.play()
            return
        }
        if let path = Bundle.main.path(forResource: fileName, ofType: nil){
            do{
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.prepareToPlay()
                player?.play()

            }catch {
            }
        }
    }
}
