//
//  BaseVC.swift
//  AlamofirePractice
//
//  Created by 장주명 on 2021/06/01.
//

import UIKit
import Toast_Swift

class BaseVC: UIViewController {
    var vcTitle : String = "" {
        didSet {
            print("UserListVC - vcTitle didSet() called / vcTitle = \(vcTitle)")
            self.navigationItem.title = vcTitle
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    //MARK: - objc methods
    
    @objc func showErrorPopup(notification : NSNotification) {
        print("BasceVC - showErrorPopup() Called")
        
        if let data = notification.userInfo?["statusCode"] {
            print("showErrorPopup() data : \(data)")
            
            //메인스레드에서 돌리기 UI관련된것은
            DispatchQueue.main.async {
                self.view.makeToast("💀 \(data) 에러 입니다.", duration: 1.5, position: .center)
            }
            
        }
    }
    
    
}
