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
    var onChangeBPM: (Int) -> Void = { _ in }
    
    var songIndex = 0
    
    var bpms = [82, 93, 86, 75]
    var bpmIndex = 0
    var bpm = 82 {
        didSet {
            onChangeBPM(bpm)
        }
    }
    
    // Sons para teste
    var songs: [Song] = [
        Song(id: "1437272596", name: "Buzina", artistName: "Pabllo Vittar", artworkURL: "https://is2-ssl.mzstatic.com/image/thumb/Music128/v4/25/ce/58/25ce58dd-021e-5b7d-32cc-61158f7dc563/886447240083.jpg/{w}x{h}bb.jpeg"),
        Song(id: "1201885833", name: "Location", artistName: "Khalid", artworkURL: "https://is3-ssl.mzstatic.com/image/thumb/Music122/v4/f2/6b/76/f26b763b-2f06-f4d4-c775-bbf3cb459d84/886446361239.jpg/{w}x{h}bb.jpeg"),
        Song(id: "1511746011", name: "Sem Limites", artistName: "WC no Beat, Ludmilla & Vitão", artworkURL: "https://is2-ssl.mzstatic.com/image/thumb/Music114/v4/b1/1f/99/b11f99bd-2e21-5552-fd64-f0a3e0788814/886448459545.jpg/{w}x{h}bb.jpeg"),
        Song(id: "1437272596", name: "Buzina", artistName: "Pabllo Vittar", artworkURL: "https://is2-ssl.mzstatic.com/image/thumb/Music128/v4/25/ce/58/25ce58dd-021e-5b7d-32cc-61158f7dc563/886447240083.jpg/{w}x{h}bb.jpeg"),
        Song(id: "1201885833", name: "Location", artistName: "Khalid", artworkURL: "https://is3-ssl.mzstatic.com/image/thumb/Music122/v4/f2/6b/76/f26b763b-2f06-f4d4-c775-bbf3cb459d84/886446361239.jpg/{w}x{h}bb.jpeg"),
        Song(id: "1437272596", name: "Buzina", artistName: "Pabllo Vittar", artworkURL: "https://is2-ssl.mzstatic.com/image/thumb/Music128/v4/25/ce/58/25ce58dd-021e-5b7d-32cc-61158f7dc563/886447240083.jpg/{w}x{h}bb.jpeg"),
    ]

    private init() {
        currentSong = songs[0]
        nextSong = songs[1]
        
        self.queue.storeIDs = ["1437272596", "1511746011", "1201885833"]
        self.player.setQueue(with: self.queue)
        self.updateBPM()
    }
    
    func updateBPM() {
        bpm = bpms[bpmIndex]
        bpmIndex += 1
    }
    
    private func updateSongs() {
        onChangeSong(currentSong!)
        onChangeNextSong(nextSong!)
        
        if [0, 2, 4].contains(songIndex){
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.updateBPM()
            }
        }
    }
    
    func updateNextSong() {
        if songIndex == 0 || songIndex == 2 {
            songIndex += 1
        }
        nextSong = songs[songIndex + 1]
        onChangeNextSong(nextSong!)
    }

    func getNextSong() -> Song {
        songIndex += 1
        return songs[songIndex + 1]
    }

    func playPause() {
        updateSongs()
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }

    func next() {
        currentSong = nextSong
        nextSong = getNextSong()
        updateSongs()
        player.skipToNextItem()
    }

    func search() {
        
        
//        self.onChangeSong(self.currentSong!)
//
//        print(songs[0])
//        self.queue.storeIDs = [self.currentSong!.id]
//        self.player.setQueue(with: self.queue)
//        self.player.play()
//        SKCloudServiceController.requestAuthorization { status in
//            if status == .authorized {
//                MusicService.shared.searchAppleMusic("location khalid") { songs in
//                    self.currentSong = songs[0]
//                    self.onChangeSong(self.currentSong!)
//
//                    print(songs[0])
//                    self.queue.storeIDs = songs.map(\.id)
//                    self.player.setQueue(with: self.queue)
//                    self.player.play()
////                    print(songs)
//                }
//            }
//        }
    }
}
