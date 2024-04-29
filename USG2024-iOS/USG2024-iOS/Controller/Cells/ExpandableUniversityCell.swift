//
//  ExpandableUniversityCell.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 25.04.2024.
//

import UIKit

class ExpandableUniversityCell: UICollectionViewCell {
    
    static let reuseID = "UniversityCell"
    let padding: CGFloat = 8
    var university: University? = nil
    let heartButton = UIButton()
    let expandCollapseImageView = UIImageView()
    let universityLabel = USGBodyLabel(textAlignment: .left)
    var didFavourite: Bool = false
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                expandCollapseImageView.image = UIImage(systemName: "minus")
            } else {
                expandCollapseImageView.image = UIImage(systemName: "plus")
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
    
    func set(university: University) {
        self.university = university
        self.universityLabel.text = university.name
        
        heartButton.setImage(UIImage(systemName: isUniversityFavorited(university) ? "heart.fill" : "heart"), for: .normal)
    }
    
    func configure() {
        expandCollapseImageView.translatesAutoresizingMaskIntoConstraints = false
        expandCollapseImageView.image = UIImage(systemName: "plus")
        expandCollapseImageView.tintColor = UIColor.systemGreen
        
        
        heartButton.tintColor = .systemGreen
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        heartButton.translatesAutoresizingMaskIntoConstraints = false

        
        addSubview(heartButton)
        addSubview(universityLabel)
        addSubview(expandCollapseImageView)
        
        layer.cornerRadius = 10
        backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            expandCollapseImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            expandCollapseImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            expandCollapseImageView.heightAnchor.constraint(equalToConstant: 20),
            expandCollapseImageView.widthAnchor.constraint(equalToConstant: 20),
            
            heartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            heartButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            heartButton.heightAnchor.constraint(equalToConstant: 20),
            heartButton.widthAnchor.constraint(equalToConstant: 20),
            
            universityLabel.leadingAnchor.constraint(equalTo: expandCollapseImageView.trailingAnchor, constant: padding),
            universityLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -padding),
            universityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            universityLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    

    
    @objc func heartButtonTapped() {
        if let university = university {
            didFavourite.toggle()
            if didFavourite {
                heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                do {
                    try UserDefaultsManager.shared.addUniversityToFavorites(university)
                } catch {
                    inputViewController?.presentGFAlertOnMainThread(title: "ASD", message: "ASD", buttonTitle: "ASD")
                }
            } else {
                heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
                UserDefaultsManager.shared.removeUniversityFromFavorites(university)
            }
        }
    }
    
    private func isUniversityFavorited(_ university: University) -> Bool {
        let favoriteUniversities = UserDefaultsManager.shared.loadFavoriteUniversities()
        return favoriteUniversities.contains(university)
    }
}
