//
//  ViewController.swift
//  CoreData
//
//  Created by Rajesh Billakanti on 13/03/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //NSManagedObject represents a single object stored in Core Data; you must use it to create, edit, save and delete from your Core Data persistent store. As you’ll see shortly, NSManagedObject is a shape-shifter. It can take the form of any entity in your Data Model, appropriating whatever attributes and relationships you defined.
    var people : [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        //This will register the UITableViewCell class with the table view. Guarantees your table view will return a cell of the correct type when the Cell reuseIdentifier is provided to the dequeue method
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name", message: "Add a New Name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            [unowned self] action in
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else{
                return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func getManagedContext() -> NSManagedObjectContext{
        //Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
        //Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
        //Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
        let appDeligate = UIApplication.shared.delegate as? AppDelegate
        return appDeligate!.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let managedContext = getManagedContext()
        
        //As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data. Fetch requests are both powerful and flexible. You can use fetch requests to fetch a set of objects meeting the provided criteria (i.e. give me all employees living in Wisconsin and have been with the company at least three years), individual values (i.e. give me the longest name in the database) and more.
        //Fetch requests have several qualifiers used to refine the set of results returned. For now, you should know NSEntityDescription is a required one of these qualifiers.
        //Setting a fetch request’s entity property, or alternatively initializing it with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities. Also note NSFetchRequest is a generic type. This use of generics specifies a fetch request’s expected return type, in this case NSManagedObject.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(name: String){
        let managedContext = getManagedContext()
        
        //You create a new managed object and insert it into the managed object context. You can do this in one step with NSManagedObject’s static method: entity(forEntityName:in:).
        //You may be wondering what an NSEntityDescription is all about. Recall earlier, NSManagedObject was called a shape-shifter class because it can represent any entity. An entity description is the piece linking the entity definition from your Data Model with an instance of NSManagedObject at runtime.
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model, otherwise your app will crash at runtime.
        person.setValue(name, forKeyPath: "name")
        
        //You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //NSManagedObject doesn’t know about the name attribute you defined in your Data Model, so there’s no way of accessing it directly with a property. The only way Core Data provides to read the value is key-value coding, commonly referred to as KVC.
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let managedContext = getManagedContext()
        if(editingStyle == UITableViewCellEditingStyle.delete){
            managedContext.delete(people[indexPath.row])
            do {
                try managedContext.save()
                people.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
    }
}
