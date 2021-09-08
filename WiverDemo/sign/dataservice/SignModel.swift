//
//  SignModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/02.
//

import Foundation
import Moya
import RxSwift

class SignModel{
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let accountProvider = RemoteRepository<AccountAPI>()
    //private let profileProvider = RemoteRepository<ProfileAPI>()
    
    var accountPublish: PublishSubject<UserInfo>!
    var profilePublish: PublishSubject<SignVaildCheck>!
    
    func exchangeToken(provider: PROVIDER, _ tokenExchangeRequest: TokenExchangeRequest){
        accountProvider.rx
            .request(.tokenExchange(provider: provider.rawValue,request: tokenExchangeRequest))
            .retry(2)
            .filterSuccessfulStatusCodes()
            .map(OAuthInfo.self)
            .asObservable()
            .subscribe(onNext: { auth in
                UserDefaults.standard.setValue(auth.accessToken, forKey: "accessToken")
                UserDefaults.standard.setValue(auth.refreshToken, forKey: "refreshToken")
            }, onError: { error in
                print(error)
            }, onCompleted: {
                self.getAccount()
                //self.fetchProfile()
            }).disposed(by: disposeBag)
    }
    
    func getAccount(){
        accountProvider.authRx.request(.getAccount).retry(2).filterSuccessfulStatusCodes()
            .map(UserInfo.self)
            .subscribe { [weak self] userInfo in
                self?.accountPublish.onNext(userInfo)
                
        } onError: { error in
            print("getAccountError \(error)")
        }.disposed(by: disposeBag)
    }
    
    
//    func fetchProfile(){
//        profileProvider.authRx.request(.getProfile)
//            .retry(2)
//            .filterSuccessfulStatusCodes()
//            .map(ProfileInfo.self)
//            .subscribe { [weak self] profile in
//                self?.profilePublish.onNext(.existing(profile))
//            } onError: { [weak self] error in
//                self?.profilePublish.onNext(.firstUser)
//            }.disposed(by: disposeBag)
//
//    }
    
    
    
    
}
