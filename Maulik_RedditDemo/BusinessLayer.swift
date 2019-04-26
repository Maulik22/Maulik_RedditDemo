//
//  BusinessLayer.swift
//  Maulik_RedditDemo
//
//  Created by Maulik Bhuptani on 26/04/19.
//  Copyright © 2019 Maulik Bhuptani. All rights reserved.
//

import UIKit

class BusinessLayer: NSObject {
    
    static let shared = BusinessLayer()
    
    private let config = URLSessionConfiguration.default
    private var session : URLSession {
        return URLSession(configuration: config)
    }
    
    public func getRandomPosts(completion: @escaping (_ postsArray : Array<Dictionary<String,Any>>?) -> Void) {
        
        let todoEndpoint: String = "https://ww.reddit.com/r/random.json?limit=5"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("Error: GET API call failed")
                completion(nil)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                completion(nil)
                return
            }
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        completion(nil)
                        return
                }
                
                guard let jsonDict = jsonObject["data"] as? Dictionary<String,Any>, let jsonArray = jsonDict["children"] as? Array<Dictionary<String,Any>> else{
                    completion(nil)
                    return
                }
                
                let filteredJSONArray = jsonArray.map { ($0["data"]) }
                completion(filteredJSONArray as? Array<Dictionary<String, Any>>)
                
            } catch  {
                print("error trying to convert data to JSON")
                completion(nil)
                return
            }
        }
        task.resume()
    }
    
    public func downloadImage(link : String, completion: @escaping (_ image : UIImage?) -> Void){
        guard let url = URL(string: link) else { return }
        session.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    completion(nil)
                    return
            }
            completion(image)
            }.resume()
    }
}


