//
//  Song.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 01/11/20.
//
import Foundation

struct Song: Decodable {
    var id: String
    var name: String
    var artistName: String
    var artworkURL: String
    
    var coverURL: String {
        artworkURL.replacingOccurrences(of: "{w}", with: "300").replacingOccurrences(of: "{h}", with: "300")
    }
}
