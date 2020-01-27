//
//  ViewController.swift
//  FinalProjectAdvanceios
//
//  Created by Amanpreet Kaur on 2020-01-23.
//  Copyright © 2020 Amanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVAudioRecorderDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var descTxtField: UITextView!
    //Var for Audio recording
    
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var play: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
   var player =  AVAudioPlayer()
    
    
    
    
    //
    var EditNote: NSManagedObject?
    var noteName = ""
    var old: Bool?
    var context: NSManagedObjectContext?
    var catagary_name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initializing recording session
        recordingSession = AVAudioSession.sharedInstance()
        
       
        
        
        //For Note whole Detail
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
                
                imageView.image = EditNote!.value(forKey: "image") as! UIImage
            }
                catch{
                    print(error)
                }
            }
        else{
            // new task
            
            categoryTxtField.text = catagary_name ?? ""
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
            EditNote!.setValue(NSDate(), forKey: "date")
        EditNote!.setValue(imageView.image, forKey: "image")
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
        
        
    
    
    @IBAction func ImagePicker(_ sender: UIButton) {
        //AC
        // action = from galary
        
    
        let ac = UIAlertController(title: "Select Image source", message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            showImagePickerController(sourceType: .camera )
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
        ac.addAction(photoLibraryAction)
        ac.addAction(cameraAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: nil)
        
        
        func showImagePickerController(sourceType: UIImagePickerController.SourceType){
            let vc = UIImagePickerController()
            vc.sourceType = sourceType
                   vc.allowsEditing = true
                   vc.delegate = self
                   present(vc, animated: true)
        }
        
        // action  = from camera
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)

        guard let selectedIMAGE = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        imageView.image = selectedIMAGE
        
    }
    
    
    
    
    @IBAction func record_btn_pressed(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "record"{
            startRecording()
            // start recording
            sender.setTitle("Stop recording", for: .normal)
            
        }else{
            stopRecording()
            // stop recording
            sender.setTitle("record", for: .normal)
            
        }
        
    }
    
    
    func startRecording(){
       
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(titleTxtField.text!).m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

           
        } catch {
            print("error in recording")//finishRecording(success: false)
        }
        
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func stopRecording(){
        
//        audioRecorder.stop()
//        audioRecorder = nil

        
    }
    
    @IBAction func playBTN(_ sender: UIButton) {
        
    
    
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(titleTxtField.text!).m4a")

        
        if sender.titleLabel?.text == "play"{
         // play audio from file
            
            
            let audioFilename = getDocumentsDirectory().appendingPathComponent("\(titleTxtField.text!).m4a")
            
            
            // code
            
            do {
                              try player = AVAudioPlayer(contentsOf: audioFilename )
                             
                          } catch {
                              print(error)
                          }
            
            sender.setTitle("stop", for: .normal)
            
        }else{
            
            
            //stop code
            player.stop()
           // player = nil
            
             sender.setTitle("play", for: .normal)
            
        }
        
        
    }
    
}


