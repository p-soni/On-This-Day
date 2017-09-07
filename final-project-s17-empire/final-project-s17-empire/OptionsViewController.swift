//
//  OptionsViewController.swift
//  final-project-s17-empire
//
//  Created by Charu Mishra on 4/26/17.
//  Copyright © 2017 Charu Mishra. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateLabel.text = dateFormat.string(for: CalView.labelDate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
