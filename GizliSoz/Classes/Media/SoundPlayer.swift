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
    
    func loadLevelSounds(ids: [Int]) {
        for id in ids {
            if audioPlayers.contains(where: {$0.key == id}) { continue }
            fetchSoundUrl(id: id) { [weak self] url in
                guard let data = try? Data(contentsOf: url) else { return }
                self?.audioPlayers[id] = try? AVAudioPlayer(data: data)
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

// MARK: - Private functions
extension SoundPlayer {
    private func fetchSoundUrl(id: Int, completion: @escaping (_ url: URL) -> Void) {
        API.Levels.getWordSound(
            .init(
                wordId: id,
                voiceActor: AppStorage.voiceActor
            )
        ).request(LevelSoundResponse.self) { result in
            switch result {
            case .success(let data):
                if let content = data.content {
                    completion(content.url)
                } else {
                    AppLogger.error(.fetch, AppError.contentError)
                }
            case .failure(let error):
                AppLogger.error(.fetch, error.localizedDescription)
            }
        }
    }
}
