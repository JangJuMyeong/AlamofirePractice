//
//  MySearchRouter.swift
//  AlamofirePractice
//
//  Created by 장주명 on 2021/06/01.
//

import Foundation
import Alamofire

// 검색 관렴 api호출
enum MySearchRouter: URLRequestConvertible {
    
    case searchPhotos(term:String)
    case searchUsers(term:String)
    
    var baseURL: URL {
        return URL(string: APi.BASE_URL + "search/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchUsers,.searchPhotos:
            return .get
        }
//        switch self {
//        case .searchPhotos:
//            return .get
//        case .searchUsers:
//            return .get
//        }
    }
    
    var endPoint: String {
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    
    var parameters : [String:String] {
        switch self {
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query" : term]
        
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
        
        print("MySearchRouter - asURLRequest() url = \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        request = try URLEncodedFormParameterEncoder().encode(parameters,into:request)
        
        return request
    }
}

