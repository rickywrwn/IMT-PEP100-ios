//
//  Collection.swift
//  MEP
//
//  Created by Nathan Getachew on 3/21/24.
//

import Foundation

extension Collection {
  subscript(safe index: Index) -> Iterator.Element? {
    guard indices.contains(index) else { return nil }
    return self[index]
  }
}
