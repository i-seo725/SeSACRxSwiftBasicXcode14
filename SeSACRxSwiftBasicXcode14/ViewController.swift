//
//  ViewController.swift
//  SeSACRxSwiftBasicXcode14
//
//  Created by jack on 2023/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var changeButton: UIButton!
    var nickname = "고래밥"
    
    @IBOutlet var timerLabel: UILabel!
    var timer: Timer?
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = nickname
        changeButton.addTarget(self, action: #selector(changeButtonClicked), for: .touchUpInside)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
        timer?.invalidate() //타이머 멈추기
    }
    
    deinit {
        print(#function)
    }
    
    @objc func changeButtonClicked() {
        nickname = "이름 변경 \(Int.random(in: 1...100))"
        nameLabel.text = nickname
    }
    
    @objc func startTimer() {
        print(#function)
        count += 1
        timerLabel.text = "\(count)"
    }

}

