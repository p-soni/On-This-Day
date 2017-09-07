//
//  AddImageViewController.swift
//  final-project-s17-empire
//
//  Created by Charu Mishra on 4/13/17.
//  Copyright © 2017 Charu Mishra. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class AddImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    var newMedia: Bool?
    
    @IBAction func useCamera(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = true
        }    }
    
    @IBAction func useImageLibrary(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = false
        }    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imageView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(AddImageViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code to support video here
            }
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateLabel.text = dateFormat.string(for: CalView.labelDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    //saves image into core data
    @IBAction func savePic(_ sender: UIBarButtonItem) {
        let mypic = imageView.image!
//<<<<<<< HEAD
//=======
        
        
//        if let data = UIImagePNGRepresentation(mypic) {
//            let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
//            try? data.write(to: filename)
//            //print(filename)
//        }
        
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        let predicate = NSPredicate(format: "date == %@", CalView.labelDate as CVarArg)
        request.predicate = predicate
        request.fetchLimit = 1
//>>>>>>> dc1bb12686918efd5b716dec66e96a742f1895b6
        
        let str = dateLabel.text! //may 5, 2017
        
        if str.range(of:"January") != nil {
            let start = str.index(str.startIndex, offsetBy:8)
            let end = str.index(str.endIndex, offsetBy: -6)
            let range = start..<end
            let index = Int(str.substring(with: range))
            ThisDayViewController.JanPics[index!] = mypic
        }
        if dateLabel.text?.range(of:"February") != nil {
            let start = str.index(str.startIndex, offsetBy:9)
            let end = str.index(str.endIndex, offsetBy: -6)
            let range = start..<end
            let index = Int(str.substring(with: range))
            ThisDayViewController.FebPics[index!] = mypic
        }
        if dateLabel.text?.range(of:"March") != nil {
            let start = str.index(str.startIndex, offsetBy:6)
            let end = str.index(str.endIndex, offsetBy: -6)
            let range = start..<end
            let index = Int(str.substring(with: range))
            ThisDayViewController.MarchPics[index!] = mypic
        }
        if dateLabel.text?.range(of:"April") != nil {
            let start = str.index(str.startIndex, offsetBy:6)
            let end = str.index(str.endIndex, offsetBy: -6)
            let range = start..<end
            let index = Int(str.substring(with: range))
            ThisDayViewController.AprilPics[index!] = mypic
        }
        if dateLabel.text?.range(of:"May") != nil {
            let start = str.index(str.startIndex, offsetBy:4)
            let end = str.index(str.endIndex, offsetBy: -6)
            let range = start..<end
            let index = Int(str.substring(with: range))
            ThisDayViewController.MayPics[index!] = mypic
        }

        performSegue(withIdentifier: "unwindFromPic", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    
}
