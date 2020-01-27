//
//  CategoryTableViewController.swift
//  FinalProjectAdvanceios
//
//  Created by Alisha Thind on 2020-01-23.
//  Copyright © 2020 Amanpreet Kaur. All rights reserved.
//

import UIKit
import  CoreData

class CategoryTableViewController: UITableViewController {

    var category: [String]?
//    var cat = ""
//    @IBOutlet weak var hourLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

      loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        
    }                                     

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell"){
        
            cell.textLabel?.text = category![indexPath.row]
            
        // Configure the cell...
         return cell
            
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let categ = category![indexPath.row] as? String
//        let categ = category![indexPath.row].value(forKey: "category") as? String
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:
        "Notes")
        fetchReq.predicate = NSPredicate(format: "category contains %@", categ!)
        fetchReq.returnsObjectsAsFaults = false
        
        
        let  delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
        do{
        let req = try context.fetch(fetchReq)
            for r in req as! [NSManagedObject]
            {
                context.delete(r)
                self.category?.remove(at: indexPath.row)
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
        
        
        if let des = segue.destination as? NotesTableViewController{
            
            des.catname = (sender as! UITableViewCell).textLabel?.text
            
            
        }
        
        if let des2 = segue.destination as? ViewController{
            des2.old = false
        }
        
        
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

    func loadData()
    {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       let context = appDelegate.persistentContainer.viewContext
         
       let FetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        do{
            category = []
            let result = try context.fetch(FetchReq)
            for r in result as! [NSManagedObject]{
                let cat = r.value(forKey: "category") as! String
                
                if(!category!.contains(cat)){
                    category!.append(cat)}
            }
        }
        catch{
            print(error)
        }
        tableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
}
