//
//  ViewController.swift
//  Calculator
//
//  Created by 이지은 on 1/1/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        print("touched \(digit) button")
    }
    
}

