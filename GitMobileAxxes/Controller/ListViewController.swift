//
//  ListViewController.swift
//  MobileAxxess_Mayur_Limbekar
//
//  Created by Admin on 18/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import RealmSwift

class ListViewController: UIViewController,ReachabilityObserverDelegate {
    // Mark:- Instance of View
    let listTableview = UITableView()
    
    //Mark:- Declaration of variable and Constant
    private let realm = try! Realm()
    var listArr = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? addReachabilityObserver()

        self.setUpListView()
        // Do any additional setup after loading the view.
    }

    deinit {
        removeReachabilityObserver()
    }
    
    //    Mark:- Internet Rechability Checking
    func reachabilityChanged(_ isReachable: Bool) {
        print("isReachable",isReachable)
        if isReachable {
            let dispatchQueue = DispatchQueue.global(qos: .background)
            dispatchQueue.async {
               self.getData()
            }
        } else {
            getDataFroDataBase()
        }
    }
    
//    Mark:- Design setup
    private func setUpListView() {
        view.backgroundColor = UIColor.white
        self.view.addSubview(listTableview)
        
        self.listTableview.delegate = self
        self.listTableview.dataSource = self
        self.listTableview.register(ListTableViewCell.self, forCellReuseIdentifier: "ListTableViewCell")
        
        let footerView = UIView()
        listTableview.tableFooterView = footerView
        
        
        listTableview.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// Mark:- Table view deledate and data sorce

extension ListViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Text"
        } else if section == 1 {
            return "Image"
        } else {
            return "Other"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let textArr = listArr.filter{ $0.type == "text"}.count
            return textArr
        } else if section == 1 {
            return listArr.filter{ $0.type == "image"}.count
        } else {
            return listArr.filter{ $0.type == "other"}.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListTableViewCell = listTableview.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        if indexPath.section == 0 {
            let textArr = listArr.filter{ $0.type == "text"}
            print(textArr)
            cell.configCell(model: textArr[indexPath.row])
        } else if indexPath.section == 1 {
            let imageArr = listArr.filter{ $0.type == "image"}
            cell.configCell(model: imageArr[indexPath.row])
        } else {
            let otherArr = listArr.filter{ $0.type == "other"}
            cell.configCell(model: otherArr[indexPath.row])
        }
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = DetailsViewController()
        
         if indexPath.section == 0 {
            let textArr = listArr.filter{ $0.type == "text"}
            detailView.selecteModel = textArr[indexPath.row]
         } else if indexPath.section == 1 {
            let imageArr = listArr.filter{ $0.type == "image"}
            detailView.selecteModel = imageArr[indexPath.row]
         } else {
            let otherArr = listArr.filter{ $0.type == "other"}
            detailView.selecteModel = otherArr[indexPath.row]
        }
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
//Mark:- Api Calling
extension ListViewController {
    func getData() {
        let dataUrl = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json"
        let manager = Alamofire.Session.default
        manager.request(dataUrl, method:.get).responseJSON(completionHandler:{ response in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                
                do {
                    self.listArr.removeAll()
                    self.listArr = try JSONDecoder().decode([Model].self, from: data)
                } catch let err {
                    debugPrint(err)
                }
                
                DispatchQueue.main.async {
                    self.listTableview.reloadData() {
                        self.saveDataToDataBase()
                    }
                }
                break
                
            case .failure( _) :
                let alert = UIAlertController(title:"Alert", message: "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}

//    Mark:-Local database save and retrive data operations
extension ListViewController {
    func getDataFroDataBase() {
        let resultss = realm.objects(Model.self)
        let secondArr = Array(resultss)
        self.listArr.removeAll()
        for i in secondArr {
            listArr.append(i)
        }
        
        DispatchQueue.main.async {
            self.listTableview.reloadData()
        }
    }
    
    func saveDataToDataBase () {
        if listArr.count > 0 {
            try! realm.write {
                realm.add(listArr, update: Realm.UpdatePolicy.modified)
            }
        }
    }
}

extension UITableView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
        {_ in completion() }
    }
}
