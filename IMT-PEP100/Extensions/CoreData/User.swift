//
//  User.swift
//  MEP
//
//  Created by Nathan Getachew on 3/10/24.
//

import Foundation

extension User {

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date(), forKey: "createdAt")
        setPrimitiveValue(Date(), forKey: "updatedAt")
        setPrimitiveValue(UUID(), forKey: "id")
    }
    
    override public func willSave() {
        super.willSave()
            if let updatedAt = updatedAt {
                if updatedAt.timeIntervalSince(Date()) > 10.0 {
                    self.updatedAt = Date()
                }

            } else {
                self.updatedAt = Date()
            }
        }
}
