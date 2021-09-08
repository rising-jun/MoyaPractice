//
//  UploadModel.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/07.
//

import Foundation
import Moya
import RxSwift

class UploadModel{
 
    public var imageURLPublish: PublishSubject<String>!
    private let uploadProvider = RemoteRepository<UploadAPI>()
    private let disposeBag = DisposeBag()
    
    public func uploadImage(image: Data){
        uploadProvider.authRx.request(.upload(image: image)).map(UploadResponse.self).subscribe { [weak self] uploadResponse in
            print("uploadResponse \(uploadResponse.url)")
            self?.imageURLPublish.onNext(uploadResponse.url!)
        } onError: { error in
            print("error to uploadImage \(error)")
        }.disposed(by: disposeBag)

    }
    
}
