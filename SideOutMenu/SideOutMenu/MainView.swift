//
//  MainView.swift
//  SideOutMenu
//
//  Created by Rajesh Billakanti on 26/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class MainView: UIViewController, SideMenuClick {

    @IBOutlet var background: UIImageView!
    var current_background: Int = 0
    var b_list : [String] = ["im1.jpg", "im2.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = UIImage(named: b_list[current_background])
        sidemenuclick = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func open(_ sender: Any) {
        sidemenudelegate?.open_side_menu?()
    }
    func request_background_update()
    {
        background.image = UIImage(named: b_list[current_background])
    }

}
