//
//  MusicPlayer.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 01/11/20.
//

import Foundation
import MediaPlayer
import StoreKit

class MusicPlayer {
    static let shared = MusicPlayer()

    var mood: Mood?
    var task: Task?

    private let autoSongs: [SongIA] = []

    private let player = MPMusicPlayerController.applicationMusicPlayer
    private lazy var queue = MPMusicPlayerStoreQueueDescriptor(storeIDs: [])

    var currentSong: Song?
    var nextSong: Song?
    
    var isPlaying: Bool { player.playbackState == .playing }

    var onChangeSong: (Song) -> Void = { _ in }
    var onChangeNextSong: (Song) -> Void = { _ in }

    private init() {}

    func getNextSong() -> Song {
        return Song(id: "", name: "", artistName: "", artworkURL: "")
    }

    func playPause() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }

    func next() {
        currentSong = nextSong
        nextSong = getNextSong()

        onChangeSong(currentSong!)
        onChangeNextSong(nextSong!)
    }

    func search() {
        SKCloudServiceController.requestAuthorization { status in
            if status == .authorized {
                MusicService.shared.searchAppleMusic("pessimo negocio") { songs in
                    self.currentSong = songs[0]
                    self.onChangeSong(self.currentSong!)
                    
                    print(songs[0])
                    self.queue.storeIDs = songs.map(\.id)
                    self.player.setQueue(with: self.queue)
                    self.player.play()
//                    print(songs)
                }
            }
        }
    }
}
