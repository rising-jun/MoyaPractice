//
//  RoomViewController.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/07.
//

import Foundation
import RxSwift

class RoomViewController: BaseViewController{
    
    lazy var v = RoomView(frame: view.frame)
    var profileInfo: ProfileInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = v
    }
    
}
