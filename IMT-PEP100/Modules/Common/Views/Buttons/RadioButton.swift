//
//  RadioButton.swift
//  MEP
//
//  Created by Nathan Getachew on 1/31/24.
//

import SwiftUI

struct RadioButton: View {

    @ScaledMetric(relativeTo: .body) private var size: CGFloat = 20

    @ScaledMetric(relativeTo: .body) private var lineWidth: CGFloat = 1.5

    @Binding var isSelected: Bool

    var body: some View {
        Group {
            if isSelected {
                Image(systemName: "circle.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.accent)
                    .frame(width: size + lineWidth, height: size + lineWidth)
            } else {
                
                Circle()
                    .stroke(lineWidth: lineWidth)
                    .foregroundColor(Color(UIColor.tertiaryLabel))
                    .frame(width: size, height: size)
                    .padding(lineWidth / 2)
            }
        }
        .onTapGesture {
            isSelected.toggle()
        }
    }
}


#Preview {
    RadioButton(isSelected: .constant(true))
}

// MARK: - Alternative Radio
//struct RadioButton: View {
//
//    @Environment(\.colorScheme) var colorScheme
//
//    let id: String
//    let callback: (String)->()
//    let selectedID : String
//    let size: CGFloat
//    let color: Color
//    let textSize: CGFloat
//
//    init(
//        _ id: String,
//        callback: @escaping (String)->(),
//        selectedID: String,
//        size: CGFloat = 20,
//        color: Color = Color.primary,
//        textSize: CGFloat = 14
//        ) {
//        self.id = id
//        self.size = size
//        self.color = color
//        self.textSize = textSize
//        self.selectedID = selectedID
//        self.callback = callback
//    }
//
//    var body: some View {
//        Button(action:{
//            self.callback(self.id)
//        }) {
//            HStack(alignment: .center, spacing: 10) {
//                Image(systemName: self.selectedID == self.id ? "largecircle.fill.circle" : "circle")
//                    .renderingMode(.original)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: self.size, height: self.size)
////                    .modifier(ColorInvert())
//                Text(id)
//                    .font(Font.system(size: textSize))
//                Spacer()
//            }.foregroundColor(self.color)
//        }
//        .foregroundColor(self.color)
//    }
//}

//struct RadioButtonGroup: View {
//
//    let items : [String]
//
//    @State var selectedId: String = ""
//
//    let callback: (String) -> ()
//
//    var body: some View {
//        VStack {
//            ForEach(0..<items.count) { index in
//                RadioButton(self.items[index], callback: self.radioGroupCallback, selectedID: self.selectedId)
//            }
//        }
//    }
//
//    func radioGroupCallback(id: String) {
//        selectedId = id
//        callback(id)
//    }
//}

//RadioButtonGroup(items: ["Rome", "London", "Paris", "Berlin", "New York"], selectedId: "London") { selected in
//               print("Selected is: \(selected)")
//           }
