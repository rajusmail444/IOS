//
//  MasterViewController.swift
//  RSSreader
//
//  Created by Rajesh Billakanti on 19/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, XMLParserDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    var parser : XMLParser?
    var feeds = [Dictionary<String, String>]()
    var item = Dictionary<String, String>()
    var feedTitle : String = ""
    var link : String = ""
    var element : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize, start and load the XMLParser object
        let url = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")
        parser = XMLParser(contentsOf: url!)
        parser?.delegate = self
        parser?.parse()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                let string = feeds[(indexPath.row)]["link"]
                print("final url:\(string!)")
                controller.url = string!
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = feeds[indexPath.row]["title"]
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //implementing the parser delegate methods
    //Whenever the parser finds a new element, it calls the didStartElement method from its delegate. In that method we have to check that the element found is an “item”, and if so, we allocate the variables to store the item.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("element2:\(elementName)")
        element = elementName
        print("element:\(element)")
        if element == "item" {
            feedTitle = ""
            link = ""
        }
    }
    
    //The parser calls its delegate every time new characters are found. since we have to add the new characters found to the previous ones.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("element1:\(element)")
        if element == "title" {
            feedTitle += string
            item[element] = feedTitle
            print("element1:feedTitle:\(feedTitle)")
        }else if element == "link" {
            link += string
            item[element] = link
            print("element1:link:\(link)")
        }
    }
    
    
    //When the parser encounters the end of an element, it calls the didEndElement method. In that case we simply add the new object to the array of feeds.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("element2:\(elementName)")
        if elementName == "item" {
            print("element2:item:\(item)")
            feeds.append(item)
            print("element2:feeds:\(feeds)")
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
}

