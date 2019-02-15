//
//  CompetitionsManager.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class CompetitionsManager {
    
    // Get list of competitions
    func getList(start: Int, limit: Int, callback: @escaping ([Competition], [Competition], [Competition]) -> ()) {
        var request = URLRequest(url: URL(string: "https://api.appmonday.xyz/competition/competition.php?start=\(start)&limit=\(limit)")!)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.setValue("AppMonday_iOS", forHTTPHeaderField: "client")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let competitions = try JSONDecoder().decode([Competition].self, from: data)
                var playing = [Competition]()
                var coming = [Competition]()
                var ended = [Competition]()
                
                for competition in competitions {
                    competition.process()
                    if competition.coming! {
                        coming.append(competition)
                    } else if competition.playing! {
                        playing.append(competition)
                    } else {
                        ended.append(competition)
                    }
                }
                
                DispatchQueue.main.async {
                    callback(playing, coming, ended)
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
}
