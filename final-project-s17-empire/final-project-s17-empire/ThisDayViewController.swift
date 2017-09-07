//
//  ThisDayViewController.swift
//  final-project-s17-empire
//
//  Created by Charu Mishra on 4/13/17.
//  Copyright © 2017 Charu Mishra. All rights reserved.
//

import UIKit
import CoreData

class ThisDayViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locLabel: UITextView!
    @IBOutlet weak var picLabel: UIImageView!
    
    var date: Date?
    var fetchedImage: UIImage!
    static var JanPics = [UIImage?](repeating:nil, count:32)
    static var FebPics = [UIImage?](repeating:nil, count:29)
    static var MarchPics = [UIImage?](repeating:nil, count:32)
    static var AprilPics = [UIImage?](repeating:nil, count:31)
    static var MayPics = [UIImage?](repeating:nil, count:7)
    
    @IBOutlet weak var momentDescrip: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateLabel.text = dateFormat.string(for: CalView.labelDate)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        let predicate = NSPredicate(format: "date == %@", CalView.labelDate as CVarArg)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do{
            let count = try managedContext.count(for: request)
            if(count == 0){
            }
            else{
                
                let currDay = try managedContext.fetch(request) as! [NSManagedObject]
                let d = currDay[0].value(forKeyPath: "hasMoments.desc")
                let stringD = String(describing: d)
                let start = stringD.index(stringD.startIndex, offsetBy: 11)
                let end = stringD.index(stringD.endIndex, offsetBy: -3)
                let range = start..<end
                momentDescrip.text = stringD.substring(with: range)
                
                let p = currDay[0].value(forKeyPath: "hasPlaces.loc")
                let stringP = String(describing: p)
                let start2 = stringP.index(stringP.startIndex, offsetBy: 11)
                let end2 = stringP.index(stringP.endIndex, offsetBy: -3)
                let range2 = start2..<end2
                locLabel.text = stringP.substring(with: range2)
                
//<<<<<<< HEAD
                let str = dateLabel.text!
                if dateLabel.text?.range(of:"January") != nil {
                    let start = str.index(str.startIndex, offsetBy:8)
                    let end = str.index(str.endIndex, offsetBy: -6)
                    let range = start..<end
                    let index = Int(str.substring(with: range))
                    picLabel.image = ThisDayViewController.JanPics[index!]
                }
                if dateLabel.text?.range(of:"February") != nil {
                    let start = str.index(str.startIndex, offsetBy:9)
                    let end = str.index(str.endIndex, offsetBy: -6)
                    let range = start..<end
                    let index = Int(str.substring(with: range))
                    picLabel.image = ThisDayViewController.FebPics[index!]
                }
                if dateLabel.text?.range(of:"March") != nil {
                    let start = str.index(str.startIndex, offsetBy:6)
                    let end = str.index(str.endIndex, offsetBy: -6)
                    let range = start..<end
                    let index = Int(str.substring(with: range))
                    picLabel.image = ThisDayViewController.MarchPics[index!]
                }
                if dateLabel.text?.range(of:"April") != nil {
                    let start = str.index(str.startIndex, offsetBy:6)
                    let end = str.index(str.endIndex, offsetBy: -6)
                    let range = start..<end
                    let index = Int(str.substring(with: range))
                    picLabel.image = ThisDayViewController.AprilPics[index!]
                }
                if dateLabel.text?.range(of:"May") != nil {
                    let start = str.index(str.startIndex, offsetBy:4)
                    let end = str.index(str.endIndex, offsetBy: -6)
                    let range = start..<end
                    let index = Int(str.substring(with: range))
                    picLabel.image = ThisDayViewController.MayPics[index!]
                }
               
//=======
                
                
               
                //picLabel.image = pc as! UIImage
              //  fetchedImage = UIImage(data: pc as! Data)
              //  picLabel.image = fetchedImage
                
               // picLabel.image = [UIImage imageWithData: ]
                
               // self.imageView.image = [UIImage imageWithData:self.myEvent.picture];
                
                
//                //picLabel.image =
//                let i = UIImagePNGRepresentation(pc! as! UIImage)
//                //let i = UIImage .init(ciImage: pc as! CIImage)
//                picLabel.image = i as! UIImage
//>>>>>>> dc1bb12686918efd5b716dec66e96a742f1895b6
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
