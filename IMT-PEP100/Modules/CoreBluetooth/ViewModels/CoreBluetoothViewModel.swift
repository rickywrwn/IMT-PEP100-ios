//
//  CoreBluetoothViewModel.swift
//  MEP
//
//  Created by Nathan Getachew on 2/27/24.
//

import SwiftUI
import CoreBluetooth

// store device information like battery level
struct DeviceInformation {
    var batteryLevel: Double?
    
    var batteryIcon: String? {
        guard batteryLevel != nil else {return nil}
        if batteryLevel! >= 4.1 {
            return "Battery4"
        } else if batteryLevel! >= 4 {
            return "Battery3"
        } else if batteryLevel! >= 3.9 {
            return "Battery2"
        } else if batteryLevel! >= 3.8 {
            return "Battery1"
        } else {
            return "Battery0"
        }
    }
}

struct MeasurementData: Identifiable, Equatable {
    let id = UUID()
    var date: Date
    var value: Double
}
 
class CoreBluetoothViewModel: NSObject, ObservableObject, CBPeripheralProtocolDelegate, CBCentralManagerProtocolDelegate {
    
    @Published var isBlePower: Bool = false
    @Published var isSearching: Bool = false
    @Published var isConnected: Bool = false {
        didSet {
            if isConnected && deviceInformation == nil {
                
            }
        }
    }
    
    @Published var foundPeripherals: [Peripheral] = []
    private var foundServices: [Service] = []
    private var foundCharacteristics: [Characteristic] = []
    
    // store measurement data from the device with the date
    @Published var measurementData: [MeasurementData] = []
    @Published var isExercise: Bool = false

    
    private var centralManager: CBCentralManagerProtocol!
    private var connectedPeripheral: Peripheral! {
        didSet {
            if connectedPeripheral != nil {
                // check battery
                
            }
        }
    }
        
     @Published var deviceInformation: DeviceInformation? = nil
    
    
    
    private let SERVICE_UUID = CBUUID(string: "FFF0")
    private let NOTIFY_CHAR_UUID = CBUUID(string: "FFF1")
    private var notifyCharacteristic: CBCharacteristic?
    private let WRITE_CHAR_UUID = CBUUID(string: "FFF2")
    private var writeCharacteristic: CBCharacteristic?
    
    override init() {
        super.init()
#if targetEnvironment(simulator)
        centralManager = CBCentralManagerMock(delegate: self, queue: nil)
#else
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
#endif
    }
    
    private func resetConfigure() {
        withAnimation {
            isSearching = false
            isConnected = false
            
            foundPeripherals = []
            foundServices = []
            foundCharacteristics = []
        }
    }
    
    //Control Func
    func startScan() {
        let scanOption = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        centralManager?.scanForPeripherals(withServices: nil, options: scanOption)
        print("# Start Scan")
        isSearching = true
    }
    
    func stopScan(){
        disconnectPeripheral()
        centralManager?.stopScan()
        print("# Stop Scan")
        isSearching = false
    }
    
    func connectPeripheral(_ selectPeripheral: Peripheral?) {
        guard let connectPeripheral = selectPeripheral else { return }
        connectedPeripheral = selectPeripheral
        centralManager.connect(connectPeripheral.peripheral, options: nil)
    }
    
