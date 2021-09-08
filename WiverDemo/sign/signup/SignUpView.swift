//
//  SignUpView.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/03.
//

import Foundation
import SnapKit

class SignUpView: BaseView{
    
    lazy var profileIV = UIImageView()
    lazy var nameTF = UITextField()
    lazy var warningText = UITextView()
    lazy var createBtn = UIButton()
    
    override func setup() {
        super.setup()
        backgroundColor = UIColor(red: 0.106, green: 0.118, blue: 0.22, alpha: 1)
        addSubViews(profileIV, nameTF, warningText, createBtn)
        
        
        profileIV.backgroundColor = .blue
        profileIV.contentMode = .scaleAspectFill
        profileIV.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(200)
        }
        
        nameTF.backgroundColor = .black
        nameTF.snp.makeConstraints { make in
            make.top.equalTo(profileIV.snp.bottom).offset(80)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerX.equalTo(profileIV)
        }
        
        nameTF.layer.addBorder(edge: .bottom, color: .white, thickness: 20)
        
        warningText.isHidden = true
        warningText.textColor = .red
        warningText.backgroundColor = .white
        warningText.text = "*중복된 닉네임입니다.\n*특수문자는 사용할 수 없습니다.\n*10자 이내의 닉네임만 사용할 수 있습니다."
        warningText.snp.makeConstraints { make in
            make.top.equalTo(nameTF.snp.bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(nameTF)
        }
        
        createBtn.backgroundColor = .green
        createBtn.snp.makeConstraints { make in
            make.top.equalTo(warningText.snp.bottom).offset(30)
            make.centerX.equalTo(self)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        
    }
}
