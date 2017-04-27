/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreData

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
  
  @IBOutlet var tableView: UITableView!
  
  var isAuthenticated = false
  
  var managedObjectContext: NSManagedObjectContext?
  var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

  var didReturnFromBackground = false
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem
    
    view.alpha = 0
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MasterViewController.insertNewObject(_:)))
    self.navigationItem.rightBarButtonItem = addButton
    
    NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.appWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.appDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
  }
  
  @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {

    isAuthenticated = true
    view.alpha = 1.0
  }
  
  func appWillResignActive(_ notification : Notification) {

    view.alpha = 0
    isAuthenticated = false
    didReturnFromBackground = true
  }
  
  func appDidBecomeActive(_ notification : Notification) {

    if didReturnFromBackground {
      self.showLoginView()
    }
  }

  
  override func viewDidAppear(_ animated: Bool) {
    
    super.viewDidAppear(false)
    self.showLoginView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func showLoginView() {
    
    if !isAuthenticated {

      self.performSegue(withIdentifier: "loginView", sender: self)
    }
  }
  
  func insertNewObject(_ sender: AnyObject) {
    let context = self.fetchedResultsController.managedObjectContext
    let entity = self.fetchedResultsController.fetchRequest.entity!
    let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: entity.name!, into: context) as NSManagedObject
    
    newManagedObject.setValue(Date(), forKey: "date")
    newManagedObject.setValue("New Note", forKey: "noteText")
    
    do {
      try context.save()
    } catch let error1 as NSError {
      print("Error inserting data \(error1)")
      abort()
    }
  }
  
  // MARK: - Segues
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let object = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
        (segue.destination as! DetailViewController).detailItem = object
      }
    }
  }
  
  // MARK: - Table View
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.fetchedResultsController.sections?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    self.configureCell(cell, atIndexPath: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let context = self.fetchedResultsController.managedObjectContext
      context.delete(self.fetchedResultsController.object(at: indexPath) as! NSManagedObject)
      
      do {
        try context.save()
      } catch let error1 as NSError {
        print("Error editing the table \(error1)")
        abort()
      }
    }
  }
  
  func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
    let object = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
    cell.textLabel?.text = (object.value(forKey: "noteText")! as AnyObject).description
  }
  
  
  @IBAction func logoutAction(_ sender: AnyObject) {

    isAuthenticated = false
    self.performSegue(withIdentifier: "loginView", sender: self)
  }
  
  // MARK: - Fetched results controller
  
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
    if _fetchedResultsController != nil {
      return _fetchedResultsController!
    }
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()

    let entity = NSEntityDescription.entity(forEntityName: "Note", in: self.managedObjectContext!)
    fetchRequest.entity = entity
    
    fetchRequest.fetchBatchSize = 20
    
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    //let sortDescriptors = [sortDescriptor]
    
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    aFetchedResultsController.delegate = self
    _fetchedResultsController = aFetchedResultsController
    
    do {
      try _fetchedResultsController!.performFetch()
    } catch let error1 as NSError {
      print("Error fetching data \(error1)")

      abort()
    }
    
    return _fetchedResultsController!
  }
  
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    default:
      return
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .fade)
    case .update:
      self.configureCell(tableView.cellForRow(at: indexPath!)!, atIndexPath: indexPath!)
    case .move:
      tableView.deleteRows(at: [indexPath!], with: .fade)
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    }
  }
  
  
}

