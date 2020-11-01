//
//  MusicPlayer.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 01/11/20.
//

import Foundation

struct SongIA {
    var bpm: Int
    var songId: String
}

class MusicPlayer {
    static let shared = MusicPlayer()

    var mood: Mood?
    var task: Task?
    
    private init() {}
    
    
}
