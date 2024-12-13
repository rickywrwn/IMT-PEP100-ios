//
//  FindViews.swift
//  MEP
//
//  Created by Nathan Getachew on 4/16/24.
//

import UIKit

extension UIView {
    func findViews<TargetView: UIView>(of type: TargetView.Type) -> [TargetView] {
        var foundViews = [TargetView]()
        for subview in subviews {
            if let subviewOfType = subview as? TargetView {
                foundViews.append(subviewOfType)
            }
            foundViews.append(contentsOf: subview.findViews(of: TargetView.self))
        }
        return foundViews
    }
}
