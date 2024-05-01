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
    let universityLabel = USGSecondaryTitleLabel(fontSize: 14)
    let universityDetailView = UniversityDetailView()
    var didFavourite: Bool = false
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                expandCollapseImageView.image = UIImage(systemName: "minus")
                universityDetailView.isHidden = false
            } else {
                expandCollapseImageView.image = UIImage(systemName: "plus")
                universityDetailView.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        universityDetailView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(university: University) {
        self.university = university
        self.universityLabel.text = university.name
        universityDetailView.university = self.university
        self.universityDetailView.updateData(on: university)
        heartButton.setImage(UIImage(systemName: isUniversityFavorited(university) ? "heart.fill" : "heart"), for: .normal)
    }
    
    func configure() {
        expandCollapseImageView.translatesAutoresizingMaskIntoConstraints = false
        expandCollapseImageView.image = UIImage(systemName: "plus")
        expandCollapseImageView.tintColor = UIColor.systemGreen
        
        heartButton.tintColor = .systemGreen
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        universityDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(universityLabel)
        addSubview(expandCollapseImageView)
        addSubview(heartButton)
        addSubview(universityDetailView)
        
        layer.cornerRadius = 10
        backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            expandCollapseImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            expandCollapseImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            expandCollapseImageView.widthAnchor.constraint(equalToConstant: 20),
            expandCollapseImageView.heightAnchor.constraint(equalToConstant: 20),
            
            heartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            heartButton.centerYAnchor.constraint(equalTo: expandCollapseImageView.centerYAnchor),
            heartButton.heightAnchor.constraint(equalToConstant: 20),
            heartButton.widthAnchor.constraint(equalToConstant: 20),
            
            universityLabel.leadingAnchor.constraint(equalTo: expandCollapseImageView.trailingAnchor, constant: padding),
            universityLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -padding),
            universityLabel.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor),
            universityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            universityDetailView.topAnchor.constraint(equalTo: universityLabel.bottomAnchor),
            universityDetailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding), // Adjusted constraint
            universityDetailView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2*padding),
            universityDetailView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        universityDetailView.isHidden = true
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

extension ExpandableUniversityCell: UniversityDetailViewDelegate {
    func didTapWebsite(url: URL) {
        print("Bastim")
        if let homeVC = findViewController() as? HomeVC {
            homeVC.didTapWebsite(with: url)
            print("BASTIM2")
        }
    }
}

