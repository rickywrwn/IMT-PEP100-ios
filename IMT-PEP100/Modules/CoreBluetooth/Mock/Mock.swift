//
//  Mock.swift
//  MEP
//
//  Created by Nathan Getachew on 2/28/24.
//

import Foundation

protocol Mock {}

extension Mock {
    var className: String {
        return String(describing: type(of: self))
    }
    
    func log(_ message: String? = nil) {
        print("Mocked -", className, message ?? "")
    }
}
