//
//  SignView.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/08/30.
//

import Foundation
import UIKit
import SnapKit
import GoogleSignIn

class SignView: BaseView{
    
    lazy var googleBtn = GIDSignInButton()
    lazy var appleBtn = UIButton()
    
    override func setup() {
        
        backgroundColor = .blue
        addSubViews(googleBtn, appleBtn)
        
        googleBtn.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(30)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(40)
            make.bottom.equalTo(self).offset(-200)
        }
        
        appleBtn.backgroundColor = .black
        appleBtn.snp.makeConstraints { make in
            make.top.equalTo(googleBtn.snp.bottom).offset(20)
            make.height.equalTo(googleBtn)
            make.leading.equalTo(googleBtn)
            make.trailing.equalTo(googleBtn)
        }
        
    }
    
}
