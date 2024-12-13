//
//  UserRegistrationScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 1/30/24.
//

import SwiftUI
import SwiftUIIntrospect
enum Gender: Int, Identifiable, CaseIterable {
    case male = 1
    case female = 2
    
    var id: Int { self.rawValue }
    
    var localizationKey: String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        }
    }
    
}



enum Race: Int, Identifiable, CaseIterable {
    case asian = 1
    case western = 2
    
    var id: Int { self.rawValue }
    
    var localizationKey: String {
        switch self {
        case .asian:
            return "asian"
        case .western:
            return "western"
        }
    }
}

struct UserRegistrationScreen: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss
    // accept user to edit
    var user: User?
    
     @State private var datePicker: UIDatePicker?
//    @State private var picker: uipicke

    
    //  form fields
    @State var name: String = ""
    @State var birthDate = Date()
    @State var gender: Gender = .male
    @State var height: Int = 0
    @State var weight: Int = 0
    @State var race: Race = .asian
    
    init (user: User? = nil) {
        self.user = user
        if let user = user {
            _name = State(initialValue: user.name ?? "")
            _birthDate = State(initialValue: user.birthDate ?? .now)
            _gender = State(initialValue: Gender(rawValue: Int(user.gender)) ?? .male)
            _height = State(initialValue: Int(user.height))
            _weight = State(initialValue: Int(user.weight))
            _race = State(initialValue: Race(rawValue: Int(user.race)) ?? .asian)
        }
    }
    
    @State private var alertPopupVisible = false
    @State private var alertText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                AvatarView(size: 40)
                
                Grid(alignment: .trailing, verticalSpacing: 20) {
                    GridRow {
                        FormLabel(label: "name")
                        FormTextfield(placeHolder: "name", text: $name)
                        
                    }
                    GridRow {
                        FormLabel(label: "birth-date")
                        //                FormTextfieldPlaceHolder(placeHolder:  "\(birthDate.formatted(.dateTime.month().day().year()))")
                        ZStack {
                            
                            DatePicker("", selection: $birthDate, displayedComponents: .date)
                                .labelsHidden()
//                                .fixedSize(horizontal: false, vertical: false)
//                                .contentShape(Rectangle())
                                .opacity(0.011)
                                .compositingGroup()
                                .scaleEffect(x: 10, y: 10)
                                .clipped()
                                .onTapGesture {
                                                    let button = datePicker?.findViews(of: UIButton.self).first
                                                    button?.sendActions(for: .touchUpInside)
                                                }
                                .introspect(.datePicker, on: .iOS(.v16, .v17)) { datePicker in
                                    DispatchQueue.main.async {
                                        self.datePicker = datePicker
                                    }
                                                }
                            FormTextfield(placeHolder: "6-digit-birth-date", text: .constant(
                                calculateAge(birthDate: birthDate) <= 0 ? "" :
                                    "\(birthDate.formatted(.dateTime.month().day().year()))"))
                            .allowsHitTesting(false)

                        }
//                        .contentShape(Rectangle())

                    }
                    .contentShape(Rectangle())
                    GridRow {
                        FormLabel(label: "gender")
                        HStack {
                            Spacer()
                            HStack {
                                RadioButton(isSelected: Binding(get: {
                                    gender == .male
                                }, set: { value in
                                    gender = .male
                                }))
                                Text("male")
                            }
                            Spacer()
                            HStack {
                                RadioButton(isSelected: Binding(get: {
                                    gender == .female
                                }, set: { value in
                                    gender = .female
                                }))
                                Text("female")
                            }
                            Spacer()
                        }
                    }
                    GridRow {
                        FormLabel(label: "height")
                        FormTextfield(placeHolder: "(cm)", text: Binding(get: {
                            height > 0 ? "\(height)" : ""
                        }, set: { value in
                            height = Int(value) ?? 0
                        }))
                        .keyboardType(.numberPad)
                    }
                    GridRow {
                        FormLabel(label: "weight")
                        FormTextfield(placeHolder: "(kg)", text: Binding(get: {
                            weight > 0 ? "\(weight)" : ""
                        }, set: { value in
                            weight = Int(value) ?? 0
                        }))
                        .keyboardType(.numberPad)
                    }
                    
//                    GridRow {
//                        FormLabel(label: "race")
//                        FormTextfield(
//                            placeHolder: "", text:
//                                    .constant(
//                                        String(
//                                            localized: String.LocalizationValue(stringLiteral: race.localizationKey),
//                                            locale: Locale(identifier: Locales.korean.identifier)
//                                        )
//                                    )
//                        )
//                        .overlay {
//                            Picker("", selection: $race) {
//                                ForEach(Race.allCases) { race in
//                                    Text(LocalizedStringKey(race.localizationKey))
//                                        .tag(race)
//                                }
//                                
//                            }
//                            .pickerStyle(.menu)
//                            .labelsHidden()
//                            .fixedSize(horizontal: false, vertical: false)
//                            .opacity(0.011)
//                        }
//                    }
                    
                    GridRow {
                        FormLabel(label: "race")
                        ZStack {
                            
                            Picker("", selection: $race) {
                                ForEach(Race.allCases) { race in
                                    Text(LocalizedStringKey(race.localizationKey))
                                        .tag(race)
                                }
                                
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .fixedSize(horizontal: false, vertical: false)
                            .opacity(0.011)
                                .compositingGroup()
                                .scaleEffect(x: 10, y: 2)
                                .clipped()
//                                .onTapGesture {
//                                                    let button = picker.findViews(of: UIButton.self).first
//                                                    button?.sendActions(for: .touchUpInside)
//                                                }
//                                .introspect(.picker(style: .menu), on: .iOS(.v16, .v17)) { picker in
//                                                    self.picker = picker
//                                                }
                            FormTextfield(
                                placeHolder: "", text:
                                        .constant(
                                            String(
                                                localized: String.LocalizationValue(stringLiteral: race.localizationKey),
                                                locale: Locale(identifier: Locales.korean.identifier)
                                            )
                                        )
                            )
                            .allowsHitTesting(false)

                        }
//                        .contentShape(Rectangle())

                    }
                    .contentShape(Rectangle())
                    
                    GridRow {
                        VStack{}
                        HStack {
                            Text("*") + Text("required-fields")
                            Spacer()
                        }
                        .foregroundColor(.red)
                    }
                }
                
                Button {
                    // validate user data
                    if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        alertText = "Name is required"
                        alertPopupVisible = true
                        return
                    } else if height <= 0 {
                        alertText = "Height is required"
                        alertPopupVisible = true
                        return
                    } else if weight <= 0 {
                        alertText = "Weight is required"
                        alertPopupVisible = true
                        return
                    } else if calculateAge(birthDate: birthDate) <= 0 {
                        alertText = "Invalid birth date"
                        alertPopupVisible = true
                        return
                    }
                    
                    // save user to core data
                    let newUser = self.user ?? User(context: moc)
                    newUser.name = name
                    newUser.birthDate = birthDate
                    newUser.isSelected = true
                    newUser.gender = Int16(gender.rawValue)
                    newUser.height = Int16(height)
                    newUser.weight = Int16(weight)
                    newUser.race = Int16(race.rawValue)
                    
                    do {
                        try moc.save()
                        // unselect all users
                        let request = User.fetchRequest()
                        let users = try moc.fetch(request)
                        for user in users {
                            if user != newUser {
                                user.isSelected = false
                            } else {
                                user.isSelected = true
                            }
                        }
                        try moc.save()
                        dismiss()
                        
                    } catch let error {
                        print("Error saving user: \(error)")
                    }
                    
                } label: {
                    Text("confirm")
                        .foregroundColor(.white)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 14)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
                    .padding(32)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        Text("Done")
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }
        }
//        .padding(32)
        .navBar(title: "user-registration")
        .fullScreenCover(isPresented: $alertPopupVisible) {
            AlertPopup(label: alertText ) {
                alertPopupVisible = false
            } onCancel: {
                alertPopupVisible = false
            }
        }
        .onChange(of: alertPopupVisible) { newValue in
            if !newValue {
                alertText = ""
            }
        }
    }
}

#Preview {
    NavigationView {
        UserRegistrationScreen()
    }
}
