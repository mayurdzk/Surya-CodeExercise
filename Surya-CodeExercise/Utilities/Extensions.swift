//
//  Extensions.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//

import Foundation

extension URL {
    /// Attempts to initialise a URL from an optional string
    init?(optionalString: String?) {
        guard let string = optionalString else { return nil }
        if let url = URL(string: string) {
            self = url
        } else {
            return nil
        }
    }
}

extension String {
    /// Access this property on a String to have it be converted into key-value pairs for JSON
    var parameterisedForJSON: [String : AnyObject]? {
        guard let objectData: Data = self.data(using: .utf8) else {
            crashDebug(with: "Couldn't convert the string to data")
            return nil
        }
        var jsonDict: [String : AnyObject]? = nil
        do {
            jsonDict = try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers) as? [String : AnyObject]
            return jsonDict
        } catch {
            crashDebug(with: "JSON serialization failed:  \(error)")
            return nil
        }
    }
}
