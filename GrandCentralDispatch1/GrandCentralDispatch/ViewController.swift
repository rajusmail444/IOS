//
//  ViewController.swift
//  GrandCentralDispatch
//
//  Created by Rajesh Billakanti on 18/04/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //synchronously running queue
        //simpleSyncQueues()
        
        //synchronously running queue
        //simpleAsyncQueues()
        
        //queuesWithQoS()
        
        
        /*concurrentQueues()
         if let queue = inactiveQueue {
         queue.activate()
         }*/
        
        
        //queueWithDelay()
        
        //fetchImage()
        
        useWorkItem()
    }
    
    
    
    func simpleSyncQueues() {
        let queueSync = DispatchQueue(label: "in.RAjaY.sync")
        queueSync.sync {
            for i in 0 ..< 10 {
                print("🔴",i)
            }
        }
        for i in 100 ..< 110 {
            print("Ⓜ️",i)
        }
    }
    func simpleAsyncQueues() {
        let queueAsync = DispatchQueue(label: "in.RAjaY.async")
        queueAsync.async {
            for i in 0 ..< 10 {
                print("🔴",i)
            }
        }
        for i in 100 ..< 110 {
            print("Ⓜ️",i)
        }
    }
    
    
    func queuesWithQoS() {
        let queue1 = DispatchQueue(label: "in.RAjaY.queue1", qos: DispatchQoS.utility)
        let queue2 = DispatchQueue(label: "in.RAjaY.queue2", qos: DispatchQoS.userInitiated)
        queue1.async {
            for i in 0 ..< 10 {
                print("🔴",i)
            }
        }
        queue2.async {
            for i in 10 ..< 20 {
                print("🔵",i)
            }
        }
        for i in 100 ..< 110 {
            print("Ⓜ️",i)
        }
    }
    
    
    var inactiveQueue: DispatchQueue!
    func concurrentQueues() {
        let anotherQueue = DispatchQueue(label: "in.RAjaY.anotherQueue", qos: DispatchQoS.utility, attributes: [.concurrent, .initiallyInactive])
        inactiveQueue = anotherQueue
        anotherQueue.async {
            for i in 0 ..< 10 {
                print("🔴",i)
            }
        }
        anotherQueue.async {
            for i in 10 ..< 20 {
                print("🔵",i)
            }
        }
        anotherQueue.async {
            for i in 100 ..< 110 {
                print("⚫️",i)
            }
        }
        
    }
    
    
    func queueWithDelay() {
        let delayQueue = DispatchQueue(label: "in.RAjaY.delayqueue", qos: .userInitiated)
        print(Date())
        let additionalTime: DispatchTimeInterval = .seconds(7)
        delayQueue.asyncAfter(deadline: .now() + additionalTime, execute: {
            print(Date())
        })
    }
    
    
    func fetchImage() {
        let imageURL: URL = URL(string: "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png")!
        
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: imageURL, completionHandler: { (imageData, response, error) in
            
            if let data = imageData {
                print("Did download image data")
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }).resume()
    }
    
    
    func useWorkItem() {
        var value = 10
        let workItem = DispatchWorkItem {
            value += 5
        }
        //workItem.perform()
        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: workItem)
        workItem.notify(queue: DispatchQueue.main) {
            print("value = ", value)
        }
    }

}

