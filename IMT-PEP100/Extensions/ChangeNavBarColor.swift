//
//  ChangeNavBarColor.swift
//  MEP
//
//  Created by Nathan Getachew on 2/14/24.
//


import SwiftUI
import SwiftUIIntrospect

extension View {
    func changeNavBarColor(to color: Color) -> some View {
        modifier(ChangeNavBarColorModifier(color: color))
    }
}



struct ChangeNavBarColorModifier: ViewModifier {
    let color : Color
    func body(content: Content) -> some View {
        
        content
#if os(iOS)
            .introspect(.navigationView(style: .stack), on: .iOS( .v16, .v17)) { navigationController in
                
                let navBarAppearance = UINavigationController.customNavBarAppearance(with: color)
                navigationController.navigationBar.standardAppearance = navBarAppearance
                navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
                navigationController.navigationBar.compactAppearance = navBarAppearance
                navigationController.navigationBar.compactScrollEdgeAppearance = navBarAppearance
            }
#endif
    }
}
