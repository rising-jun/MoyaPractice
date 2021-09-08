//
//  SignUpViewModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/06.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType{
    
    private let disposeBag = DisposeBag()
    
    private let profileModel = ProfileModel()
    private let uploadModel = UploadModel()
    
    private let availCheckPublish = PublishSubject<NameAvailable>()
    private let imageURLPublish = PublishSubject<String>()
    
    private var userInfo = UserUpdateInfo()
    
    func transform(input: Input) -> Output {
        
        let viewState = BehaviorRelay(value: ViewLifeState.none)
        let todoAction = BehaviorRelay(value: SignUpLogic.none)
        
        input.viewDidLoad?.bind(onNext: { _ in
            viewState.accept(.viewDidLoad)
        }).disposed(by: disposeBag)
        
        input.action?.bind(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action{
            case .imageTap:
                todoAction.accept(.presentImagePickerView)
                break
            case .changedName(let name):
                self.profileModel.availCheckPublish = self.availCheckPublish
                self.profileModel.checkName(name: name)
                break
            case .tapView:
                todoAction.accept(.endEditing)
                break
            case .keyboardShow:
                todoAction.accept(.raiseView)
                break
            case .keyboardHide:
                todoAction.accept(.originalView)
                break
            case .createBtn(let image, let name):
                self.userInfo.nickname = name
                //self.uploadImage(image: image)
                self.makeProfile()
                break
            case .none:

                break
            
            }
            
        }).disposed(by: disposeBag)
        
        return Output(viewStateUpdate: viewState.asDriver(),
                      availableCheck: availCheckPublish.asDriver(onErrorJustReturn: .unavailable),
                      todoLogic: todoAction.asDriver())
    }
    

    struct Input{
        var viewDidLoad: Observable<Void>?
        var action: Observable<SignUpAction>?
        
    }
    
    struct Output{
        var viewStateUpdate: Driver<ViewLifeState>?
        var availableCheck: Driver<NameAvailable>?
        var todoLogic: Driver<SignUpLogic>?
    }
}

extension SignUpViewModel{
    func uploadImage(image: Data){
        self.uploadModel.imageURLPublish = self.imageURLPublish
        self.uploadModel.uploadImage(image: image)
        self.imageURLPublish.bind { [weak self] imageURL in
            print("get image url in viewmodel \(imageURL)")
            self?.userInfo.imageUrl = imageURL
        }
    }
    
    func makeProfile(){
        self.userInfo.imageUrl = "https://post-phinf.pstatic.net/MjAyMTA1MDVfMTA4/MDAxNjIwMjI0OTQxNzM4.7UYCmlX4sUGN4irz_1Z_g1W-HTSWrLAlcdzBdwxgXzsg.r5ZLpFeBxcjowe1Xqiz08xyzJ2eILXIqMa96460PS_Ig.JPEG/6.jpg?type=w1200"
        print("userinfo \(userInfo)")
        profileModel.makeProfile(updateInfo: self.userInfo)
    }
}
