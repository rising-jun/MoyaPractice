//
//  BoardingViewController.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/08/30.
//

import Foundation
import RxSwift

class BoardingViewController: BaseViewController{
    
    private let disposeBag = DisposeBag()
    lazy var v = BoardingView(frame: view.frame)
    private var ivArray: [UIImageView] = []
    private var imageArray: [UIImage] = [UIImage(named: "stitch1")!, UIImage(named: "stitch2")!, UIImage(named: "stitch3")!]
    private var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hellow boarding viewc")
        //setupUI()

        
    }
    private let viewModel = BoardingViewModel()
    
    lazy var input = BoardingViewModel.Input(viewDidLoad: self.rx.viewDidLoad.map{_ in}.asObservable(),
                                         action: Observable.merge(v.nextBtn.rx
                                                                    .tapGesture()
                                                                    .skip(1)
                                                                    .map{_ in
                                                                        if self.currentPage == self.v.pageControl.numberOfPages - 1{
                                                                            return BoardAction.skipBtn
                                                                        }
                                                                        return BoardAction.nextBtn},
                                                                  v.skipBtn.rx
                                                                    .tap
                                                                    .map{_ in return BoardAction.skipBtn}))
    
    lazy var output = viewModel.transform(input: input)
    override func bindViewModel() {
     
        output.viewStateUpdate?.drive{ [weak self] state in
            guard let self = self else { return }
            switch state{
            case .viewDidLoad:
                self.setupUI()
            case .viewWillAppear:
                break
            case .viewDidAppear:
                break
            case .none:
                break
            }
        }.disposed(by: disposeBag)
        
        output.todoLogic?.drive{ [weak self] logic in
            guard let self = self else {return }
            switch logic{
            case .nextBoard:
                self.currentPage += 1
                self.v.pageControl.currentPage = self.currentPage
                self.v.scrollView.contentOffset.x += self.v.scrollView.frame.maxX
                break
            case .presentLoginView:
                self.presentSignView()
                break
            case .none:
                break
            }
            
        }.disposed(by: disposeBag)
    }
    
}

extension BoardingViewController{
    
    private func setupUI(){
        view = v
        
        v.scrollView.delegate = self
        
        for i in 0 ..< 3 { // Generate different labels for each page.
            let view = v.scrollView
            view.frame = v.scrollView.bounds
            ivArray.append(UIImageView())
            v.scrollView.addSubview(ivArray[i])
            ivArray[i].image = imageArray[i]
            ivArray[i].contentMode = .scaleAspectFit
            ivArray[i].snp.makeConstraints { make in
                make.width.equalTo(v.scrollView)
                make.height.equalTo(v.scrollView)
                if i == 0{
                    make.leading.equalTo(v.scrollView.snp.leading)
                }else{
                    make.leading.equalTo(ivArray[i - 1].snp.trailing)
                }
            }
        }
    }
    
    private func presentSignView(){
        let signVC = SignViewController()
        signVC.modalPresentationStyle = .fullScreen
        present(signVC, animated: true, completion: nil)
    }
}

extension BoardingViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // When the number of scrolls is one page worth.
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 { // Switch the location of the page.
            v.pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
            self.currentPage = v.pageControl.currentPage
        }
    }
}
