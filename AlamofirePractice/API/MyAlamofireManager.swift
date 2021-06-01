//
//  MyAlamofireManager.swift
//  AlamofirePractice
//
//  Created by 장주명 on 2021/06/01.
//

import Foundation
import Alamofire

final class MyAlamofireManager {
    
    //싱글턴 적용
    static let shared = MyAlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
                                    [
                                        BaseInterceptor()
                                    ])
    //로거
     let monitors = [MyLogger(), MyApiStatusLogger()] as [EventMonitor]
    //세션 설정
    var session : Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
}
