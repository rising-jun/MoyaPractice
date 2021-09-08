//
//  RoomViewController.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/07.
//

import Foundation
import RxSwift

class RoomBoardingViewController: BaseViewController{
    
    lazy var v = RoomBoardingView(frame: view.frame)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = v
    }
    
    private let viewModel = RoomBoardingViewModel()
    lazy var input = RoomBoardingViewModel.Input(viewDidLoad: self.rx.viewDidLoad.map{_ in}.asObservable())
    lazy var output = viewModel.transform(input: input)
    
    override func bindViewModel() {
        super.bindViewModel()
        
        output.viewStateUpdate?.drive{ [weak self] state in
            guard let self = self else { return }
            switch state{
            case .viewDidLoad:
                self.view = self.v
                break
            case .viewWillAppear: break
            case .viewDidAppear: break
            case .none: break
            }
        }.disposed(by: disposeBag)
        
        output.logic?.drive{ [weak self] logic in
            guard let self = self else { return }
            switch logic{
            case .presentList:
                self.presentList()
                break
            case .nextText(let text):
                self.setIntroText(text: text)
                break
            case .none: break
            }
            
        }.disposed(by: disposeBag)
        
    }
    
}

extension RoomBoardingViewController{
    func presentList(){
        
    }
    
    func setIntroText(text: String){
        v.noticeText.text = text
    }
}
