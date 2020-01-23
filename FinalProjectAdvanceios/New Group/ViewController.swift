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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do{
            let result = try context.fetch(fetchReq)
            for r in result as! [NSManagedObject]{
                categoryTxtField.text = r.value(forKey: "category") as? String
                titleTxtField.text = r.value(forKey: "title") as? String
                descTxtField.text = r.value(forKey: "desc") as? String
                }
        }
            catch{
                print(error)
            }
        }
    


    @IBAction func saveData(_ sender: UIButton) {
        do{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let notesEntity = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
        
        let Category = categoryTxtField.text ?? ""
        let Title = titleTxtField.text ?? ""
        let Description = descTxtField.text ?? ""
        
        
        notesEntity.setValue(Category, forKey: "category")
        notesEntity.setValue(Title, forKey: "title")
        notesEntity.setValue(Description, forKey: "desc")
    
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        categoryTxtField.text = ""
        titleTxtField.text = ""
        descTxtField.text = ""
        
    }
}

}
