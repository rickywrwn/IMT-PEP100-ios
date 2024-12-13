//
//  ServiceCharacteristicsMock.swift
//  MEP
//
//  Created by Nathan Getachew on 2/28/24.
//

import Foundation
import CoreBluetooth

class ServiceCharacteristicsMock {
    private var value: Data = Data([UInt8(0x00)])
    
    private let serviceUuid: CBUUID = CBUUID(string: UUID().uuidString)
    private let characteristicUuid: CBUUID = CBUUID(string: UUID().uuidString)
    
    public func service() -> [CBMutableService] {
        return [
            CBMutableService(type: serviceUuid, primary: true),
        ]
    }

    public func characteristics(_ serviceUUID: CBUUID) -> [CBCharacteristic] {
        switch serviceUUID {
        case serviceUuid:
            return [
                mutableCharacteristic(uuid: characteristicUuid),
            ]
        default:
            return []
        }
    }

    private func mutableCharacteristic(uuid: CBUUID) -> CBMutableCharacteristic {
        return CBMutableCharacteristic(type: uuid,
                                        properties: [.read, .write, .notify],
                                        value: nil,
                                        permissions: .readable)
    }

    public func value(uuid: CBUUID) -> Data {
        switch uuid {
        case characteristicUuid:
            return value
        
        default:
            return Data()
        }
    }
    
    public func writeValue(uuid: CBUUID, writeValue: Data) {
        switch uuid {
        case characteristicUuid:
            value = writeValue
            
        default:
            break
        }
    }
}
