//
//  TutorialSlideHostViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/10/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class TutorialSlideHostViewController: PopupAlertViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewAlert: UIView!
    
    var handlerHostSignUp: () -> () = {}
    var handlerGoToMenu: () -> () = {}
    var handlerCloseView: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        setupSlideScrollView()
    }
    
    func setupSlideScrollView() {
        let slide1:SlideHost1 = Bundle.main.loadNibNamed("SlideHost1", owner: self, options: nil)?.first as! SlideHost1
        let slide2:SlideHost1 = Bundle.main.loadNibNamed("SlideHost1", owner: self, options: nil)?.first as! SlideHost1
        let slide3:SlideHost1 = Bundle.main.loadNibNamed("SlideHost1", owner: self, options: nil)?.first as! SlideHost1
        
        slide1.titleLabel.text = "¿Quieres ser Host?"
        slide2.titleLabel.text = "Administra tus filas de espera"
        slide3.titleLabel.text = "Analiza tus tiempos de espera"
        
        slide1.image.image = UIImage(named: "Store")
        slide2.image.image = UIImage(named: "SlideHost2")
        slide3.image.image = UIImage(named: "SlideHost3")
        
        slide1.label1.text = "Obten los grandes benedificios de ser Host"
        slide2.label1.text = "No dejes esperando a tus clientes, consientelos con esta App"
        slide3.label1.text = "Averigua lo que tus clientes piensan de tu negocio"
        
        /*scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(3), height: 1.0)*/
        scrollView.frame = CGRect(x: 0, y: 0, width: viewAlert.frame.width, height: viewAlert.frame.width)
        scrollView.contentSize = CGSize(width: viewAlert.frame.width * CGFloat(3), height: 1.0)
        scrollView.isPagingEnabled = true
        
        slide1.frame = CGRect(x: viewAlert.frame.width * CGFloat(0), y: 0, width: viewAlert.frame.width, height: viewAlert.frame.height)
        slide2.frame = CGRect(x: viewAlert.frame.width * CGFloat(1), y: 0, width: viewAlert.frame.width, height: viewAlert.frame.height)
        slide3.frame = CGRect(x: viewAlert.frame.width * CGFloat(2), y: 0, width: viewAlert.frame.width, height: viewAlert.frame.height)
        
        scrollView.addSubview(slide1)
        scrollView.addSubview(slide2)
        scrollView.addSubview(slide3)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    @IBAction func goToHost(_ sender: Any) {
        self.close()
        UIView.animate(withDuration: 0.1, animations: {}, completion: { (finished : Bool) in
            if finished {
                print("finished",finished)
                self.handlerHostSignUp()
            }
        })
    }
    
    @IBAction func buttonGoToMenu(_ sender:UIButton!) {
        self.handlerGoToMenu()
    }
}
