//
//  SignViewModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/08/30.
//

import Foundation
import RxSwift
import RxCocoa

class SignViewModel: ViewModelType{
    
    private let googleSign = GoogleLogin()
    private let appleSign = AppleLogin()
    
    private let disposeBag = DisposeBag()
    private var tokenPublish = PublishSubject<String>()
    private var authPublish = PublishSubject<OAuthInfo>()
    private var accountPublish = PublishSubject<UserInfo>()
    private var profilePublish = PublishSubject<SignVaildCheck>()
    private var presentViewPuiblish = PublishSubject<SignLogic>()
    
    private var signModel = SignModel()
    private var profileModel = ProfileModel()
    
    
    func transform(input: Input) -> Output {
        
        let viewState = BehaviorRelay(value: ViewLifeState.none)
        let todoAction = BehaviorRelay(value: SignLogic.none)
        
        input.viewDidLoad?.bind(onNext: { _ in
            viewState.accept(.viewDidLoad)
        }).disposed(by: disposeBag)
        
        input.action?.bind(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action{
            case .signGoogleBtn:
                self.googleSign.tokenPublish = self.tokenPublish
                self.googleSign.getTokenData()
                self.tokenExchange(provider: .google)
                break
            case .signAppleBtn:
                self.appleSign.tokenPublish = self.tokenPublish
                self.appleSign.startSignInWithAppleFlow()
                self.tokenExchange(provider: .apple)
                break
            case .none:
                break
            }
            
        }).disposed(by: disposeBag)
        
        return Output(viewStateUpdate: viewState.asDriver(),
                      userToken: authPublish.asDriver(onErrorJustReturn: OAuthInfo(refreshExpiresIn: 0.0, tokenType: "", accessToken: "", sessionState: "", scope: "", expiresIn: 0.0, refreshToken: "", notBeforePolicy: 0)),
                      presentView: presentViewPuiblish.asDriver(onErrorJustReturn: .none))
    }
    

    struct Input{
        var viewDidLoad: Observable<Void>?
        var action: Observable<SignAction>?
        
    }
    
    struct Output{
        var viewStateUpdate: Driver<ViewLifeState>?
        var userToken: Driver<OAuthInfo>?
        var presentView: Driver<SignLogic>?
    }
}
extension SignViewModel{
    
    private func tokenExchange(provider: PROVIDER){
        tokenPublish.bind {[weak self] token in
            guard let self = self else { return }
            self.signModel.exchangeToken(provider: provider, TokenExchangeRequest(token: token))
            self.signModel.accountPublish = self.accountPublish
            self.signModel.profilePublish = self.profilePublish
            self.fetchProfile()
        }.disposed(by: disposeBag)
    }
    
    private func fetchProfile(){
        self.profileModel.profilePublish = self.profilePublish
        
        accountPublish.subscribe { userInfo in
            self.profileModel.fetchProfile()
            self.presentView()
        }.disposed(by: disposeBag)
        
    }
    
    private func presentView(){
        profilePublish.bind { [weak self] validCheck in
            guard let self = self else { return }
            switch validCheck{
            case .firstUser:
                self.presentViewPuiblish.onNext(.presentSignUpView)
                break
            case .existing(let profile):
                self.presentViewPuiblish.onNext(.presentRoomView(profile))
                break
            }
        }.disposed(by: disposeBag)
    }
    
    
}
