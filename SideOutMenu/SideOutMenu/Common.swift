//
//  Common.swift
//  SideOutMenu
//
//  Created by Rajesh Billakanti on 26/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import Foundation

//delegate that require the side menu to open
@objc
protocol SideMenuDelegate {
    @objc optional func open_side_menu()
}

//delegate from the side menu click
@objc
protocol SideMenuClick {
    var current_background : Int { get set }
    @objc optional func request_background_update()
}

//delegate variables
var sidemenuclick : SideMenuClick?
var sidemenudelegate : SideMenuDelegate?
