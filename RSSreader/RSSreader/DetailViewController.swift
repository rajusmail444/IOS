//
//  DetailViewController.swift
//  RSSreader
//
//  Created by Rajesh Billakanti on 19/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    @IBOutlet var webView: UIWebView!
    var url : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("url:\(url!)")
        let myUrl = URL(string: (url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        print("myUrl:\(myUrl)")
        let request = URLRequest(url: myUrl!)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

