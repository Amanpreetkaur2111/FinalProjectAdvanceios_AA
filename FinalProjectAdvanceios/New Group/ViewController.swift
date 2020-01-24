//
//  ViewController.swift
//  FinalProjectAdvanceios
//
//  Created by Amanpreet Kaur on 2020-01-23.
//  Copyright © 2020 Amanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var descTxtField: UITextView!
    
    var EditNote: NSManagedObject?
    var noteName = ""
    var old: Bool?
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        if old!{
            // old note
            
            
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            
            fetchReq.predicate = NSPredicate(format: "title = %@", noteName)
            fetchReq.returnsObjectsAsFaults = false
            
            
            do{
                let result = try context!.fetch(fetchReq)
                EditNote = result[0] as! NSManagedObject
                    categoryTxtField.text = EditNote!.value(forKey: "category") as? String
                    titleTxtField.text = EditNote!.value(forKey: "title") as? String
                    descTxtField.text = EditNote!.value(forKey: "desc") as? String
                    
                
                
            }
                catch{
                    print(error)
                }
            }
            
        }
        
    


    @IBAction func saveData(_ sender: UIButton) {
        
        if !old! {
            // add new objectnew object
            EditNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context!)
            
        }
            
            EditNote!.setValue(categoryTxtField.text, forKey: "category")
                EditNote!.setValue(titleTxtField.text, forKey: "title")
            EditNote!.setValue(descTxtField.text, forKey: "desc")
            
                do{
                    try context!.save()
                }
                catch{
                    print(error)
                }
                categoryTxtField.text = ""
                titleTxtField.text = ""
                descTxtField.text = ""
       
          
        }
        
        
  
        
}


