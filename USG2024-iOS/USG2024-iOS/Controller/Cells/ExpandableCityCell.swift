//
//  ExpandableCityCell.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 9.04.2024.
//

import UIKit


class ExpandableCityCell: UICollectionViewCell {
    static let reuseID = "CityCell"
    let padding: CGFloat = 8
    var city: City? = nil
    let cityLabel = USGTitleLabel(textAlignment: .left, fontSize: 16)
    let expandCollapseImageView = UIImageView()
    let containerView = USGContainerView(frame: .zero)
    var universityListVC = UniversityListVC()
    
    override var isSelected: Bool {
        didSet {
            if city?.universities.count ?? 0 > 0  {
                if isSelected {
                    expandCollapseImageView.image = UIImage(systemName: "minus")
                    containerView.isHidden = false
                } else {
                    expandCollapseImageView.image = UIImage(systemName: "plus")
                    containerView.isHidden = true
                }
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(city: City) {
        self.city = city
        cityLabel.text = city.province
        universityListVC.updateData(on: city.universities)
    }
    
    private func configure() {
        expandCollapseImageView.translatesAutoresizingMaskIntoConstraints = false
        expandCollapseImageView.image = UIImage(systemName: "plus")
        expandCollapseImageView.tintColor = UIColor.systemGreen
        
        universityListVC.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(expandCollapseImageView)
        addSubview(cityLabel)
        addSubview(containerView)
        
        containerView.addSubview(universityListVC.view)
        
        NSLayoutConstraint.activate([
            expandCollapseImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            expandCollapseImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            expandCollapseImageView.widthAnchor.constraint(equalToConstant: 20),
            expandCollapseImageView.heightAnchor.constraint(equalToConstant: 20),
            
            cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            cityLabel.leadingAnchor.constraint(equalTo: expandCollapseImageView.trailingAnchor, constant: padding),
            cityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            containerView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: padding),
            containerView.leadingAnchor.constraint(equalTo: expandCollapseImageView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            universityListVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            universityListVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            universityListVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            universityListVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        containerView.isHidden = true
    }
    
}
