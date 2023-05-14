//
//  SoundPlayer.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 03.01.2023.
//

import Foundation
import MediaPlayer

final class SoundPlayer {
    
    static var share: SoundPlayer!
    
    static func appStart() {
        SoundPlayer.share = SoundPlayer()
    }
    
    private var audioPlayers: [Int : AVAudioPlayer] = [:]
    
    private init() {}
    
    func loadLevelSounds() {
        DispatchQueue(label: "Media").async { [weak self] in
            guard let level = AppStorage.currentLevel else { return }
            
            for word in level.words {
                if let url = word.voiceoverUrl,
                   let data = try? Data(contentsOf: url) {
                    self?.audioPlayers[word.id] = try? AVAudioPlayer(data: data)
                }
            }
            
            for bonusWord in level.bonusWords {
                if let url = bonusWord.voiceoverUrl,
                   let data = try? Data(contentsOf: url) {
                    self?.audioPlayers[bonusWord.id] = try? AVAudioPlayer(data: data)
                }
            }
        }
    }
    
    func hasSound(id: Int) -> Bool {
        return audioPlayers[id] != nil
    }
    
    func play(id: Int) {
        audioPlayers[id]?.stop()
        audioPlayers[id]?.currentTime = .zero
        audioPlayers[id]?.play()
    }
    
    func clear() {
        audioPlayers.removeAll()
    }
}
