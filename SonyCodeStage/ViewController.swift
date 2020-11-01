//
//  ViewController.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 31/10/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let vc = HealthViewController.loadFromNib()
            self.present(vc, animated: false, completion: nil)
        }
    }


}

