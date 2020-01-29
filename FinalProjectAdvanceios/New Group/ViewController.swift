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
import CoreLocation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVAudioRecorderDelegate,AVAudioPlayerDelegate , CLLocationManagerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var descTxtField: UITextView!
    //Var for Audio recording
    
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var play: UIButton!
    
    
    var SoundRecorder: AVAudioRecorder!
    var SoundPlayer: AVAudioPlayer!
    
    
    //var fileName : String? //= "audioFile.m4a"
    
    var latitude : Double = 0.0
    var  longitude : Double = 0.0
    
    
    //
    var EditNote: NSManagedObject?
    var noteName = ""
    var old: Bool?
    var context: NSManagedObjectContext?
    var catagary_name: String?
    
    // location manager
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        play.isEnabled = old!
        
        
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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
            
    }
    
    
        @objc func viewTapped(){
          categoryTxtField.resignFirstResponder()
          titleTxtField.resignFirstResponder()
          descTxtField.resignFirstResponder()
          record.resignFirstResponder()
          play.resignFirstResponder()
          }
    
         func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    // grabbing the user location
         let userLocation: CLLocation = locations[0]
    
        if !old!{
        
        latitude = Double(userLocation.coordinate.latitude)
        longitude = Double(userLocation.coordinate.longitude)}
        }
    
    
    
       func getDocumentsDirector() -> URL {
       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           return paths[0]
       }
       
       func setupRecorder() {
       let audioFilename = getDocumentsDirector().appendingPathComponent("\(titleTxtField.text).m4a")
       let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless ,
                           AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                           AVEncoderBitRateKey : 320000,
                           AVNumberOfChannelsKey : 2,
                           AVSampleRateKey : 44100.2 ] as [String : Any]
           do {
               SoundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
               SoundRecorder.delegate = self
               SoundRecorder.prepareToRecord()
              } catch {
               print(error)
              }
              }
       
       func setupPlayer()
       {
              let audioFilename = getDocumentsDirector().appendingPathComponent("\(titleTxtField.text).m4a")
              do {
               SoundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
               SoundPlayer.delegate = self
               SoundPlayer.prepareToPlay()
               SoundPlayer.volume = 1.0
              } catch {
               print(error)
              }
        }
       
    
    
       func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
           play.isEnabled = true
       }
       
    
       func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
           record.isEnabled = true
           play.setTitle("Play", for: .normal)
       }
       
       
       
       @IBAction func recordBtn(_ sender: Any) {
           if record.titleLabel?.text == "Record" {
                setupRecorder()
                SoundRecorder.record()
                record.setTitle("Stop", for: .normal)
                play.isEnabled = false
               } else {
                SoundRecorder.stop()
                record.setTitle("Record", for: .normal)
                play.isEnabled = false
               }
           }
    
    
    
    @IBAction func playBtn(_ sender: Any) {
          if play.titleLabel?.text == "Play" {
                play.setTitle("Stop", for: .normal)
                record.isEnabled = false
                setupPlayer()
                SoundPlayer.play()
           } else {
                   
                SoundPlayer!.stop()
                play.setTitle("Play", for: .normal)
                record.isEnabled = false
                 }
           }
    
    
    
    @IBAction func saveData(_ sender: UIButton) {
         if categoryTxtField.text == "" || titleTxtField.text == "" || descTxtField.text == "" {
                let alertController = UIAlertController(title: "Empty Fields", message:"All fields are mandatory", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true, completion: nil)
          }
        
        
    if !old! {
            // add new objectnew object
            EditNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context!)
            }
            
            EditNote!.setValue(categoryTxtField.text, forKey: "category")
            EditNote!.setValue(titleTxtField.text, forKey: "title")
            EditNote!.setValue(descTxtField.text, forKey: "desc")
            EditNote!.setValue(NSDate(), forKey: "date")
            EditNote!.setValue(imageView.image, forKey: "image")
            EditNote!.setValue(longitude, forKey: "longitude")
            EditNote!.setValue(latitude, forKey: "latitude")
        
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
        
        
        
        func showImagePickerController(sourceType: UIImagePickerController.SourceType)
        {
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if let descrip = segue.destination as? RouteViewController {
            descrip.latit =  EditNote!.value(forKey: "latitude") as! CLLocationDegrees
            descrip.longi = EditNote!.value(forKey: "longitude") as! CLLocationDegrees}
    }
    
    
}


