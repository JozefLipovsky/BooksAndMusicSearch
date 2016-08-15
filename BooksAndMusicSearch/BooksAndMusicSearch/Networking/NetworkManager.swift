//
//  NetworkManager.swift
//  BooksAndMusicSearch
//
//  Created by JoLi on 2016-08-14.
//  Copyright © 2016 JoLi. All rights reserved.
//

import Foundation


class NetworkManager {

    class func fetchSongs(withKeyWord keyWord: String, completion:([Music], NSError?) -> Void) -> NSURLSessionDataTask {
        let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&attribute=songTerm&limit=10&term=\(keyWord)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion([], error)
            }
            
            if let data = data {
                let songs = musicFromJSON(data)
                completion(songs, error)
            } else {
                completion([], error)
            }
            
        }
        
        task.resume()
        
        return task
    }
    
    
    class func fetchBooks(withKeyWord keyWord: String, completion:([Book], NSError?) -> Void) -> NSURLSessionDataTask {
        let url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?key=AIzaSyDu60vE57CKAVcZKI0tdrgpQTVOea3PcTo&maxResults=10&q=\(keyWord)+intitle")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion([], error)
            }
            
            if let data = data {
                let books = booksFromJSON(data)
                completion(books, error)
            } else {
                completion([], error)
            }
        }
        
        task.resume()
        
        return task
    }

    
    class func booksFromJSON(data: NSData) -> [Book] {
        var books: [Book] = []
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject],
                let items = json["items"] as? [[String: AnyObject]] {
                for item in items {
                    if let volumeInfo = item["volumeInfo"] as? [String: AnyObject],
                        let title = volumeInfo["title"] as? String,
                        let authors = volumeInfo["authors"] as? [String] {
                        let book = Book.init(title: title, authors: authors)
                        books.append(book)
                    }
                }
            }
        } catch {
            print(error)
        }
        
        return books;
    }
    
    
    class func musicFromJSON(data: NSData) -> [Music] {
        var songs: [Music] = []
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject],
                let results = json["results"] as? [[String: AnyObject]] {
                for result in results {
                    if let track = result["trackName"] as? String, let artist = result["artistName"] as? String {
                        let song = Music.init(track: track, artist: artist)
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
