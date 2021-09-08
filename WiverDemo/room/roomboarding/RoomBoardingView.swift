//
//  RoomBoardingView.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/07.
//

import Foundation
import UIKit
import SnapKit

class RoomBoardingView: BaseView{
    
    lazy var imageView = UIImageView()
    lazy var nftView = UIImageView()
    lazy var noticeText = UILabel()
    
    override func setup() {
        super.setup()
        
        addSubViews(imageView, nftView, noticeText)
        
        imageView.image = UIImage(named: "stitch1")
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(self)
            make.center.equalTo(self)
        }
        
        nftView.backgroundColor = .blue
        nftView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-10)
            make.height.equalTo(200)
            make.width.equalTo(150)
        }
        
        noticeText.text = "hello\n이곳은 당신의 공간입니다."
        noticeText.backgroundColor = .orange
        noticeText.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-80)
            make.height.equalTo(100)
            make.left.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
        }
        
    }
    
}
