//
//  SignViewController.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/08/30.
//

import Foundation
import RxSwift
import RxGesture

class SignViewController: BaseViewController{
    
    lazy var v = SignView(frame: view.frame)
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private let viewModel = SignViewModel()
    lazy var input = SignViewModel.Input(viewDidLoad: self.rx.viewDidLoad.map{_ in}.asObservable(),
                                         action: Observable.merge(v.googleBtn.rx
                                                                    .tapGesture()
                                                                    .skip(1)
                                                                    .map{_ in return SignAction.signGoogleBtn},
                                                                  v.appleBtn.rx
                                                                    .tap
                                                                    .map{_ in return SignAction.signAppleBtn}))
    
    lazy var output = viewModel.transform(input: input)
    
    override func bindViewModel() {
        output.viewStateUpdate?.drive{ [weak self] state in
            guard let self = self else { return }
            
            
            
            switch state{
            
            case .viewDidLoad:
                self.setupView()
                UIApplication.shared.windows.first?.rootViewController = self
                break
            case .viewWillAppear:
                break
            case .viewDidAppear:
                break
            case .none:
                break
            }
        }.disposed(by: disposeBag)
        
        output.userToken?.drive{ [weak self] token in
            print("viewcontroller token \(token)")
            
        }.disposed(by: disposeBag)
        
        output.presentView?.drive{ [weak self] present in
            switch present{
            
            case .tokenData(token: let token):
                break
            case .presentSignUpView:
                self?.presentSignUp()
            case .presentRoomView(let user):
                print("user already \(user)")
                self?.presentRoomBoarding(profileInfo: user)
            case .none:
                break
            }
            
        }.disposed(by: disposeBag)
    }
    
}


extension SignViewController{
    private func setupView(){
        view = v
    }
    
    private func presentSignUp(){
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
    
    private func presentRoomBoarding(profileInfo: ProfileInfo){
        let roomBoardingVC = RoomBoardingViewController()
        roomBoardingVC.modalPresentationStyle = .fullScreen
        //roomBoardingVC.profileInfo = profileInfo
        present(roomBoardingVC, animated: true, completion: nil)
        
    }
    
}
