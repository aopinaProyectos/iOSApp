//
//  TutorialViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/1/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleApp: UILabel!
    
    //var slides = [];
    var textSlide1 = ""
    var textSlide2 = ""
    var textSlide3 = ""
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        getIntro()
        self.view.backgroundColor = kColorTuBackground
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = kColorPaSelect
        view.bringSubviewToFront(pageControl)
        showAlert()
    }
    
    
    func setupSlideScrollView() {
        let slide1:Slide1 = Bundle.main.loadNibNamed("Slide1", owner: self, options: nil)?.first as! Slide1
        let slide2:Slide1 = Bundle.main.loadNibNamed("Slide1", owner: self, options: nil)?.first as! Slide1
        let slide3:Slide1 = Bundle.main.loadNibNamed("Slide1", owner: self, options: nil)?.first as! Slide1
        
        //Config Button and Label of Slides
        slide1.button.setTitle(NSLocalizedString("ENTER", comment: "Button"), for: .normal)
        slide2.button.setTitle(NSLocalizedString("ENTER", comment: "Button"), for: .normal)
        slide3.button.setTitle(NSLocalizedString("ENTER", comment: "Button"), for: .normal)
        
        slide1.image.image = UIImage(named: "TutorialMap")
        slide2.image.image = UIImage(named: "TutorialStore")
        slide3.image.image = UIImage(named: "TutorialTime")
        
        slide1.label1.text = self.textSlide1
        slide2.label1.text = self.textSlide2
        slide3.label1.text = self.textSlide3
        
        slide1.setupView(height: self.scrollView.frame.height)
        slide2.setupView(height: self.scrollView.frame.height)
        slide3.setupView(height: self.scrollView.frame.height)
        
        slide1.button.backgroundColor = kColorButtonActive
        slide2.button.backgroundColor = kColorButtonActive
        slide3.button.backgroundColor = kColorButtonActive
        
        slide1.button.addTarget(self, action: #selector(buttonFinish(_:)), for: .touchUpInside)
        slide2.button.addTarget(self, action: #selector(buttonFinish(_:)), for: .touchUpInside)
        slide3.button.addTarget(self, action: #selector(buttonFinish(_:)), for: .touchUpInside)
        //slide1 as Slide1
        //slide1.setupSlide()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: /*self.view.frame.height*/ self.scrollView.frame.height)
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(3), height: 1.0)
        scrollView.isPagingEnabled = true
        
        slide1.frame = CGRect(x: view.frame.width * CGFloat(0), y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
        slide2.frame = CGRect(x: view.frame.width * CGFloat(1), y: 0, width: view.frame.width, height: self.scrollView.frame.height)
        slide3.frame = CGRect(x: view.frame.width * CGFloat(2), y: 0, width: view.frame.width, height: self.scrollView.frame.height)
        
        scrollView.addSubview(slide1)
        scrollView.addSubview(slide2)
        scrollView.addSubview(slide3)
        
        if AppInfo().screenHeigth < 660 {
            titleApp.font = titleApp.font.withSize(ksFontIpSETuTitle)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func buttonNextTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.scrollView.contentOffset.x += self.view.bounds.width
        }, completion: nil)
    }
    
    func buttonFinishTapped(){
        print("Termino el tutorial")
        AppInfo().isTutorialShowed = true
        UIStoryboard.loadLogin()
    }
    
    func showAlert() {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "TutorialShowViewController") as! TutorialShowViewController
        
        self.view.addSubview(customAlert.view)
        
        customAlert.handlerCloseView = {
            customAlert.view.removeFromSuperview()
        }
    }
    
    func getIntro() {
        APIVirtualLines.getInfoTutorial().debug("APIVirtualLines.GetTutorial").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.textSlide1 = dataResponse.intro![0].text
            self.textSlide2 = dataResponse.intro![1].text
            self.textSlide3 = dataResponse.intro![2].text
            self.setupSlideScrollView()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.getIntro()
            case CatalogError.ErrorGeneral(let response):
                print(response)
                //self.showAlertError(id: 2, text: response.message)
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    // Funciones de Botones
    @IBAction func buttonNext(_ sender:UIButton!) {
        buttonNextTapped()
    }
    
    @IBAction func buttonFinish(_ sender:UIButton!) {
        buttonFinishTapped()
    }
}
