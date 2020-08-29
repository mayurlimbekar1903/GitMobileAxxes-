//
//  DetailsViewController.swift
//  MobileAxxess_Mayur_Limbekar
//
//  Created by Admin on 20/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SnapKit

class DetailsViewController: UIViewController {
    let scrollView = UIScrollView()
    let mainStack = UIStackView()
    let imageBGView = UIView()
    let imageVC = UIImageView()
    
    let id = UILabel()
    let type = UILabel()
    let date = UILabel()
    let data = UILabel()
    
    var selecteModel = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    //    Mark:- Design setup
    private func setupView() {
        self.view.backgroundColor = .white
        
       
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            
        }

        self.scrollView.isDirectionalLockEnabled = true
        mainStack.insertArrangedSubview(imageBGView, at: 0)
        mainStack.insertArrangedSubview(id, at: 1)
        mainStack.insertArrangedSubview(type, at: 2)
        mainStack.insertArrangedSubview(date, at: 3)
        mainStack.insertArrangedSubview(data, at: 4)
        
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        scrollView.addSubview(mainStack)
        mainStack.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView.snp.left)
            make.right.equalTo(scrollView.snp.right)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
        
        imageBGView.snp.makeConstraints { (make) in
            make.height.equalTo(100)
        }
        
        imageBGView.addSubview(imageVC)
        imageVC.snp.makeConstraints { (make) in
            make.center.equalTo(imageBGView)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        
        id.textAlignment = .center
        id.snp.makeConstraints { (make) in
            make.height.equalTo(40)
        }
        
        type.textAlignment = .center
        type.snp.makeConstraints { (make) in
            make.height.equalTo(40)
        }
        
        date.textAlignment = .center
        date.snp.makeConstraints { (make) in
            make.height.equalTo(40)
        }
        
        data.numberOfLines = 0
//        data.adjustsFontSizeToFitWidth = true
        
        if selecteModel.type == "text" || selecteModel.type == "other"{
            mainStack.arrangedSubviews[0].isHidden = true
        } else if selecteModel.type == "image" {
            mainStack.arrangedSubviews[0].isHidden = false
            let imageUrl = URL(string: selecteModel.data ?? "")
                imageVC.kf.indicatorType = .activity
                imageVC.kf.setImage(with: imageUrl,placeholder: UIImage(named: "noimageava"))
        }
        
        id.text = "ID: \(selecteModel.id)"
        data.text = "Data: \(selecteModel.data ?? "")"
        type.text = "Type: \(selecteModel.type ?? "")"
        date.text = "Date: \(selecteModel.date ?? "")"
        
    }
}

