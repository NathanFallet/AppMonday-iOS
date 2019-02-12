//
//  ProjectsManager.swift
//  AppMonday
//
//  Created by Nathan FALLET on 12/02/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

class ProjectsManager {
    
    // Get list of projects
    func getList(start: Int, limit: Int, callback: @escaping ([Project]) -> ()) {
        var request = URLRequest(url: URL(string: "https://api.appmonday.xyz/project/project.php?start=\(start)&limit=\(limit)")!)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let projects = try JSONDecoder().decode([Project].self, from: data)
                
                for project in projects {
                    project.process()
                }
                
                DispatchQueue.main.async {
                    callback(projects)
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    // Submit a project
    func submit(access_token: String, name: String, description: String, user: String, link: String, logo: String, callback: @escaping () -> ()) {
        var request = URLRequest(url: URL(string: "https://api.appmonday.xyz/project/projectt.php")!)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["name": name, "description": description, "user": user, "link": link, "logo": logo], options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            DispatchQueue.main.async {
                callback()
            }
        }.resume()
    }

}
