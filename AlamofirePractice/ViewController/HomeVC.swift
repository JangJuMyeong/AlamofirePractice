//
//  ViewController.swift
//  AlamofirePractice
//
//  Created by 장주명 on 2021/06/01.
//

import UIKit
import Alamofire
import Toast_Swift

class HomeVC: BaseVC, UISearchBarDelegate, UIGestureRecognizerDelegate {

   
    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    
    var keyboardDismissTabGestrue : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    // MARK: -override method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    //화면이 넘어가기 전에 준비한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeVC - prepare() called / segue.identifier : \(segue.identifier)")
        
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            
            let nextVC = segue.destination as! UserListVC
            
            guard let userInputValue = self.searchBar.text else { return }
            
            nextVC.vcTitle = userInputValue + " 🧑‍💻"
            
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            
            let nextVC = segue.destination as! PhotoCollectionVC
            
            guard let userInputValue = self.searchBar.text else { return }
            
            nextVC.vcTitle = userInputValue + " 🧑‍💻"
            
        default:
            print("default")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("HomeVC - viewWillAppear() called")
        // 키보드가 올라가는 이벤트를 처리
        //키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHideHandle(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("HomeVC - viewDidAppear")
        self.searchBar.becomeFirstResponder() // 포커싱 주기
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC - viewWillDisappear() called")
        // 키보드 노티 삭제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    // MARK: - fileprivat methods
    
    fileprivate func pushVC() {
        var segueID : String = ""
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            print("사진 화면으로 이동")
            segueID = "goToPhotoCollectionVC"
        case 1:
            print("사용자 화면으로 이동")
            segueID = "goToUserListVC"
        default:
            print("default")
        }
        
        self.performSegue(withIdentifier: segueID, sender: self)
    }
    
    fileprivate func setUp() {
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.delegate = self
        self.keyboardDismissTabGestrue.delegate = self
        
        //제스처 추가하기
        self.view.addGestureRecognizer(keyboardDismissTabGestrue)
        

    }
    
    @objc func KeyboardWillShowHandle(notification : NSNotification) {
        print("HomeVC - KeyboardWillShow() called ")
        // 키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardSize.height : \(keyboardSize.height)")
            
            //키보드가 버튼을 덮었을경우
            if keyboardSize.height < searchButton.frame.origin.y {
                let distence = keyboardSize.height - searchButton.frame.origin.y
                self.view.frame.origin.y = distence + searchButton.frame.height
            }
        }
        
    }
    
    @objc func KeyboardWillHideHandle(notification : NSNotification) {
        print("HomeVC - KeyboardWillhide() called ")
        self.view.frame.origin.y = 0
    }
    
    // MARK: - IBAction methods
    
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        print("HomeVC - onSearchButtonClicked() Called / selectedIndex = \(searchFilterSegment.selectedSegmentIndex)")
        
//        let url = APi.BASE_URL + "search/photos"
        
        guard let userInput = self.searchBar.text else {
            return
        }
//        let queryParam = ["query": userInput,"client_id" : APi.CLIENT_ID]
        
//        AF.request(url, method: .get, parameters: queryParam).responseJSON(completionHandler: {response in
//            debugPrint(response)
//        })
        
        var urlToCall : URLRequestConvertible?
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            urlToCall = MySearchRouter.searchPhotos(term: userInput)
        case 1:
            urlToCall = MySearchRouter.searchUsers(term: userInput)
        default :
            print("default")
        }
        
        
        if let urlConvertible = urlToCall {
            MyAlamofireManager
                .shared
                .session
                .request(urlConvertible)
                .validate(statusCode: 200..<401)
                .responseJSON(completionHandler: {response in
                debugPrint(response)
            })
        }
       
        
//        pushVC()
    }
    
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
        print("HomeVC - searchFilterValueChanged() Called / index = \(sender.selectedSegmentIndex)")
        
        var searchBarTitle = ""
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        
        self.searchBar.placeholder = searchBarTitle + " 입력"
        
        self.searchBar.becomeFirstResponder()
//        self.searchBar.resignFirstResponder() // 포커싱 해제
        
    }
    
    // MARK: - UISearchBarDelegate methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked() Called")
        
        guard let userInputString = searchBar.text else {
            return
        }
        
        if userInputString.isEmpty {
            self.view.makeToast("📢 검색 키워드를 입력해주세요", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() searchText = \(searchText)")
        
        // 사용자가 입력한 값이 없을떄
        if searchText.isEmpty {
            self.searchButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                searchBar.resignFirstResponder()
            }
            //포커싱 해제
            
        } else {
            self.searchButton.isHidden = false
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        let inputTextCount =
            searchBar.text?.appending(text).count ?? 0
        
        print("HomeVc - shouldChangeTextIn : \(inputTextCount)")
        
        
        if inputTextCount > 12 {
            // toast with a specific duration and position
            self.view.makeToast("📢 12자 까지만 입력 가능합니다.", duration: 1.0, position: .center)
        } else {
            
        }
        
        
        return inputTextCount <= 12
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        //터치로 들어온뷰가 예외뷰인지 확인
        if (touch.view?.isDescendant(of: searchFilterSegment) == true) || touch.view?.isDescendant(of: searchBar) == true {
            print("예외 뷰가 터치됨")
            return false
        } else {
            view.endEditing(true)
            
            return true
        }
        

    }
    
    
}

