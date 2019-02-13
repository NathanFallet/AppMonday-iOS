//
//  TipsManager.swift
//  AppMonday
//
//  Created by Nathan FALLET on 13/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class TipsManager {
    
    // Get list of tips
    func getList(start: Int, limit: Int, callback: @escaping ([Tip]) -> ()) {
        var request = URLRequest(url: URL(string: "https://api.appmonday.xyz/tip/tip.php?start=\(start)&limit=\(limit)")!)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let tips = try JSONDecoder().decode([Tip].self, from: data)
                
                for tip in tips {
                    tip.process()
                }
                
                DispatchQueue.main.async {
                    callback(tips)
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
}
