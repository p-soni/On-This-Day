//  PlacesViewController.swift
//  final-project-s17-empire
//
//  Created by Puja Soni on 4/27/17.
//  Copyright © 2017 Charu Mishra. All rights reserved.
//

/*
 * Copyright 2017 Google Inc. All rights reserved.
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import UIKit
import GooglePlaces
import CoreData

class PlacesViewController: UIViewController {
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    // An array to hold the list of possible locations.
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    static var name: String!
    
    // Cell reuse id (cells that scroll out of view can be reused).
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("From Places")
        //print(likelyPlaces)
        // Register the table view cell class and its reuse id.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller provides delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "unwindToDay" {
//            if let nextViewController = segue.destination as? ThisDayViewController {
//                nextViewController.selectedPlace = selectedPlace
//            }
//        }
    }
}

// Respond when a user selects a place.
extension PlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlace = likelyPlaces[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return  }
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
                let entity = NSEntityDescription.entity(forEntityName: "Places", in: managedContext)!
                let newPlace = NSManagedObject(entity: entity, insertInto: managedContext)
                newPlace.setValue(selectedPlace?.name, forKey: "loc")
                let currDay = try managedContext.fetch(request) as! [NSManagedObject]
                newPlace.setValue(currDay[0], forKey: "dayPlace")
//                print(currDay)
//                print(newPlace)
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        
        
        
        performSegue(withIdentifier: "unwindToDay", sender: self)
    }
}

// Populate the table with the list of most likely places.
extension PlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likelyPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let collectionItem = likelyPlaces[indexPath.row]
        cell.textLabel?.text = collectionItem.name
        return cell
    }
    
    // Adjust cell height to only show the first five items in the table
    // (scrolling is disabled in IB).
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height/5
    }
    
    // Make table rows display at proper height if there are less than 5 items.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == tableView.numberOfSections - 1) {
            return 1
        }
        return 0
    }
}
