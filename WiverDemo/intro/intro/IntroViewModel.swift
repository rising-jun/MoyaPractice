//
//  IntroViewModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/08/30.
//

import Foundation
import RxSwift
import RxCocoa

final class IntroViewModel: ViewModelType{
   
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let viewState = BehaviorRelay(value: ViewLifeState.none)
        let todoAction = BehaviorRelay(value: IntroLogic.none)
        
        input.viewDidLoad?.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            viewState.accept(.viewDidLoad)
            print("first enter \(UserDefaults.standard.bool(forKey: "firstEnter"))")
            todoAction.accept(self.checkFirstUser())
        }).disposed(by: disposeBag)
        
        input.viewDidAppear?.bind(onNext: { _ in
            viewState.accept(.viewWillAppear)
        }).disposed(by: disposeBag)
        
        return Output(viewStateUpdate: viewState.asDriver(),
                      todoLogic: todoAction.asDriver())
    }
    

    struct Input{
        var viewDidLoad: Observable<Void>?
        var viewDidAppear: Observable<Void>?
        
    }
    
    struct Output{
        var viewStateUpdate: Driver<ViewLifeState>?
        var todoLogic: Driver<IntroLogic>?
    }
    
}
extension IntroViewModel{
    
    private func checkFirstUser() -> IntroLogic{
        let id = KeychainManager.sharedInstance.getDeviceIdentifierFromKeychain()
        UserDefaults.standard.set(id, forKey: Key.DEVICE_UUID_KEY)
        
        if !UserDefaults.standard.bool(forKey: "firstEnter"){
            return .presentBoardingView
        }
        print(UserDefaults.standard.bool(forKey: "firstEnter"))
        return .presentSignView
    }
    
    
    
    
}
