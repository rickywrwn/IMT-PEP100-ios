//
//  NavigationStore.swift
//  MEP
//
//  Created by Nathan Getachew on 3/4/24.
//

import SwiftUI

class NavigationStore: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    
//    @AppStorage("StackView.navigation") static private var data: Data?
//    @Published var path: NavigationPath
//    {
//        didSet {
//            save()
//        }
//    }
    
//    static func readSerializedData() -> Data? {
//        Self.data
//    }
//
//    static func writeSerializedData(_ data: Data) {
//        Self.data = data
//    }
    
//    private let savePath = getFilePath(for: "SavedPathStore")
    
//    init() {
        //        if let data = try? Data(contentsOf: savePath) {
        //            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
        //                path = NavigationPath(decoded)
        //                return
        //            }
        //        }
        
        // use this
//        if let data = Self.readSerializedData() {
//            do {
//                let representation = try JSONDecoder().decode(
//                    NavigationPath.CodableRepresentation.self,
//                    from: data)
//                self.path = NavigationPath(representation)
//            } catch {
//                self.path = NavigationPath()
//            }
//        } else {
//            self.path = NavigationPath()
//        }
//    }
    
    func save() {
        // use this
//        guard let representation = path.codable else { return }
//                do {
//                    let encoder = JSONEncoder()
//                    let json = try encoder.encode(representation)
//                    Self.writeSerializedData(json)
//                } catch {
//                    // Handle error.
//                    print("Error saving path: \(path)")
//                }
//        guard let representation = path.codable else { return }
//
//        do {
//            let data = try JSONEncoder().encode(representation)
//            try data.write(to: savePath)
//        } catch {
//            print("Failed to save navigation data")
//        }
    }
}
