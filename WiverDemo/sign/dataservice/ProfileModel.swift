//
//  ProfileModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/06.
//

import Foundation
import Moya
import RxSwift

class ProfileModel{
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let profileProvider = RemoteRepository<ProfileAPI>()
    public var profilePublish: PublishSubject<SignVaildCheck>!
    public var availCheckPublish: PublishSubject<NameAvailable>!
    
    func fetchProfile(){
        print("fetch profile!!")
        profileProvider.authRx.request(.getProfile)
            .retry(2)
            .filterSuccessfulStatusCodes()
            .map(ProfileInfo.self)
            .subscribe { [weak self] profile in
                print("get profile in model \(profile)")
                self?.profilePublish.onNext(.existing(profile))
            } onError: { [weak self] error in
                self?.profilePublish.onNext(.firstUser)
            }.disposed(by: disposeBag)
    }
    
    func makeProfile(updateInfo: UserUpdateInfo){
        profileProvider.authRx.request(.setProfile(updateUserRequest: updateInfo))
            .retry(2)
            .filterSuccessfulStatusCodes()
            .subscribe { response in
                print("checking just success \(String.init(data: response.data, encoding: .utf8))")
        } onError: { error in
            print("makeProfile error \(error)")
        }.disposed(by: disposeBag)

    }
    
    func checkName(name: String){
        profileProvider.authRx.request(.nicknameCheck(nickname: name))
            .retry(2)
            .filterSuccessfulStatusCodes()
            .map(NameCheckInfo.self)
            .subscribe { [weak self] nameCheck in
                guard let self = self else { return }
                if nameCheck.available!{
                    self.availCheckPublish.onNext(.available)
                }else{
                    self.availCheckPublish.onNext(.unavailable)
                }
        } onError: { error in
            print("error checkNickName \(error)")
        }.disposed(by: disposeBag)
    }
    
    
}
