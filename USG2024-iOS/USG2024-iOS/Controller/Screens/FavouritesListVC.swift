//
//  FavouritesListVC.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 8.04.2024.
//

import UIKit

class FavouritesListVC: UIViewController {
    
    let closeButton = UIButton(type: .system)
    let universitelerLabel = USGTitleLabel(textAlignment: .center, fontSize: 22)
    let universityListVC = UniversityListVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavigationBar()
        embedCityListViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in
            self.universityListVC.collectionView.collectionViewLayout = UIHelper.createUniversityListCollectionViewFlowLayout(in: self.universityListVC.view)
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigationBar() {
        universitelerLabel.text = "ÜNİVERSİTELER"
        universitelerLabel.textColor = .systemGreen
        view.addSubview(universitelerLabel)
        
        NSLayoutConstraint.activate([
            universitelerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            universitelerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .systemGreen
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: universitelerLabel.topAnchor)
        ])
    }
    
    func embedCityListViewController() {
        let favorites = UserDefaultsManager.shared.loadFavoriteUniversities()
        if favorites.isEmpty {
            showEmptyStateView(with: "Şu an henüz favori üniversiten yok. Hadi birkaç tane favorileyelim 😊!", in: self.view)
        } else {
            universityListVC.delegate = self
            universityListVC.updateData(on: UserDefaultsManager.shared.loadFavoriteUniversities())
            addChild(universityListVC)
            universityListVC.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(universityListVC.view)
            
            NSLayoutConstraint.activate([
                universityListVC.view.topAnchor.constraint(equalTo: universitelerLabel.bottomAnchor, constant: 32), // Adjust the top constraint according to your design
                universityListVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                universityListVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                universityListVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
            
            universityListVC.didMove(toParent: self)
        }
    }
    
    @objc func closeButtonTapped() {
        if let universityListVC = children.first as? UniversityListVC {
            if let selectedIndexPaths = universityListVC.collectionView.indexPathsForSelectedItems {
                for indexPath in selectedIndexPaths {
                    universityListVC.collectionView.deselectItem(at: indexPath, animated: true)
                }
                universityListVC.dataSource.refresh()
            }
        }
    }
    
}

extension FavouritesListVC: UniversityListDelegate {
    func didTapPhone(with url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func resizeCell() {
        universityListVC.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func didTapWebsite(with url: URL) {
        presentSafariVC(with: url)
    }
}
