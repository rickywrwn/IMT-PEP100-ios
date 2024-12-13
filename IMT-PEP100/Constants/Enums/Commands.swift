//
//  Commands.swift
//  MEP
//
//  Created by Nathan Getachew on 3/14/24.
//

import Foundation
import CoreBluetooth

enum Commands {
    case startMeasurement
    case stopMeasurement
    case calibrate

    var bytes: [UInt8] {
        switch self {
        case .startMeasurement:
            return [UInt8.PACKET_START_BYTE, UInt8.START_MEASUREMENT_BYTE, 0x00, 0x00, 0x00, 0x00, 0x00, UInt8.PACKET_END_BYTE]
        case .stopMeasurement:
            return [UInt8.PACKET_START_BYTE, UInt8.STOP_MEASUREMENT_BYTE, 0x00, 0x00, 0x00, 0x00, 0x00, UInt8.PACKET_END_BYTE]
        case .calibrate:
            return [UInt8.PACKET_START_BYTE, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, UInt8.PACKET_END_BYTE]
        }
    }
    
    var writeType: CBCharacteristicWriteType {
       switch self {
         case .startMeasurement:
              return .withoutResponse
        case .stopMeasurement:
                return .withoutResponse
        case .calibrate:
                return .withResponse
       } 
    }
}
