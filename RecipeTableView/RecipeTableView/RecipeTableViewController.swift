//
//  RecipeTableViewController.swift
//  RecipeTableView
//
//  Created by Rajesh Billakanti on 27/02/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController{
    
    //Initializing a Recipe Object
    var recipesList = [Recipes]()
    
    //Initializing a Recipe Object which contains filtered list
    var filteredRecipes = [Recipes]()
    
    //By initializing UISearchController without a searchResultsController, you are telling the search controller that you want use the same view that you’re searching to display the results.
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assigning separator style none, i.e., removing default separeter.
        tableView.separatorStyle = .none
        
        //As the RecipeViewController is a subclass of UITableViewController, we use “self.parentViewController” to access its parent view, followed by assigning the background. By default, the table view is displayed in white. We set its color to transparent so as not to block out the background of the parent view.
        self.parent?.view.backgroundColor = UIColor(patternImage: UIImage(named: "common_bg")!)
        self.tableView.backgroundColor = UIColor.clear
        
        //Adds padding 5 to navigation bar from tableview
        let inset = 	UIEdgeInsetsMake(5, 0, 0, 0)
        self.tableView.contentInset = inset
        
        //Reading a Plist file, assigning data from plist to dictionary, mapping data to a Recipe object in Swift2
        /*if let path = Bundle.main.path(forResource: "recipes", ofType: "plist") {
            if var dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                print("dict :\(dict.description)")
                let recipesArray : Array<String> = (dict["RecipeName"] as? Array<String>)!
                for i in 0 ..< recipesArray.count  {
                    recipesList.append(Recipes(
                        recipeName:(dict["RecipeName"]![i] as? String)! ,
                        thumbnails:(dict["Thumbnail"]![i] as? String)!,
                        prepTime:(dict["PrepTime"]![i] as? String)!,
                        ingredients:(dict["Ingredients"]![i] as? Array<String>)!
                    ))
                    print("recipesList\(i) :\(recipesList[i].recipeName!)")
                }
            }
        }*/
        
        //Reading a Plist file, assigning data from plist to dictionary, mapping data to a Recipe object in Swift3
        if let fileUrl = Bundle.main.url(forResource: "recipes", withExtension: "plist") {
            do{
                let data = try? Data(contentsOf: fileUrl)
                print("data :\(data!.description)")
                let dict = try PropertyListSerialization.propertyList(from: data!, options: [], format: nil) as! Dictionary<String, AnyObject>
                print("dict :\(dict.description)")
                let recipesArray : Array<String> = (dict["RecipeName"] as? Array<String>)!
                for i in 0 ..< recipesArray.count  {
                    recipesList.append(Recipes(
                        recipeName:(dict["RecipeName"]![i] as? String)! ,
                        thumbnails:(dict["Thumbnail"]![i] as? String)!,
                        prepTime:(dict["PrepTime"]![i] as? String)!,
                        ingredients:(dict["Ingredients"]![i] as? Array<String>)!
                    ))
                    print("recipesList\(i) :\(recipesList[i].recipeName!)")
                }
            } catch {
                print("error:\(error)")
            }
        }
        
        //searchResultsUpdater is a property on UISearchController that conforms to the new protocol UISearchResultsUpdating. This protocol allows your class to be informed as text changes within the UISearchBar.
        searchController.searchResultsUpdater = self
        
        //By default, UISearchController will dim the view it is presented over. This is useful if you are using another view controller for searchResultsController.
        searchController.dimsBackgroundDuringPresentation = false
        
        //By setting definesPresentationContext on your view controller to true, you ensure that the search bar does not remain on the screen if the user navigates to another view controller while the UISearchController is active.
        definesPresentationContext = true
        
        //Finally, you add the searchBar to your table view’s tableHeaderView.
        tableView.tableHeaderView = searchController.searchBar
        
        //This will add a scope bar to the search bar, with the titles.
        searchController.searchBar.scopeButtonTitles = ["All","30 min","20 min"]
        searchController.searchBar.delegate = self 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            print("filteredRecipes.count : \(filteredRecipes.count)")
            return filteredRecipes.count
        }
        print("recipesList.count : \(recipesList.count)")
        return recipesList.count
    }
    
    //Function assigns a background image to each row in tableview
    func cellBackgroundForRowAtIndexPath(indexPath : IndexPath) -> UIImage{
        var beckground : UIImage?
        let rowCount = tableView.numberOfRows(inSection: 0)
        let rowIndex = indexPath.row
        if rowIndex  == 0 {
            beckground = UIImage(named: "cell_top.png")
        } else if rowIndex == rowCount - 1 {
            beckground = UIImage(named: "cell_bottom.png")
        } else {
            beckground = UIImage(named: "cell_middle.png")
        }
        return beckground!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
        //Collecting recipe name, image and details of each item from recipe object and assigning to a row
        let recipe : Recipes
        if searchController.isActive && searchController.searchBar.text != "" {
            recipe = filteredRecipes[indexPath.row]
        }else{
            recipe = recipesList[indexPath.row]
        }
        print("recipe to display: \(recipe.recipeName)")
        let recipeImageView = cell.viewWithTag(100) as! UIImageView
        recipeImageView.image = UIImage(named: recipe.thumbnails!)
        
        let recipeNameLabel = cell.viewWithTag(101) as! UILabel
        recipeNameLabel.text = recipe.recipeName

        let recipeDetailLabel = cell.viewWithTag(102) as! UILabel
        recipeDetailLabel.text = recipe.prepTime
        
        let beckground : UIImage = cellBackgroundForRowAtIndexPath(indexPath: indexPath)
        cell.backgroundView = UIImageView(image: beckground)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //For displaying a checkmark when a row is selected in tableview
        //let cell = tableView.cellForRow(at: indexPath)
        //cell?.accessoryType = .checkmark
        //If you don't want to highlight the row when it is selected.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //for removing a particular recipe from recipe list.
        recipesList.remove(at: indexPath.row)
        
        //Reload the table data to reflect the modified change
        tableView.reloadData()
    }
    
    //Method used to pass data from one view controller to another
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.tableView.indexPathForSelectedRow
        let recipe : Recipes
        if searchController.isActive && searchController.searchBar.text != "" {
            recipe = filteredRecipes[(indexPath?.row)!]
        }else{
            recipe = recipesList[(indexPath?.row)!]
        }
        if segue.identifier == "showRecipeDetail" {
            //Creating a reference to destination view controller to pass data
            let destViewController = segue.destination as! RecipeDetailViewController
            destViewController.recipe = recipe
        } else {
            //Instead using segue we can navigate to another view controller
            let simpleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SimpleViewController") as! SimpleViewController
            simpleViewController.rName = recipe.recipeName
            present(simpleViewController, animated: true, completion: nil)
        }
    }
    
    //This filters the recipes array based on searchText and will put the results in the filteredRecipes array
    func filterContentFor(searchText: String, scope: String = "All"){
        filteredRecipes = recipesList.filter { recipe in
            print("filterContentForsearchText: \((recipe.recipeName?.lowercased().contains(searchText.lowercased()))!)")
            let recipeMatch = (scope == "All") || (recipe.prepTime == scope)
            
            //This now checks to see if the scope provided is either set to “All” or it matches the preptime of the recipe.
            return recipeMatch && (recipe.recipeName?.lowercased().contains(searchText.lowercased()))!
        }
        print("filteredRecipes: \(filteredRecipes)")
        tableView.reloadData()
    }
    
}

//To allow RecipeTableViewController to respond to the search bar, it will have to implement UISearchResultsUpdating.
extension RecipeTableViewController : UISearchResultsUpdating {
    //Below method must be implement to conform to the UISearchResultsUpdating protocol.
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        print("searchController.searchBar.text: \(searchController.searchBar.text)")
        filterContentFor(searchText: searchController.searchBar.text!, scope: scope)
    }
}


//The scope bar is a segmented control that narrows down a search by only searching in certain scopes. UISearchBarDelegate delegate methods gets called when the user switches the scope in the scope bar.
extension RecipeTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentFor(searchText: searchBar.text!, scope: (searchBar.scopeButtonTitles?[selectedScope])!)
    }
}
