//
//  ViewController.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/08/30.
//

import UIKit
import RxViewController
import RxSwift

class IntroViewController: BaseViewController {

    lazy var v = IntroView(frame: view.frame)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    private let viewModel = IntroViewModel()
    lazy var input = IntroViewModel.Input(viewDidLoad: self.rx.viewDidLoad.map{_ in}.asObservable(),
                                          viewDidAppear: self.rx.viewWillAppear.map{_ in}.asObservable())
    lazy var output = viewModel.transform(input: input)
    
    override func bindViewModel() {
        output.viewStateUpdate?.drive{ [weak self] state in
            guard let self = self else { return }
            switch state{
            case .viewDidLoad:
                print("hello")
                self.setUpView()
                
            case .viewWillAppear:
                break
            case.viewDidAppear:
                
                break
            case .none:
                break
            }
        }.disposed(by: disposeBag)
        
        output.todoLogic?.drive{ [weak self] logic in
            guard let self = self else { return }
            switch logic{
            case .setupView:
                self.setUpView()
                break
            case .presentSignView:
                self.startTimer(logic: .presentSignView)
                break
            case .presentBoardingView:
                self.startTimer(logic: .presentBoardingView)
                break
            case .none:
                break
                
            }
        }.disposed(by: disposeBag)
        
    }

}


extension IntroViewController{

    private func setUpView(){
        view = v
    }
    
    private func startTimer(logic: IntroLogic){
        Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
            .take(1)
            .bind {[weak self] _ in
                guard let self = self else { return }
                if logic == .presentBoardingView{
                    self.presentBoardingView()
                }else{
                    self.presentSignView()
                }
        }.disposed(by: disposeBag)
    }
    
    private func presentSignView(){
        let signVC = SignViewController()
        signVC.modalPresentationStyle = .fullScreen
        present(signVC, animated: true, completion: nil)
    }
    
    
    private func presentBoardingView(){
        let boardingVC = BoardingViewController()
        boardingVC.modalPresentationStyle = .fullScreen
        present(boardingVC, animated: true, completion: nil)
    }
    
    
}
