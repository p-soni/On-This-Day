//
//  AddMomentViewController.swift
//  final-project-s17-empire
//
//  Created by Charu Mishra on 4/13/17.
//  Copyright © 2017 Charu Mishra. All rights reserved.
//

import UIKit
import CoreData

class AddMomentViewController: UIViewController {
    @IBOutlet weak var momentTextField: UITextView!
    @IBOutlet weak var dateLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateLabel.text = dateFormat.string(for: CalView.labelDate)
        
        momentTextField.layer.borderWidth = 1.0;
        momentTextField.layer.borderColor = (UIColor.black).cgColor;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func saveMoment(_ sender: UIBarButtonItem) {
        let moment = momentTextField.text!
        
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
                // no matching object. create new entity for this selected date.
//
                
            }
            else{
                // at least one matching object exists....set moment hither
                let entity = NSEntityDescription.entity(forEntityName: "Moment", in: managedContext)!
                let newMoment = NSManagedObject(entity: entity, insertInto: managedContext)
                newMoment.setValue(moment, forKey: "desc")
                
                let currDay = try managedContext.fetch(request) as! [NSManagedObject]
                newMoment.setValue(currDay[0], forKey: "dayM")
                
                //print(currDay)
                //print(newMoment)
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        performSegue(withIdentifier: "unwindToDay", sender: self)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    
    
}
