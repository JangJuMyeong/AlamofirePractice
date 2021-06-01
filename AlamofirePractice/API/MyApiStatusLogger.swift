//
//  MyApiStatusLogger.swift
//  AlamofirePractice
//
//  Created by 장주명 on 2021/06/01.
//

import Foundation
import Alamofire

final class MyApiStatusLogger : EventMonitor {
    let queue = DispatchQueue(label : "MyApiStatusLogger")
    
    //로그에서
//    func requestDidResume(_ request: Request) {
//        print("MyApiStatusLogger - requestDidResume() called")
//        debugPrint(request)
//    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        
        guard let statusCode = request.response?.statusCode else {
            return
        }
        
        print("MyApiStatusLogger - statusCode : \(statusCode) ")
//        debugPrint(response)
    }
}
