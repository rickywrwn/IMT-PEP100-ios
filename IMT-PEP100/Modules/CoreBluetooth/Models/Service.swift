//
//  Service.swift
//  MEP
//
//  Created by Nathan Getachew on 2/27/24.
//

import CoreBluetooth

class Service: Identifiable, Equatable {
    static func == (lhs: Service, rhs: Service) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var uuid: CBUUID
    var service: CBService

    init(_uuid: CBUUID,
         _service: CBService) {
        
        id = UUID()
        uuid = _uuid
        service = _service
    }
}
