//
//  MusicPlayer.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 01/11/20.
//

import Foundation
import MediaPlayer

class MusicPlayer {
    static let shared = MusicPlayer()

    var mood: Mood?
    var task: Task?

    private let autoSongs: [SongIA] = []

    private let player = MPMusicPlayerController.applicationMusicPlayer
    private lazy var queue = MPMusicPlayerStoreQueueDescriptor(storeIDs: [])
    
    var currentSong: Song? = nil
    var nextSong: Song? = nil
    
    var onChangeSong: (Song) -> Void = { _ in }
    var onChangeNextSong: (Song) -> Void = { _ in }

    private init() {}

    func getNextSong() -> Song {
        return Song(id: "", name: "", artistName: "", artworkURL: "")
    }
    
    func playPause() {
        if player.playbackState == .playing {
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
}
