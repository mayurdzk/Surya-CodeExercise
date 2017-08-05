//
//  Enums.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//


enum CodeExerciseStoryboards: String {
    case main = "Main"
}

enum HTTPRequestType {
    case post
}

enum ResultType {
    case success
    case failure(NetworkCallFailureReasons)
}

enum NetworkCallFailureReasons {
    case noInternet
    case invalidDataFromServer
    case other
    
    var userCommunicableMessage: String {
        switch self {
        case .invalidDataFromServer:
            return "We recieved invalid data. Please try again later."
        case .noInternet:
            return "You aren't connected to the internet."
        case .other:
            return "We ran into an unexpected error."
        }
    }
}
