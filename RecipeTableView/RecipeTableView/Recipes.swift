//
//  Recipes.swift
//  RecipeTableView
//
//  Created by Rajesh Billakanti on 27/02/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import Foundation

//Creating a Recipe Class and initialization method.
class Recipes {
    var recipeName : String?
    var thumbnails : String?
    var prepTime : String?
    var ingredients:Array<String>
    
    init(recipeName:String,thumbnails:String,prepTime:String,ingredients:Array<String>) {
        self.recipeName = recipeName
        self.thumbnails = thumbnails
        self.prepTime = prepTime
        self.ingredients = ingredients
    }

}
