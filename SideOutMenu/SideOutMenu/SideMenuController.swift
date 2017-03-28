//
//  SideMenuController.swift
//  SideOutMenu
//
//  Created by Rajesh Billakanti on 26/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
    var menu = Array<String>()
    var bcolor=UIColor(red:162/255.0,green:172/255.0,blue:180/255.0,alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.append("View 1")
        menu.append("View 2")
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = UIColor.clear
        self.view.backgroundColor = bcolor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as UITableViewCell
        
        
        cell.textLabel?.text = menu[indexPath.row]
        cell.backgroundColor = UIColor.clear
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        let cell = tableview.cellForRow(at: indexPath) as UITableViewCell!
        cell?.backgroundColor=UIColor( red: 0, green: 0, blue:0.2, alpha: 0.1 )
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        let cell = tableview.cellForRow(at: indexPath) as UITableViewCell!
        cell?.backgroundColor=UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sidemenuclick?.current_background = indexPath.row
        sidemenuclick?.request_background_update!()
    }
    

}
