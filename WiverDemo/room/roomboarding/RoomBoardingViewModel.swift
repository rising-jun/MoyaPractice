//
//  RoomBoardingViewModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/07.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RoomBoardingViewModel: ViewModelType{
    
    private let disposeBag = DisposeBag()
    private let textArray = ["you always be my","day1"]
    private var textIndex = 0
    
    func transform(input: Input) -> Output {
        let viewState = BehaviorRelay(value: ViewLifeState.none)
        let todoAction = BehaviorRelay(value: RoomBoardLogic.none)
        
        input.viewDidLoad?.bind(onNext: { _ in
            viewState.accept(.viewDidLoad)
            
        }).disposed(by: disposeBag)
        
        input.action?.bind(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action{
            case .tapView:
                todoAction.accept(.nextText(self.textArray[self.textIndex]))
                self.textIndex += 1
                break
            case .tapNft:
                todoAction.accept(.presentList)
                break
            case .none: break
            }
        })
        
        return Output(viewStateUpdate: viewState.asDriver(),
                      logic: todoAction.asDriver())
    }
    
    struct Input{
        var viewDidLoad: Observable<Void>?
        var action: Observable<RoomBoardAction>?
    }
    
    struct Output{
        var viewStateUpdate: Driver<ViewLifeState>?
        var logic: Driver<RoomBoardLogic>?
    }
    
}
