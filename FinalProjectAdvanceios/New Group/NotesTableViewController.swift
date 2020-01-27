//
//  NotesTableViewController.swift
//  FinalProjectAdvanceios
//
//  Created by Alisha Thind on 2020-01-23.
//  Copyright © 2020 Amanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData


class NotesTableViewController: UITableViewController {

    
    var notes: [NSManagedObject]?
    var catname: String?
    var noteToSearch: String?
    var performSearch = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = 100
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)

        cell.textLabel?.text = notes![indexPath.row].value(forKey: "title") as! String
        cell.detailTextLabel?.text = (notes![indexPath.row].value(forKey: "date") as! Date).description + " Lat: \(notes![indexPath.row].value(forKey: "latitude") as! Double) , Long: \(notes![indexPath.row].value(forKey: "longitude") as! Double)"
       // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let notesTitle = notes![indexPath.row].value(forKey: "title") as? String
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:
        "Notes")
        fetchReq.predicate = NSPredicate(format: "title contains %@", notesTitle!)
        fetchReq.returnsObjectsAsFaults = false
        
        
        let  delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
        do{
        let req = try context.fetch(fetchReq)
            for r in req as! [NSManagedObject]
            {
                context.delete(r)
                self.notes?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            }
            catch {
                print(error)
            }
        }
            do{
              try context.save()
              loadData()
              }
            catch
              {
              print(error)
              }
          return UISwipeActionsConfiguration(actions: [delete])
        }
    

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? ViewController{
            if let cell = sender as? UITableViewCell{
                           
                destination.old = true
                destination.noteName = notes![tableView.indexPath(for: cell)!.row].value(forKey: "title") as! String
//                destination.noteName = notes![tableView.indexPath(for: cell)!.row].value(forKey: "title") as! String
                
            }
            
            if let button = sender as? UIBarButtonItem {
                destination.old = false
                destination.catagary_name = catname
                
            }
        }
    }
    
    
    func loadData()
    {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       let context = appDelegate.persistentContainer.viewContext
         
       let FetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        
        if performSearch{
            
    FetchReq.predicate = NSPredicate(format: "title contains[c] %@", noteToSearch!)
            
            
        }else{
            FetchReq.predicate = NSPredicate(format: "category = %@", catname!)
        }
        
        
        
         
        do{
            let result = try context.fetch(FetchReq)
            notes = result as! [NSManagedObject]
        }
        catch{
            print(error)
        }
        tableView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        loadData()
    }
}
