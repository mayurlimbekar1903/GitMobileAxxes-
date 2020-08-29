//
//  ListTableViewCell.swift
//  MobileAxxess_Mayur_Limbekar
//
//  Created by Admin on 18/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ListTableViewCell: UITableViewCell {
    
    let leftView = UIView()
    let rightView  = UIView()
    let imagevw = UIImageView()
    let mainStackView = UIStackView()
    
    let rightStackView = UIStackView()
    let id = UILabel()
    let type = UILabel()
    let date = UILabel()
    let data = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(model: Model) {
        if model.type == "text" || model.type == "other"{
            mainStackView.arrangedSubviews[0].isHidden = true
        } else if model.type == "image" {
            mainStackView.arrangedSubviews[0].isHidden = false
            let imageUrl = URL(string: model.data!)
                imagevw.kf.indicatorType = .activity
                imagevw.kf.setImage(with: imageUrl,placeholder: UIImage(named: "noimageava"))
        }
        
        id.text = "ID: \(model.id)"
        data.text = "Data: \(model.data ?? "")"
        type.text = "Type: \(model.type ?? "")"
        date.text = "Date: \(model.date ?? "")"
    }
    
    private func setUpCell() {
        mainStackView.insertArrangedSubview(leftView, at: 0)
        mainStackView.insertArrangedSubview(rightView, at: 1)
        mainStackView.axis = .horizontal
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        self.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(8)
            make.top.equalTo(self).offset(8)
            //make.bottom.equalTo(self).offset(-8)
            make.trailing.equalTo(self).offset(-8)
        }
        
        leftView.addSubview(imagevw)
        imagevw.snp.makeConstraints { (make) in
            make.leading.equalTo(leftView).offset(4)
            make.trailing.equalTo(leftView).offset(-4)
            make.top.equalTo(leftView).offset(4)
            make.bottom.equalTo(leftView).offset(-4)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        
        id.textAlignment = .right
        
        let stackvc = UIStackView()
        stackvc.axis = .horizontal
        stackvc.alignment = .fill
        stackvc.distribution = .fill
        stackvc.insertArrangedSubview(type, at: 0)
        stackvc.insertArrangedSubview(id, at: 1)
        
        rightStackView.insertArrangedSubview(stackvc, at: 0)
        rightStackView.insertArrangedSubview(date, at: 1)
        rightStackView.insertArrangedSubview(data, at: 2)
        rightStackView.axis = .vertical
        rightStackView.alignment = .fill
        rightStackView.distribution = .fillEqually
        rightView.addSubview(rightStackView)
        rightStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(rightView)
            make.top.equalTo(rightView)
            make.bottom.equalTo(rightView)
            make.trailing.equalTo(rightView)
        }
        
    }
}

