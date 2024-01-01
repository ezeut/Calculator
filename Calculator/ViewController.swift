//
//  ViewController.swift
//  Calculator
//
//  Created by 이지은 on 1/1/24.
//

import UIKit

// UIKit은 파일이 아닌 module(module: class를 여러개 묶어 그룹으로 만듦)
// UIKit: Button, TextField 같은 모든 UI를 가지고 있음
// View-UIKit, Model-Foundation사용 (Foundation: Core Service(네트워킹, 데이터베이싱 작업))

class ViewController: UIViewController {
    // 모든 MVC의 Controller는 UIViewController를 상속받아야 함, Swift는 한 개의 class만 상속받을 수 있다.
    // property와 method들을 넣어주자! property: 인스턴스 변수

    @IBOutlet weak var display: UILabel!
    
    var isTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isTyping {
            let textInDisplay = display.text!
            display.text = textInDisplay + digit
        } else {
            display.text = digit
        }
        isTyping = true
    }
    
    
    
}

