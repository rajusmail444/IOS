//
//  RecipeDetailViewController.swift
//  RecipeTableView
//
//  Created by Rajesh Billakanti on 03/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    //@IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var ingredientTextView: UITextView!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var recipePhoto: UIImageView!
    var recipe : Recipes?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = recipe!.recipeName
        self.recipePhoto.image = UIImage(named: recipe!.thumbnails!)
        self.prepTimeLabel.text = "Prep time: \(recipe!.prepTime!)"
        var ingredientText : String=""
        for ingredient in recipe!.ingredients {
            ingredientText.append(ingredient)
            ingredientText.append("\n")
        }
        self.ingredientTextView?.text = ingredientText
        
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
