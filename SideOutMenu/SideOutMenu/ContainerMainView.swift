//
//  ContainerMainView.swift
//  SideOutMenu
//
//  Created by Rajesh Billakanti on 26/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

//side menu status variable
enum SideMenuState{
    case closed
    case opened
}

class ContainerMainView: UIViewController , SideMenuDelegate{

    var centerNavigationController : UINavigationController!
    var centerViewController : MainView!
    var side_menu_state : SideMenuState = .closed{
        didSet{
            let showShadow = side_menu_state != .closed
            showShadowForCenterViewController(shouldShowShadow: showShadow)
        }
    }
    var side_menu_controller : SideMenuController?
    var sidemenu_width : CGFloat = 150 //define here the side menu width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Take the Main view into centerViewController
        let main_storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        centerViewController = main_storyboard.instantiateViewController(withIdentifier: "MainView") as? MainView
        
        sidemenudelegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMove(toParentViewController: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func togglePanel() {
        let notAlreadyExpanded = (side_menu_state != .opened)
        if notAlreadyExpanded{
            addPanelViewController()
        }
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        switch (side_menu_state){
        case .opened:
            togglePanel()
        default:
            break
        }
    }
    
    func addPanelViewController() {
        if(side_menu_controller == nil){
            let main_storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            side_menu_controller = main_storyboard.instantiateViewController(withIdentifier: "SideMenu") as? SideMenuController
            addChildSidePanelController(menu: side_menu_controller!)
        }
    }
    
    func addChildSidePanelController(menu: SideMenuController) {
        view.insertSubview(menu.view, at: 0)
        addChildViewController(menu)
        menu.didMove(toParentViewController: self)
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            side_menu_state = .opened
            animateCenterPanelXPosition(targetPosition: -sidemenu_width)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.side_menu_state = .closed
                self.side_menu_controller!.view.removeFromSuperview()
                self.side_menu_controller = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    //Function which shows shadow for main view controller depending on whether it's open or close
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
            centerNavigationController.view.layer.shadowRadius = 20
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    //Function which Closes and Opens side menu or Hamburger menu
    func open_side_menu()
    {
        togglePanel()
    }
    
    //gesture recognition is defined
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        switch(recognizer.state){
        case .began:
            if(side_menu_state == .closed){
                if(gestureIsDraggingFromLeftToRight == false){
                    addPanelViewController()
                }
                showShadowForCenterViewController(shouldShowShadow: true)
            }
            
        case .changed:
            let screen_center = recognizer.view!.frame.width/2
            let new_center = recognizer.view!.center.x+recognizer.translation(in: view).x
            if(screen_center >= new_center)
            {
                recognizer.view!.center.x = new_center
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
            
            
        case .ended:
            if(side_menu_controller != nil)
            {
                let rec_center = recognizer.view!.center.x
                let screen_center = recognizer.view!.frame.width/2
                if(abs(screen_center-rec_center) > 20)
                {
                    
                    let direction = ( (recognizer.velocity(in: view).x < 10))
                    animateRightPanel(shouldExpand: direction)
                    
                }
                else
                {
                    let open = abs(screen_center - rec_center) > 40
                    animateRightPanel(shouldExpand: open)
                }
                
            }
            
        default:
            break
        }
    }

}
