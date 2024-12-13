//
//  RootView.swift
//  MEP
//
//  Created by Nathan Getachew on 2/15/24.
//

import SwiftUI

extension UIApplication {
    static var hostingController: HostingController<AnyView>? = nil
    
    static var statusBarStyleHierarchy: [UIStatusBarStyle] = []
    static var statusBarStyle: UIStatusBarStyle = .darkContent
    
    ///Sets the App to start at rootView
    func setHostingController(rootView: AnyView) {
        let hostingController = HostingController(rootView: AnyView(rootView))
        windows.first?.rootViewController = hostingController
        UIApplication.hostingController = hostingController

    }
    
    static func setStatusBarStyle(_ style: UIStatusBarStyle) {
        statusBarStyle = style
        hostingController?.setNeedsStatusBarAppearanceUpdate()
    }
}

class HostingController<Content: View>: UIHostingController<Content> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.statusBarStyle
    }
    
}

///By wrapping views in a RootView, they will become the app's main / primary view. This will enable setting the statusBarStyle.
struct RootView<Content: View> : View {
    var content: Content
    
    init(@ViewBuilder content: () -> (Content)) {
        self.content = content()
    }
    
    var body:some View {
        EmptyView()
            .onAppear {
                UIApplication.shared.setHostingController(rootView: AnyView(content))
            }
    }
}
