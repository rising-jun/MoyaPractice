//
//  RoomView.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/07.
//

import Foundation
import SnapKit

class RoomView: BaseView{
    
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
        
        noticeText.backgroundColor = .yellow
        noticeText.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-30)
            make.height.equalTo(150)
            make.left.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
        }
        
        
        
    }
    
}
