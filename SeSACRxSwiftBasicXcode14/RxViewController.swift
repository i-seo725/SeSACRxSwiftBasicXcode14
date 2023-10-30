//
//  RxViewController.swift
//  SeSACRxSwiftBasicXcode14
//
//  Created by jack on 2023/10/23.
//

import UIKit
import RxSwift
import RxCocoa

class RxViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var changeButton: UIButton!
    var nickname = BehaviorSubject(value: "포카칩") //Observable.just("고래밥")
    
    @IBOutlet var timerLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //에러 안 받고 컴플리트 필요 없을 때(UI적인 부분)
        nickname
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
//        nickname    //Observable
//            .subscribe { value in
//                print(value)
//                self.nameLabel.text = value
//            } onError: { value in
//                print(value)
//            } onCompleted: {
//                print("Nickname - onCompleted")
//            } onDisposed: {
//                print("nickname - Disposed")
//            }
//            .disposed(by: disposeBag)
        
        
 
        changeButton.rx.tap
            .subscribe { value in
                print("버튼 클릭 \(value)")
                self.nickname.onNext("버튼 클릭 \(Int.random(in: 1...100))")
            } onError: { error in
                print("changeButton - onError")
            } onCompleted: {
                print("changeButton - onCompleted")
            } onDisposed: {
                print("changeButton - Disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("value")
                self.timerLabel.text = "\(value)"
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)   //수동으로 처리해야 할 때도 있음
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.disposeBag = DisposeBag()
        }
    }
}
