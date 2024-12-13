//
//  Locales.swift
//  MEP
//
//  Created by Nathan Getachew on 3/4/24.
//

import Foundation

enum Locales: String, CaseIterable {
    case korean
    case english
    
    var shortName: String {
        switch self {
        case .korean:
            return "KR"
        case .english:
            return "EN"
        }
    }

    var identifier: String {
        switch self {
        case .korean:
            return "ko"
        case .english:
            return "en"
        }
    }
}
