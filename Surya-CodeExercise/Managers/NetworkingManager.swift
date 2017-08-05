//
//  NetworkingManager.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//
import Alamofire
import SwiftyJSON
import Foundation
import SystemConfiguration

struct NetworkingManager{
    internal let baseURL = "http://surya-interview.appspot.com/"
    
    /// Call this method to fetch all items matching the stored email address token.
    ///
    /// - Parameter completionHandler: Your completion handler is called on the main thread once all items are saved to disk
    func fetchAllItems(onCompletion completionHandler: @escaping ((ResultType) -> Void)) {
        let remoteEndPoint = baseURL + "list"
        networkCall(to: remoteEndPoint, ofType: .post) { (response) in
            switch response.wasSuccess {
            case .success:
                guard let itemsArrayAsJSON = response.jsonResult?.array else {
                    crashDebug(with: "JSON \(String(describing: response.jsonResult)) was not found to be an array")
                    completionHandler(.failure(.invalidDataFromServer))
                    return
                }
                guard itemsArrayAsJSON.count > 0 else {
                    completionHandler(.success)
                    return
                }
                DispatchQueue.global(qos: .background).async {
                    var items = [Item]()
                    for itemJSON in itemsArrayAsJSON {
                        if let item = Item(from: itemJSON) {
                            items.append(item)
                        }
                    }
                    ModelManager().save(items: items)
                    completionHandler(.success)
                }
            case .failure(_):
                completionHandler(response.wasSuccess)
            }
        }
    }
    
    internal func networkCall(to urlAsString: String, ofType type: HTTPRequestType, result: @escaping ((JSONResponse) -> Void )) {
        guard Reachability.isConnectedToNetwork else {
            result(JSONResponse(withFailureReason: .noInternet))
            return
        }
        Alamofire.request(urlAsString, method: type.toAlamofireMethod).responseJSON { (response) in
            guard !response.result.isFailure else {
                crashDebug(with: "The response was a failure")
                result(JSONResponse(withFailureReason: .other))
                return
            }
            result(JSONResponse(from: response))
        }
    }
}

extension NetworkingManager {
    internal struct JSONResponse {
        var jsonResult: JSON?
        var wasSuccess: ResultType
        
        //FIXME: Doccumentation
        init(from dataResponse: DataResponse<Any>) {
            jsonResult = JSON(dataResponse)
            if let _ = jsonResult?.isEmpty {
                //An empty array may be returned
                wasSuccess = .success
            } else {
                wasSuccess = .failure(.invalidDataFromServer)
            }
        }
        
        //FIXME: Doccumentation
        init(withFailureReason failureReason: NetworkCallFailureReasons) {
            jsonResult = nil
            wasSuccess = .failure(failureReason)
        }
    }
}

fileprivate extension HTTPRequestType {
    /// Converts the request type to an enum value understood by Alamofire
    var toAlamofireMethod: HTTPMethod {
        switch self{
        case .post:
            return .post
        }
    }
}



//MARK: Reachability
fileprivate struct Reachability {
    static var isConnectedToNetwork: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
