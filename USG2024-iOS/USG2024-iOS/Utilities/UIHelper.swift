//
//  UIHelper.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 24.04.2024.
//

import UIKit

struct UIHelper {
    
    static func createCityListCollectionViewFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let availableWidth = width - 64
        let itemWidth = availableWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 50)    
        return flowLayout
    }
    
    static func createUniversityListCollectionViewFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let availableWidth = (width - 10)
        let itemWidth = availableWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 30)
        
        return flowLayout
    }

}
