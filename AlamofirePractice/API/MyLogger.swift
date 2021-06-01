//
//  Myloger.swift
//  AlamofirePractice
//
//  Created by 장주명 on 2021/06/01.
//

import Foundation
import Alamofire

final class MyLogger : EventMonitor {
    let queue = DispatchQueue(label : "ApiLog")
    
    //로그에서
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume() called")
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request.didParseResponse() called")
        debugPrint(response)
    }
    

}
