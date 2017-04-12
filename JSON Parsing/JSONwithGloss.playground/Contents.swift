//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

// DataManager.getTopAppsDataFromFileWithSuccess { (data) -> Void in
DataManager.getTopAppsDataFromItunesWithSuccess { (data) -> Void in
    
    // First you deserialize the data using JSONSerialization just like before.
    var json: Any
    do {
        json = try JSONSerialization.jsonObject(with: data)
    } catch {
        print(error)
        PlaygroundPage.current.finishExecution()
    }
    
    guard let dictionary = json as? [String: Any] else {
        PlaygroundPage.current.finishExecution()
    }
    
    // Next, initialize an instance of TopApps by feeding the JSON data into it's constructor.
    guard let topApps = TopApps(json: dictionary) else {
        print("Error initializing object")
        PlaygroundPage.current.finishExecution()
    }
    
    // Finally, grab the first app by using the feed and entries properties on the model objects you created.
    guard let firstItem = topApps.feed?.entries?.first else {
        print("No such item")
        PlaygroundPage.current.finishExecution()
    }
    
    print(firstItem)
    
    PlaygroundPage.current.finishExecution()
}
