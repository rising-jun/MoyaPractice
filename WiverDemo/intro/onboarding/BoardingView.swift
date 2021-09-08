//
//  BoardingView.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/08/30.
//

import Foundation
import UIKit
import SnapKit

class BoardingView: BaseView{
    
    lazy var scrollView = UIScrollView()
    lazy var nextBtn = UIButton()
    lazy var skipBtn = UIButton()
    
    lazy var pageControl = UIPageControl()
    
    override func setup() {
        backgroundColor = .white
        
        let pageSize = 3
        
        addSubViews(scrollView, pageControl, nextBtn, skipBtn)
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: CGFloat(pageSize) * frame.maxX, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.height.width.equalTo(self)
            make.center.equalTo(self)
        }
        
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = pageSize
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .systemGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-50)
            make.width.equalTo(self)
            make.height.equalTo(30)
            make.centerX.equalTo(self)
        }
        
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.setTitleColor(.black, for: .normal)
        nextBtn.snp.makeConstraints { make in
            make.centerY.equalTo(pageControl)
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.trailing.equalTo(self).offset(-40)
        }
        
        skipBtn.setTitle("Skip", for: .normal)
        skipBtn.setTitleColor(.black, for: .normal)
        skipBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nextBtn)
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.leading.equalTo(self).offset(40)
        }
    
    }
}
