//
//  Utils.swift
//  AppMonday
//
//  Created by Nathan FALLET on 18/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static var updating = false
    static var handlers = [() -> Void]()
    static var cache = NSCache<NSString, NSObject>()
    
    static func query(post: [String: Any], completionHandler: @escaping (Data) -> Void) {
        handlers += [{
            print(post)
            let url = URL(string: "https://api.appmonday.xyz/index.php")
            var request = URLRequest(url:url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                return
            }
            
            var done = false
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                
                if error != nil {
                    print(String(describing: error))
                    return;
                }
                
                completionHandler(data!)
                done = true
            }
            task.resume()
            while !done {
                RunLoop.current.run(mode: RunLoop.Mode.default, before: Date(timeIntervalSinceNow: 1))
            }
        }]
        if !updating {
            DispatchQueue.global(qos: .background).async {
                updating = true
                while handlers.count > 0 {
                    handlers.removeFirst()()
                }
                updating = false
            }
        }
    }
    
    static func addInMain(completionHandler: @escaping () -> Void) {
        handlers += [{
            var done = false
            DispatchQueue.main.async {
                completionHandler()
                done = true
            }
            while !done {
                RunLoop.current.run(mode: RunLoop.Mode.default, before: Date(timeIntervalSinceNow: 1))
            }
        }]
    }
    
}
