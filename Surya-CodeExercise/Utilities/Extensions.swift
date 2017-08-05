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
