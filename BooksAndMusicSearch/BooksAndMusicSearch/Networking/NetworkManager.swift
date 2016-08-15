//
//  NetworkManager.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-14.
//  Copyright © 2016 JoLi. All rights reserved.
//

import Foundation

class NetworkManager {
    
    class func fetchSongs(withKeyWord keyWord: String, completion:(AnyObject?, NSError?) -> Void) -> NSURLSessionDataTask {
        let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&attribute=songTerm&limit=10&term=\(keyWord)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
            if let data = data {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                print(json)
                completion(json, nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    
    class func fetchBooks(withKeyWord keyWord: String, completion:(AnyObject?, NSError?) -> Void) -> NSURLSessionDataTask {
        let url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?key=AIzaSyDu60vE57CKAVcZKI0tdrgpQTVOea3PcTo&maxResults=10&q=\(keyWord)+intitle")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
            if let data = data {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                print(json)
                completion(json, nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    
    
    
}
