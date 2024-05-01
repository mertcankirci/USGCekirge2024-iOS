//
//  UICollectionViewCell+Ext.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 1.05.2024.
//

import UIKit

extension UICollectionViewCell {
    func findViewController<T: UIViewController>() -> T? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? T {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}

