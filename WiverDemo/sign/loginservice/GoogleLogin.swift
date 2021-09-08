//
//  GoogleLogin.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/08/30.
//

import Foundation
import Firebase
import GoogleSignIn
import FirebaseAuth
import RxSwift

class GoogleLogin{
    
    var tokenPublish: PublishSubject<String>!
    var authPublish: PublishSubject<OAuthInfo>!
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let signModel = SignModel()
    
    func getTokenData(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        //
        GIDSignIn.sharedInstance.signIn(with: config, presenting: UIApplication.shared.windows.first!.rootViewController!) { [unowned self] user, error in
            if let error = error {
                // ...
                print("first error! \(error)")
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            tokenPublish.onNext(authentication.accessToken)
            
            
        }
        
        
    }
    
}
