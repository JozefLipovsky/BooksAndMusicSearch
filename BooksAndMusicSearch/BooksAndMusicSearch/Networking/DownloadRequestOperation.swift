//
//  DownloadRequestOperation.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-15.
//  Copyright © 2016 JoLi. All rights reserved.
//

import UIKit

class DownloadRequestOperation: NetworkOperation {
    private let request: NSURLRequest
    var completion: (([Song], NSError?) -> Void) = { _ in }
    
    init(withRequest request: NSURLRequest) {
        self.request = request
        super.init()
    }
    
    override func start() {
        super.start()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                self.completion([], error)
                self.finish()
            }
            
            if let data = data {
                let songs = self.musicFromJSON(data)
                self.completion(songs, error)
                self.finish()
                
            } else {
                self.completion([], error)
                self.finish()
            }

            
        }
        task.resume()
    }
    
    


    func musicFromJSON(data: NSData) -> [Song] {
        var songs: [Song] = []
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject],
                let results = json["results"] as? [[String: AnyObject]] {
                for result in results {
                    if let trackName = result["trackName"] as? String, let artist = result["artistName"] as? String {
                        let song = Song.init(trackName: trackName, artist: artist)
                        songs.append(song)
                    }
                }
            }
        } catch {
            print(error)
        }
        
        return songs;
    }

}
