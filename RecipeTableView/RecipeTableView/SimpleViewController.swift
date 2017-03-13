//
//  SimpleViewController.swift
//  RecipeTableView
//
//  Created by Rajesh Billakanti on 12/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class SimpleViewController: UIViewController {

    @IBOutlet weak var recipeName: UILabel!
    var rName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeName.text = rName!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
