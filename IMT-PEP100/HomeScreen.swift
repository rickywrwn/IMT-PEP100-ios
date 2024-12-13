//
//  RegistrationScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 1/29/24.
//

import SwiftUI


struct HomeScreen: View {
    @AppStorage(Strings.selectedLocale) var selectedLocale  = Locales.korean
    @EnvironmentObject var viewModel: CoreBluetoothViewModel
    @State var isBluetoothDevicesViewPresented = false
    @State var isUserSelectionViewPresented = false
    @State var isHelpPresented = false
    @EnvironmentObject var navStore : NavigationStore
    let offsetY : CGFloat = -80
    
    // get selected user from core data
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    var body: some View {
        let userSelected = !selectedUser.isEmpty
        VStack(spacing: 0) {
            VStack {
                ZStack(alignment: .bottom) {
                    CircleShape()
                        .fill(.accent)
                        .rotationEffect(.degrees(-180))
                        .aspectRatio(1.3, contentMode: .fit)
                    //                Circle()
                    //                    .fill(.accent)
                    //                    .trim(from: 0.0, to: 0.5)
                    //                    .trim(from: 0.4, to: 1)
                    //                                .rotationEffect(.degrees(-160))  360/10/2 = 18
                    //                                .scaledToFit()
                    //                    .frame(width: 500, height: 500)
                    //                        .offset(y: -100)
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .offset(y: offsetY + 20)
                    
//                    Text("MIPMEP")
//                        .font(.largeTitle)
//                        .bold()
//                        .foregroundColor(.white)
//                        .offset(y: offsetY)
                }
                .offset(y: offsetY)
                
                Spacer()
                
                VStack(spacing: 24) {
                    VStack {
                        AvatarView(size: 60)
                        if userSelected {
                            Group {
                                Text("\(selectedUser.first?.name ?? "") / ")
                                + Text(
                                    LocalizedStringKey(
                                        Gender(rawValue:
                                                Int(selectedUser.first?.gender ??
                                                    Int16(Gender.male.rawValue))
                                              )!.localizationKey
                                    )
                                )
                                + Text(" / ")
                                + Text("\(calculateAge(birthDate: selectedUser.first?.birthDate ?? .now))")
                            }
                            .foregroundColor(.accent)
                            //                        .font(.title)
                            //                        .bold()
                            
                        }
                    }
                    
                    VStack {
                        // Button {
                        //     viewModel.sendCommand(.calibrate)
                        // } label: {
                        //     Text("Cal")
                        //         .foregroundColor(.white)
                        //         .padding(.horizontal, 24)
                        //         .padding(.vertical, 14)
                        //         .background(Color.accentColor)
                        //         .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        // }
                        
                        // Button {
                        //     viewModel.sendCommand(.startMeasurement)
                        // } label: {
                        //     Text("Start")
                        //         .foregroundColor(.white)
                        //         .padding(.horizontal, 24)
                        //         .padding(.vertical, 14)
                        //         .background(Color.accentColor)
                        //         .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        // }
                        
                        Button {
                            isUserSelectionViewPresented = true
                        } label: {
                            Text("user-selection")
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        
                        
                        Button {
                            navStore.path.append(Screens.userRegistration)
                            
                        } label: {
                            Text("user-registration")
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                    
                }
                .offset(y: offsetY/2)
                
                Spacer()
            }
                HStack {
                    TabBarButton(
                        tab: .breathWorkout,
                       isUserSelected: userSelected
                    )
                    // divider
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 1)
                        .fixedSize(horizontal: true , vertical: false)
                    
                    TabBarButton(
                        tab: .respiratoryMeasurement,
                        isUserSelected: userSelected
                    )
                    
                    // divider
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 1)
                        .fixedSize(horizontal: true , vertical: false)
                    
                    TabBarButton(
                        tab: .lungMeasurement,
                        isUserSelected: userSelected
                    )
                    
                }
                .padding()
                .background(Color.accentColor)
                .fixedSize(horizontal: false, vertical: true)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            
            ToolbarItem {
                HStack(spacing: 4) {
                    Button {
                        isBluetoothDevicesViewPresented = true
                    } label: {
                        VStack {
                            Image("Bluetooth")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 1)
                                .background(viewModel.isConnected ? .accent : .gray)
                                .cornerRadius(12)
                                .padding(.horizontal, 2)
                                .padding(.vertical, 2)
                        }
                        .padding(2)
                        .background(.white)
                        .cornerRadius(6)
                        .padding( 2)
                    }
                    
                    Button {
                        isHelpPresented = true
                    } label: {
                        Image(systemName: "questionmark")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(4)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.white, lineWidth: 1)
                                )



                    }


                    Spacer()
                    Menu {
                        Picker("",selection: $selectedLocale) {
                            ForEach(Locales.allCases, id: \.self.rawValue) { locale in
                                Text(locale.shortName)
                                    .tag(locale)
                                    .font(.caption2)
                                    .background(.white)
                                
                                
                            }
                        }
                        
                    } label: {
                        Text(selectedLocale.shortName)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .padding(4)
                            .padding(.horizontal, 4)
                            .background(.white)
                            .cornerRadius(6)
                    }
                    
                    Image(viewModel.deviceInformation?.batteryIcon ?? "Battery2")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                }
            }
            
        }
        .navBar(title: "", showBackButton: false)
        .sheet(isPresented: $isUserSelectionViewPresented) {
            SelectUserScreen()
        }
        .sheet(isPresented: $isBluetoothDevicesViewPresented) {
            BluetoothDevicesListScreen()
        }
        .fullScreenCover(isPresented: $isHelpPresented) {
            InformationPopup(
                title: "B/T 연동방법",
                child: AnyView(
                    
                    Text("home-screen-help")
                        .multilineTextAlignment(.leading)
                )) {
                    isHelpPresented = false
                }
        }
    }
}

#Preview {
    NavigationView {
        HomeScreen()
            .environmentObject(CoreBluetoothViewModel())
    }
}
