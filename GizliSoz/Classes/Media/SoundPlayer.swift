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
        if AppStorage.isServerAvailable {
            DispatchQueue(label: "Media").async { [weak self] in
                guard let level = AppStorage.currentLevel else { return }
                
                for word in level.words {
                    if let file = word.voiceoverFile,
                       let url = AppStorage.voiceoverHost?.appendingPathComponent(file),
                       let data = try? Data(contentsOf: url) {
                        self?.audioPlayers[word.id] = try? AVAudioPlayer(data: data)
                    }
                }
                
                for bonusWord in level.bonusWords {
                    if let file = bonusWord.voiceoverFile,
                       let url = AppStorage.voiceoverHost?.appendingPathComponent(file),
                       let data = try? Data(contentsOf: url) {
                        self?.audioPlayers[bonusWord.id] = try? AVAudioPlayer(data: data)
                    }
                }
            }
        } else {
            guard let level = AppStorage.currentLevel else { return }
            
            for word in level.words {
                guard let url = Bundle.main.url(forResource: word.voiceoverFile, withExtension: nil) else { return }
                audioPlayers[word.id] = try? AVAudioPlayer(contentsOf: url)
            }
            
            for bonusWord in level.bonusWords {
                guard let url = Bundle.main.url(forResource: bonusWord.voiceoverFile, withExtension: nil) else { return }
                audioPlayers[bonusWord.id] = try? AVAudioPlayer(contentsOf: url)
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
