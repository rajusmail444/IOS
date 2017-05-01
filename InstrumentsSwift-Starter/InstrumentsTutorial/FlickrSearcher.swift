//
//  FlickrSearcher.swift
//  flickrSearch
//
//  Created by Richard Turton on 31/07/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation
import UIKit

let apiKey = "bc35d0f087045737a6f48398f2a08854"

struct FlickrSearchResults {
  let searchTerm : String
  let searchResults : [FlickrPhoto]
}

class FlickrPhoto : Equatable {
  let photoID : String
  let title: String
  fileprivate let farm : Int
  fileprivate let server : String
  fileprivate let secret : String
  
  typealias ImageLoadCompletion = (_ image: UIImage?, _ error: NSError?) -> Void
  
  init (photoID:String, title:String, farm:Int, server:String, secret:String) {
    self.photoID = photoID
    self.title = title
    self.farm = farm
    self.server = server
    self.secret = secret
  }
  
  func flickrImageURL(_ size:String = "m") -> URL {
    return URL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")!
  }
  
  func loadThumbnail(_ completion: @escaping ImageLoadCompletion) {
    loadImageFromURL(URL: flickrImageURL("m") as URL) { image, error in
      completion(image, error)
    }
  }

  func loadLargeImage(_ completion: @escaping ImageLoadCompletion) {
    loadImageFromURL(URL: flickrImageURL("b") as URL, completion)
  }
  
  func loadImageFromURL(URL: URL, _ completion: @escaping ImageLoadCompletion) {
    let loadRequest = URLRequest(url: URL as URL)
    NSURLConnection.sendAsynchronousRequest(loadRequest, queue: OperationQueue.main) {
        response, data, error in
        
        if error != nil {
          completion(nil, error as Error? as NSError?)
          return
        }
        
        if data != nil {
          completion(UIImage(data: data!), nil)
          return
        }
        
        completion(nil, nil)
    }
  }
}


extension FlickrPhoto {
  var isFavourite: Bool {
    get {
      return UserDefaults.standard.bool(forKey: photoID)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: photoID)
    }
  }
}

func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
  return lhs.photoID == rhs.photoID
}

class Flickr {
  
  let processingQueue = OperationQueue()
  func searchFlickrForTerm(_ searchTerm: String, completion : @escaping (_ results: FlickrSearchResults?, _ error : NSError?) -> Void){
    print("Flickr->searchFlickrForTerm:searchTerm:\(searchTerm)")
    let searchURL = flickrSearchURLForSearchTerm(searchTerm)
    print("Flickr->searchFlickrForTerm:searchURL:\(searchURL)")
    let searchRequest = URLRequest(url: searchURL)
    print("Flickr->searchFlickrForTerm:searchRequest:\(searchRequest)")
    NSURLConnection.sendAsynchronousRequest(searchRequest, queue: processingQueue) {response, data, error in
      if error != nil {
        print("Flickr->searchFlickrForTerm: gives error")
        completion(nil,error as Error? as NSError?)
        return
      }
        if data == nil{
            print("Flickr->searchFlickrForTerm: data is nil")
            completion(nil,error as Error? as NSError?)
            return
        }
        do {
            print("Flickr->searchFlickrForTerm:response:\(response)")
            print("Flickr->searchFlickrForTerm:data:\(data)")
            //let JSONError : Error?
            let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            /*if JSONError != nil {
                completion(nil, JSONError as NSError?)
                return
            }*/
            print("Flickr->searchFlickrForTerm:resultsDictionary:\(resultsDictionary)")
            switch (resultsDictionary["stat"] as! String) {
            case "ok":
                print("Results processed OK")
            case "fail":
                let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:resultsDictionary["message"]!])
                completion(nil, APIError)
                return
            default:
                let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                completion(nil, APIError)
                return
            }
            let photosContainer = resultsDictionary["photos"] as! NSDictionary
            let photosReceived = photosContainer["photo"] as! [NSDictionary]
            
            let flickrPhotos : [FlickrPhoto] = photosReceived.map {
                photoDictionary in
                
                let photoID = photoDictionary["id"] as? String ?? ""
                let title = photoDictionary["title"] as? String ?? ""
                let farm = photoDictionary["farm"] as? Int ?? 0
                let server = photoDictionary["server"] as? String ?? ""
                let secret = photoDictionary["secret"] as? String ?? ""
                
                let flickrPhoto = FlickrPhoto(photoID: photoID, title: title, farm: farm, server: server, secret: secret)
                
                return flickrPhoto
            }
            
            DispatchQueue.main.async(execute: {
                completion(FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos), nil)
            })
        } catch let error as NSError {
            print(error)
        }
      //let resultsDictionary = JSONSerialization.JSONObjectWithData(data, options:JSONSerialization.ReadingOptions(0), error: &JSONError) as? NSDictionary
      
      
      
      
      
    }
  }
  
  fileprivate func flickrSearchURLForSearchTerm(_ searchTerm:String) -> URL {
    //let escapedTerm = searchTerm.addingPercentEscapes(using:String.Encoding.utf8)!
    print("Flickr->flickrSearchURLForSearchTerm:searchTerm:\(searchTerm)")
    let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    print("Flickr->flickrSearchURLForSearchTerm:escapedTerm:\(escapedTerm)")
    let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm!)&per_page=30&format=json&nojsoncallback=1"
    print("Flickr->flickrSearchURLForSearchTerm:URLString:\(URLString)")
    return URL(string: URLString)!
  }
  
  
}
