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

//MARK: -
//MARK: NetworkingManager
struct NetworkingManager{
    private let baseURL = "http://surya-interview.appspot.com/"
    
    /// Call this method to fetch all items matching the stored email address token.
    ///
    /// - Parameter completionHandler: Your completion handler is called on the main thread once all items are saved to disk
    func fetchAllItems(onCompletion completionHandler: @escaping ((ResultType) -> Void)) {
        let remoteEndPoint = baseURL + "list"
        //FIXME: Add a guard against no email token being present
        //FIXME: Add the appropriate POST Body
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
                    
                    let success = ModelManager().save(items: items)
                    if success {
                        completionHandler(.success)
                    } else {
                        completionHandler(.failure(.other))
                    }
                }
            case .failure(_):
                completionHandler(response.wasSuccess)
            }
        }
    }
    
    //Reviewer's Notes: This abstraction is created so that our dependency on Alamofire reduces. This is the bulk of the code where Alamofire will ever be referenced. This abstraction also makes it easier for enabling dependency injection and writing test for the code.
    
    private func networkCall(to urlAsString: String, ofType type: HTTPRequestType, result: @escaping ((JSONResponse) -> Void )) {
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

//MARK: -
//MARK: JSONResponse Definition
extension NetworkingManager {
    fileprivate struct JSONResponse {
        var jsonResult: JSON?
        var wasSuccess: ResultType
        
        
        /// Initialises a JSONResponse from Alamofire's DataResponse type. If a valid JSON object is not found, wasSuccess property is set to failure.
        ///
        /// - Parameter dataResponse:
        init(from dataResponse: DataResponse<Any>) {
            jsonResult = JSON(dataResponse)
            if let _ = jsonResult?.isEmpty {
                //An empty array may be returned
                wasSuccess = .success
            } else {
                wasSuccess = .failure(.invalidDataFromServer)
            }
        }
        
        
        /// Call this initialiser when you want a JSONResponse object for a failed workflow. The jsonResult becomes nil and wasSuccess is set to .failure with the failure reason you provide.
        ///
        /// - Parameter failureReason: <#failureReason description#>
        init(withFailureReason failureReason: NetworkCallFailureReasons) {
            jsonResult = nil
            wasSuccess = .failure(failureReason)
        }
    }
}

//MARK: -
//MARK: Extension for Alamofire's HTTPRequestType
fileprivate extension HTTPRequestType {
    /// Converts the request type to an enum value understood by Alamofire
    var toAlamofireMethod: HTTPMethod {
        switch self{
        case .post:
            return .post
        }
    }
}


//MARK: -
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
