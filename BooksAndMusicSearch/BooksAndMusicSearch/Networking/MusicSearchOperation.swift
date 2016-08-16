//
//  MusicSearchOperation.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-16.
//  Copyright © 2016 JoLi. All rights reserved.
//

import Foundation


class MusicSearchOperation: NetworkOperation, SearchNetworkOperation {
    private var task: NSURLSessionDataTask?
    var keyWord: String
    var completion: (([Song], NSError?) -> Void) = { _ in }
    var url: NSURL {
        return NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&attribute=songTerm&limit=10&term=\(keyWord)")!
    }

    var request: NSURLRequest {
        return NSURLRequest(URL: url)
    }
    
    init(with keyWord: String) {
        self.keyWord = keyWord
        super.init()
    }
    
    override func start() {
        super.start()
         task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print("Music search error: \(error.localizedDescription)")
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
        task!.resume()
    }
    
    override func cancel() {
        if let task = task { task.cancel() }
        super.cancel()
    }
}

extension MusicSearchOperation {
    func musicFromJSON(data: NSData) -> [Song] {
        var songs: [Song] = []
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject],
                let results = json["results"] as? [[String: AnyObject]] {
                for result in results {
                    if let trackName = result["trackName"] as? String, let artist = result["artistName"] as? String {
                        songs.append(Song(trackName: trackName, artist: artist))
                    }
                }
            }
        } catch {
            print(error)
        }
        return songs;
    }
}

