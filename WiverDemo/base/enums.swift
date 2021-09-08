//
//  enums.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/08/30.
//

import Foundation

enum PROVIDER: String {
    case google
    case apple
    case kakao
    case naver
}

enum ViewLifeState{
    case viewDidLoad
    case viewWillAppear
    case viewDidAppear
    case none
}

enum IntroLogic{
    case setupView
    case presentSignView
    case presentBoardingView
    case none
}

enum SignAction{
    case signGoogleBtn
    case signAppleBtn
    case none
}

enum SignLogic{
    case tokenData(token: String)
    case presentSignUpView
    case presentRoomView(ProfileInfo)
    case none
}

enum BoardAction{
    case skipBtn
    case nextBtn
}

enum BoardLogic{
    case nextBoard
    case presentLoginView
    case none
}

enum SignVaildCheck{
    case firstUser
    case existing(ProfileInfo)
}

enum SignUpLogic{
    case presentImagePickerView
    case checkNickName
    case endEditing
    case raiseView
    case originalView
    case createAccount
    case none
}

enum SignUpAction{
    case imageTap
    case changedName(String)
    case tapView
    case keyboardShow
    case keyboardHide
    case createBtn(image: Data, name: String)
    case none
}

enum NameAvailable{
    case available
    case unavailable
}


enum RoomBoardAction{
    case tapView
    case tapNft
    case none
}

enum RoomBoardLogic{
    case presentList
    case nextText(String)
    case none
}
