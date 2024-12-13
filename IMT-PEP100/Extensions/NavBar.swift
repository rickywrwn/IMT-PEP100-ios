//
//  NavBar.swift
//  MEP
//
//  Created by Nathan Getachew on 1/31/24.
//


import SwiftUI
import SwiftUIIntrospect

extension View {
    func navBar(
        title: String,
        showHelp: Binding<Bool>? = nil,
        backgroundColor: Color = .accentColor,
        showBackButton: Bool = true ) -> some View {
            
            modifier(
                NavBarModifier(
                    title: title,
                    showHelp: showHelp,
                    backgroundColor: backgroundColor,
                    showBackButton: showBackButton)
            )
        }
}

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
        
    }
    
    
    
    static func customNavBarAppearance(with color : Color) -> UINavigationBarAppearance {
        let navBarAppearance = UINavigationBarAppearance()
        
        // Apply a  background.
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(color)
        
        // Remove bottom shadow.
        navBarAppearance.shadowColor = .clear
        
        // Apply white colored normal and large titles.
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.buttonAppearance = barButtonItemAppearance
        navBarAppearance.backButtonAppearance = barButtonItemAppearance
        navBarAppearance.doneButtonAppearance = barButtonItemAppearance
        
        //         custom back button with white color
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        navBarAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        return navBarAppearance
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


struct NavBarModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    let title: String
    let showHelp: Binding<Bool>?
    let backgroundColor: Color
    let showBackButton: Bool
    func body(content: Content) -> some View {
        content
        //            .navigationTitle(Text(LocalizedStringKey(title)))
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar{
                if showBackButton {
                    ToolbarItem(placement: .topBarLeading){
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .tint(.white)
                        }
                    }
                }
                ToolbarItem(placement: .principal){
                    HStack(spacing: 2){
                        Text(LocalizedStringKey(title))
                            .multilineTextAlignment(.center)
                        if let showHelp = showHelp {
                            Button {
                                showHelp.wrappedValue = true
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
                        }
                    }
                    
                }
            }
        //            .background(.white)
        
        
    }
}

