//
//  SettingMenuViewController.swift
//  Project Group 7
//
//  Created by Johnny Sun on 10/9/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import UIKit

class SettingMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var SettingMenuLabel: UILabel!
    
    @IBOutlet weak var VisualButton: UIButton!
    @IBOutlet weak var ProfileButton: UIButton!
    @IBOutlet weak var MusicButton: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
