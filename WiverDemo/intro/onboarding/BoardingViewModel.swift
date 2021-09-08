//
//  BoardingVierModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/01.
//

import Foundation
import RxSwift
import RxCocoa

class BoardingViewModel: ViewModelType{
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let viewState = BehaviorRelay(value: ViewLifeState.none)
        let todoAction = BehaviorRelay(value: BoardLogic.none)
        
        input.viewDidLoad?.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            viewState.accept(.viewDidLoad)
        }).disposed(by: disposeBag)
        
        input.action?.bind(onNext: { action in
            switch action{
            case .skipBtn:
                todoAction.accept(.presentLoginView)
                UserDefaults.standard.setValue(true, forKey: "firstEnter")
            case .nextBtn:
                todoAction.accept(.nextBoard)
                
            }
        }).disposed(by: disposeBag)
        
        return Output(viewStateUpdate: viewState.asDriver(),
                      todoLogic: todoAction.asDriver())
    }
    

    struct Input{
        var viewDidLoad: Observable<Void>?
        var action: Observable<BoardAction>?
        
    }
    
    struct Output{
        var viewStateUpdate: Driver<ViewLifeState>?
        var todoLogic: Driver<BoardLogic>?
    }
    
}
