//
//  SignUpViewController.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/03.
//

import Foundation
import RxSwift
import UIKit
import RxViewController
import RxGesture

class SignUpViewController: BaseViewController{
    
    lazy var v = SignUpView(frame: view.frame)
    private let disposeBag = DisposeBag()
    lazy var imagePickerVC = UIImagePickerController()
    private var keyboardHeight: CGFloat = 0.0
    private var isNextAble: Bool = false
    private var userUpdateInfo: UserUpdateInfo = UserUpdateInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private let viewModel = SignUpViewModel()
    lazy var input = SignUpViewModel.Input(viewDidLoad: self.rx.viewDidLoad.map{_ in}.asObservable(),
                                           action:  Observable.merge(v.profileIV.rx.tapGesture()
                                                                        .skip(1)
                                                                        .map{_ in SignUpAction.imageTap},
                                                                     v.nameTF.rx.text
                                                                        .filter{$0 != ""}
                                                                        .distinctUntilChanged()
                                                                        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                                                                        .map{SignUpAction.changedName($0!)},
                                                                     v.rx.tapGesture()
                                                                        .skip(1)
                                                                        .map{_ in SignUpAction.tapView},
                                                                     NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                                                                        .map{[weak self] notification in
                                                                            let userInfo: NSDictionary = notification.userInfo! as NSDictionary
                                                                            let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
                                                                            let keyboardRectangle = keyboardFrame.cgRectValue
                                                                            self?.keyboardHeight = keyboardRectangle.height
                                                                            return SignUpAction.keyboardShow},
                                                                     NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                                                                        .map{_ in SignUpAction.keyboardHide}.observeOn(MainScheduler.asyncInstance),
                                                                     v.createBtn.rx.tap
                                                                        .map{_ in SignUpAction.createBtn(image: (self.v.profileIV.image?.jpegData(compressionQuality: 1.0))!, name: self.v.nameTF.text!)})
    )
    
    lazy var output = viewModel.transform(input: input)
    
    override func bindViewModel() {
        
        output.viewStateUpdate?.drive{ [weak self] state in
            guard let self = self else {return}
            
            switch state{
            case .viewDidLoad:
                self.view = self.v
                self.imagePickerVC.delegate = self
                //self.registerNotification()
                break
            case .viewWillAppear:
                break
            case .viewDidAppear:
                break
            case .none:
                break
            }
            
        }.disposed(by: disposeBag)
        
        output.todoLogic?.drive{ [weak self] logic in
            guard let self = self else { return }
            switch logic{
            case .presentImagePickerView:
                self.presentImagePickerView()
                break
            case .endEditing:
                self.v.endEditing(true)
                break
            case .checkNickName:
                break
            case .raiseView:
                self.raiseView()
                break
            case .originalView:
                self.originalView()
                break
            case .createAccount:
                break
            case .none:
                break
            }
            
            
        }.disposed(by: disposeBag)
        
        output.availableCheck?.drive{ [weak self] state in
            guard let self = self else { return }
            switch state{
            case .available:
                self.changeAvailUI()
                self.userUpdateInfo.nickname = self.v.nameTF.text
                self.v.createBtn.isEnabled = true
                break
            case .unavailable:
                self.changeUnavailUI()
                self.isNextAble = false
                self.v.createBtn.isEnabled = false
                break
            }
        }.disposed(by: disposeBag)
        
    }
    
}

extension SignUpViewController{
    
    func presentImagePickerView(){
        imagePickerVC.sourceType = .photoLibrary
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func changeAvailUI(){
        v.warningText.isHidden = true
    }
    
    func changeUnavailUI(){
        v.warningText.isHidden = false
    }
    
    func raiseView(){
        print("keyboardheight \(keyboardHeight), \(self.view.frame.height - v.createBtn.frame.maxY)")
        if keyboardHeight > (self.view.frame.height - v.createBtn.frame.maxY){
            print("react")
            self.view.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height - keyboardHeight - v.createBtn.frame.maxY) - 44)
        }
    }
    
    func originalView(){
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            var i = image as! UIImage
            i = i.crop(to: CGSize(width: 300, height: 300))
            v.profileIV.image = i
            
        }
        dismiss(animated: true, completion: nil)
    }
}
