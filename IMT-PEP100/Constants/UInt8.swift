//
//  UInt8.swift
//  MEP
//
//  Created by Nathan Getachew on 3/14/24.
//

import Foundation

extension UInt8 {
    static let PACKET_START_BYTE: UInt8 = 0x2A
    static let PACKET_END_BYTE: UInt8 = 0x24
    //MARK: -
    static let START_MEASUREMENT_BYTE: UInt8 = 0x01
    static let STOP_MEASUREMENT_BYTE: UInt8 = 0x02
    //MARK: -
    static let SPAN_OFFSET_SETUP_BYTE: UInt8 = 0x80
    static let SPAN_OFFSET_RESPONSE_BYTE: UInt8 = 0x81
    // MARK: -
    static let MEASUREMENT_DATA_BYTE: UInt8 = 0xFF
    
}
