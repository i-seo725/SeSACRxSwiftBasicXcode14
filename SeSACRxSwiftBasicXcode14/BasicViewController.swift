//
//  BasicViewController.swift
//  SeSACRxSwiftBasicXcode14
//
//  Created by 이은서 on 2023/10/29.
//

import UIKit
import RxSwift
import RxCocoa

class BasicViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var textField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicTableView()
//        basicButton()
        basicValidation()
        shareButton()
    }
    
    func basicTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
    
        tableView.rx.modelSelected(String.self) //배열이 String이어서 맞춰줌
            .map { data in
                "\(data)를 클릭했어요"
            }
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
    }
    func basicButton() {
        
        //error/complete를 지원하지만 쓰지 않음 - UI에선 필요 없어서
        //메인 쓰레드가 아닌 백그라운드 쓰레드에서 동작할 수도 있음
        button.rx.tap
            .observe(on: MainScheduler.instance)    //메인 쓰레드에서 동작하게 만들기
            .subscribe { _ in
                print("클릭되었습니다")
                //rx가 아닌 일반적인 코드 적는 공간이라 label.rx 안씀
                self.textLabel.text = "클릭클릭"
                self.textField.text = "클릭되었습니다"
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag)
        
        //좀 더 UI에 적합, error/complete 지원 안됨, main thread에서 동작 보장
        button.rx.tap
            .bind { _ in
                print("클릭되었습니다")
                self.textLabel.text = "클릭클릭"
                self.textField.text = "클릭되었습니다"
            }
            .disposed(by: disposeBag)
        
        
        button.rx.tap
            .map { "클릭되었습니다" }
            .bind(to: textLabel.rx.text, textField.rx.text)
            .disposed(by: disposeBag)
    }
    func basicValidation() {
        
        textField.rx.text.orEmpty   //orEmpty: guard let, if let처럼 옵셔널 해제해줌
            .map { $0.count > 4 }
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
    func shareButton() {
        
        //스트림이 3번 돌아서 3개가 다른 값이 나오게 됨
        //같은 결과를 사용하고 싶으면 bind(to: @@) @@여기에 , 쓰고 다 써줘야함
        
        //bind: 메인 쓰레드에서 동작, error X, completed X, UI에 최적화
        //drive: bind 특징 + 스트림 공유(.share() 가 구현되어있음)
        let sample = button.rx.tap
            .map { "안녕하세요 \(Int.random(in: 1...100))"}
            .share()    //스트림 공유
            
        sample
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
        
        sample
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        sample
            .bind(to: button.rx.title())
            .disposed(by: disposeBag)
    }
}
