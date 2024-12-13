//
//  ContentView.swift
//  MEP
//
//  Created by Nathan Getachew on 1/29/24.
//

import SwiftUI
import CoreData
import SwiftUIIntrospect




struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc
    @AppStorage(Strings.selectedLocale) var selectedLocale  = Locales.korean
    @StateObject private var navStore = NavigationStore()
    
    
    var body: some View {
        NavigationStack(path: $navStore.path) {
            HomeScreen()
                .navigationDestination(for: Screens.self) { screen in
                    switch screen {
                        //MARK: -
                    case .userRegistration:
                        UserRegistrationScreen()
                        //MARK: - Respiratory Measurement
                    case .respiratoryMeasurement:
                        RespiratoryMeasurementScreen()
                    case .respiratoryMeasurementResultsScreen(let id):
                        RespiratoryMeasurementResultsScreen(id: id)
                    case .respiratoryMeasurementResultsListScreen(let id):
                        RespiratoryMeasurementResultsListScreen(for: id)
                        //MARK: - Lung Measurement
                    case .lungMeasurement:
                        LungCapacityMeasurementScreen()
                    case .lungMeasurementResultsScreen(let id):
                        LungCapacityResultsScreen(id: id)
                    case .lungMeasurementResultsListScreen(let id):
                        LungCapacityResultsListScreen(for: id)
                        //MARK: -
                    case .chooseExercise:
                        ChooseExerciseScreen()
                        
                    case .strengthExerciseScreen:
                        if #available(iOS 17.0, *) {
                            ScrollingRespiratoryExerciseMeasurementScreen()
                        } else {
                            RespiratoryExerciseMeasurementScreen()
                        }
                    case .enduranceExerciseScreen:
                        EnduranceExerciseMeasurementScreen()
                    case .exerciseSettingsScreen(let type):
                        ExerciseSetupScreen(type: type)
                    case .exerciseResultsScreen(let id):
                        ExerciseResultsScreen(id: id)
                    case .exerciseResultsListScreen(let id):
                        ExercisesResultsListScreen(for: id)
                    }
                }
        }
        .environmentObject(navStore)
        //        .onAppear{
        //            UIApplication.statusBarStyleHierarchy.append(.lightContent)
        //            UIApplication.setStatusBarStyle(.lightContent)
        //        }
        .environment(\.locale, Locale(identifier: selectedLocale.identifier))
    }
}




#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

