//
//  ViewController.swift
//  May14Example1
//
//  Created by satiar rad on 2019-05-14.
//  Copyright © 2019 satiar rad. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    lazy var fetchResult : NSFetchedResultsController<Employee> = {
        let FetchReq  : NSFetchRequest<Employee> = Employee.fetchRequest()
        
        let sort = NSSortDescriptor(key: "job", ascending: true)
        FetchReq.sortDescriptors = [sort]
        
        
        let fetchResult = NSFetchedResultsController(fetchRequest: FetchReq, managedObjectContext: myAppdelegate.persistentContainer.viewContext, sectionNameKeyPath: "job", cacheName: nil)
        fetchResult.delegate = self;
        return fetchResult
    }()
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var myPredicate : NSPredicate? = nil
        
        if (searchText.count > 0){
           myPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        }
        
        
        
        fetchResult.fetchRequest.predicate = myPredicate
        
        doFetch()
        
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "noooooooo"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
          let objectToRemove =  fetchResult.object(at: indexPath)
            myAppdelegate.persistentContainer.viewContext.delete(objectToRemove)
            myAppdelegate.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  (fetchResult.sections![section]).name
    }
  
    func numberOfSections(in tableView: UITableView) -> Int {
        if let mySections = fetchResult.sections{
            return mySections.count
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchResult.sections![section]).numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
       let p1 =  fetchResult.object(at: indexPath)
        cell?.textLabel?.text = p1.name
        cell?.detailTextLabel?.text = p1.lastname
        
        return cell!
    }
    

    lazy var myAppdelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var lastname: UITextField!
    
    @IBAction func add() {
        let p1 = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: myAppdelegate.persistentContainer.viewContext)as! Employee
        p1.name = name.text
        p1.lastname = lastname.text
        p1.job = job.text
        
        myAppdelegate.saveContext();
        
    }
    @IBOutlet weak var job: UITextField!
    
    func doFetch() {
        do{
            try fetchResult.performFetch()
        }catch{
            //tell user reinstall
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doFetch()
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
extension UIViewController {
    
}

