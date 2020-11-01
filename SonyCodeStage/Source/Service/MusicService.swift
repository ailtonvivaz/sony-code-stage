//
//  MusicService.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 01/11/20.
//

import Foundation
import StoreKit

class MusicService {
    static let shared = MusicService()
    
    let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjZKNkc1RDg0S0IifQ.eyJpc3MiOiI2QjU2MzU2NEM1IiwiZXhwIjoxNjIwMDIwOTc1LCJpYXQiOjE2MDQyNTI5NzV9.gohJZ9aLzSovmRz_H_229UcK_O1gE-3QdQsRlZl9kiK-0Pl2M3IGM9FMf691-gDyztufdruofTCb4rUJ43bByQ"
    
    let controller = SKCloudServiceController()
    var userToken: String? = nil
    
    private init() {}

    func getUserToken(completion: @escaping (String) -> Void){
        if let token = userToken {
            print(token)
            completion(token)
            return
        }
        
        // 2
        controller.requestUserToken(forDeveloperToken: developerToken) { receivedToken, error in
            // 3
            guard error == nil else { return }
            if let token = receivedToken {
                completion(token)
            }
        }
    }
    
    func fetchStorefrontID(completion: @escaping (String) -> Void) {
        getUserToken { [self] token in
            let musicURL = URL(string: "https://api.music.apple.com/v1/me/storefront")!
            var musicRequest = URLRequest(url: musicURL)
            musicRequest.httpMethod = "GET"
            musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
            musicRequest.addValue(token, forHTTPHeaderField: "Music-User-Token")
            
            URLSession.shared.dataTask(with: musicRequest) { data, _, error in
                guard error == nil else { return }
                
                if let data = data,
                    let dataStr = String(data: data, encoding: .utf8),
                    let json = dataStr.dictionary
                {
                    if let result = json["data"] as? [[String: Any]] {
                        let id = result[0]["id"] as! String
                        print(id)
                        completion(id)
                    }
                }
            }.resume()
        }
    }
    
    func searchAppleMusic(_ searchTerm: String, completion: @escaping ([Song]) -> Void) {
        fetchStorefrontID { [self] storeID in
            getUserToken { token in
                let musicURL = URL(string: "https://api.music.apple.com/v1/catalog/\(storeID)/search?term=\(searchTerm.replacingOccurrences(of: " ", with: "+"))&types=songs&limit=25")!
                var musicRequest = URLRequest(url: musicURL)
                musicRequest.httpMethod = "GET"
                musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
                musicRequest.addValue(token, forHTTPHeaderField: "Music-User-Token")
                
                URLSession.shared.dataTask(with: musicRequest) { data, _, error in
                    guard error == nil else { return }
                    if let data = data,
                        let dataStr = String(data: data, encoding: .utf8),
                        let json = dataStr.dictionary
                    {
                        var songs = [Song]()
                        let results = json["results"] as! [String: Any]
                        let songsResult = results["songs"] as! [String: Any]
                        let result = songsResult["data"] as! [[String: Any]]
                        for song in result {
                            let attributes = song["attributes"] as! [String: Any]
                            let playParams = attributes["playParams"] as! [String: Any]
                            let artwork = attributes["artwork"] as! [String: Any]
                            let currentSong = Song(id: playParams["id"] as! String, name: attributes["name"] as! String, artistName: attributes["artistName"] as! String, artworkURL: artwork["url"] as! String)
                            songs.append(currentSong)
                        }
                        completion(songs)
                    } else {
                        completion([])
                    }
                }.resume()
            }
        }
    }
}