    func disconnectPeripheral() {
        guard let connectedPeripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral.peripheral)
    }
    
    //MARK: CoreBluetooth CentralManager Delegete Func
    func didUpdateState(_ central: CBCentralManagerProtocol) {
        if central.state == .poweredOn {
            isBlePower = true
        } else {
            isBlePower = false
        }
        //        switch central.state {
        //        case .poweredOn:
        //            break
        //            //            isBlePower = true
        //        case .poweredOff:
        //            break
        //            // Alert user to turn on Bluetooth
        //        case .resetting:
        //            break
        //            // Wait for next state update and consider logging interruption of Bluetooth service
        //        case .unauthorized:
        //            break
        //            // Alert user to enable Bluetooth permission in app Settings
        //        case .unsupported:
        //            break
        //            // Alert user their device does not support Bluetooth and app will not work as expected
        //        case .unknown:
        //            break
        //            // Wait for next state update
        //        @unknown default:
        //            fatalError()
        //        }
    }
    
    func didDiscover(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, advertisementData: [String : Any], rssi: NSNumber) {
        if rssi.intValue >= 0 { return }
        
        let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? nil
        var _name = ""
        
        if peripheralName != nil {
            _name = String(peripheralName!)
        } else if peripheral.name != nil {
            _name = String(peripheral.name!)
        }
        
        guard !_name.isEmpty, _name == Strings.MIPMEP else {return}
        
        let foundPeripheral: Peripheral = Peripheral(_peripheral: peripheral,
                                                     _name: _name,
                                                     _advData: advertisementData,
                                                     _rssi: rssi,
                                                     _discoverCount: 0)
        
        if let index = foundPeripherals.firstIndex(where: { $0.peripheral.identifier.uuidString == peripheral.identifier.uuidString }) {
            if foundPeripherals[index].discoverCount % 50 == 0 {
                foundPeripherals[index].name = _name
                foundPeripherals[index].rssi = rssi.intValue
                foundPeripherals[index].discoverCount += 1
            } else {
                foundPeripherals[index].discoverCount += 1
            }
        } else {
            foundPeripherals.append(foundPeripheral)
            DispatchQueue.main.async { self.isSearching = false }
        }
    }
    
    func didConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol) {
        guard let connectedPeripheral = connectedPeripheral else { return }
        isConnected = true
        connectedPeripheral.peripheral.delegate = self
        connectedPeripheral.peripheral.discoverServices(nil)
        if self.deviceInformation == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.sendCommand(.startMeasurement)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                    self.sendCommand(.stopMeasurement)
                    self.resetMeasurementData()
                }
            }
        }
       
        
    }
    
    func didFailToConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?) {
        disconnectPeripheral()
    }
    
    func didDisconnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?) {
        print(error?.localizedDescription ?? "")
        print("disconnect")
        resetConfigure()
    }
    
    func connectionEventDidOccur(_ central: CBCentralManagerProtocol, event: CBConnectionEvent, peripheral: CBPeripheralProtocol) {
        
    }
    
    func willRestoreState(_ central: CBCentralManagerProtocol, dict: [String : Any]) {
        
    }
    
    func didUpdateANCSAuthorization(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol) {
        
    }
    
    //MARK: CoreBluetooth Peripheral Delegate Func
    func didDiscoverServices(_ peripheral: CBPeripheralProtocol, error: Error?) {
        peripheral.services?.forEach { service in
            let setService = Service(_uuid: service.uuid, _service: service)
            
            foundServices.append(setService)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func didDiscoverCharacteristics(_ peripheral: CBPeripheralProtocol, service: CBService, error: Error?) {
        service.characteristics?.forEach { characteristic in
            let setCharacteristic: Characteristic = Characteristic(_characteristic: characteristic,
                                                                   _description: "",
                                                                   _uuid: characteristic.uuid,
                                                                   _readValue: "",
                                                                   _service: characteristic.service!)
            foundCharacteristics.append(setCharacteristic)
            
            if characteristic.uuid == NOTIFY_CHAR_UUID {
                if characteristic.properties.contains(.notify){
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                self.notifyCharacteristic = characteristic
            } else if characteristic.uuid == WRITE_CHAR_UUID {
                
                if characteristic.properties.contains(.write) {
                }
                if characteristic.properties.contains(.writeWithoutResponse) {
                }
                self.writeCharacteristic = characteristic
            }
        }
        if (self.writeCharacteristic == nil || self.notifyCharacteristic == nil) {
            print("Failed to discover  write or notify characteristic")
            self.disconnectPeripheral()
            return
        }
    }
    func didDiscoverDescriptors(_ peripheral: CBPeripheralProtocol, characteristic: CBCharacteristic, error: Error?) {
        characteristic.descriptors?.forEach { descriptor in
            peripheral.readValue(for: descriptor)
        }
    }
    
    func didUpdateValue(_ peripheral: CBPeripheralProtocol, characteristic: CBCharacteristic, error: Error?) {
        guard let characteristicValue = characteristic.value else { return }
//        print(characteristic.value?.forEach({ uint in
//            print(uint)
//        }) ?? 0)
//        print("--------------")
        parseReceivedValue(characteristicValue)
        //        if let index = foundCharacteristics.firstIndex(where: { $0.uuid.uuidString == characteristic.uuid.uuidString }) {
        //
        //            foundCharacteristics[index].readValue = characteristicValue.map({ String(format:"%02x", $0) }).joined()
        //        }
    }
    
    
    
    func didWriteValue(_ peripheral: CBPeripheralProtocol, characteristic: CBCharacteristic, error: Error?) {
        print(characteristic)
        
    }
    
    func didUpdateNotificationState(_ peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        print(characteristic)
    }
    
    func didUpdateValue(_ peripheral: CBPeripheralProtocol, descriptor: CBDescriptor, error: Error?){
        print(descriptor)
        //        descriptor.value
    }
    
    
    func didWriteValue(_ peripheral: CBPeripheralProtocol, descriptor: CBDescriptor, error: Error?) {
        print(descriptor)
        
    }
    
    func sendCommand(_ command: Commands, isExercise: Bool = false) {
        guard let writeCharacteristic = writeCharacteristic, let connectedPeripheral = connectedPeripheral else { return }
        if command == .startMeasurement{
            resetMeasurementData(isExercise: isExercise)
        }
        let writeData = Data(command.bytes)
        connectedPeripheral.peripheral.writeValue(writeData, for: writeCharacteristic, type: command.writeType)
    }
    
    
    
    func parseReceivedValue(_ receivedData: Data) {
        let receivedDataArray = [UInt8](receivedData)
        let packetStartIndex = receivedDataArray.firstIndex(of: UInt8.PACKET_START_BYTE)
        let packetEndIndex = receivedDataArray.firstIndex(of: UInt8.PACKET_END_BYTE)
        guard  packetStartIndex != nil, packetEndIndex != nil else { return }
        
        let packet = Array(receivedDataArray[packetStartIndex!...packetEndIndex!])
        guard packet.count == 8 else { return }
        
        switch packet[1] {
        case UInt8.MEASUREMENT_DATA_BYTE:
            if deviceInformation == nil {
                let msb = Double( packet[5])
                let lsb = Double( packet[6])
                var value : Double = Double((msb * 256) + lsb)
                value *= 0.01
                deviceInformation = .init(batteryLevel: value)
                print("Battery Level: \(value)")
            }
            let msb = Double( packet[3])
            let lsb = Double( packet[4])
            let cutoff: Double = pow(2,15)
            var value : Double = Double((msb * 256) + lsb)
            if value >= cutoff {
                value -= pow(2, 16)
            }
            value *= 0.1
            if isExercise {
                measurementData.append(MeasurementData(date: Date(), value: value))
            } else {
                if measurementData.isEmpty {
                    if value >= 5 || value <= -5 {
                        measurementData.append(MeasurementData(date: Date(), value: abs(value)))
                    }
                } else {
                    measurementData.append(MeasurementData(date: Date(), value: abs(value)))
                }
            }
        default:
            return
        }
        
        // let packetData = Data(packet)
        // let packetString = String(data: packetData, encoding: .utf8)
        // print(packetString ?? "")
    }
    
    func resetMeasurementData(isExercise: Bool = false ) {
        self.measurementData = []
        self.isExercise = isExercise
    }
}
