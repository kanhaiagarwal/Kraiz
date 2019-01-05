//
//  VibeSentViewController.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 25/11/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import UIKit

class VibeSentViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
    }

    @IBAction func donePressed(_ sender: UIButton) {
        let presentingVC = self.presentingViewController
        self.dismiss(animated: true) {
            presentingVC?.dismiss(animated: true, completion: nil)
        }
    }
}
