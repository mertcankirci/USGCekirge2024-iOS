//
//  HomeVC.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 9.04.2024.
//

import UIKit
import UIKit

class HomeVC: UIViewController {
    
    let closeButton = UIButton(type: .system)
    let universitelerLabel = USGTitleLabel(textAlignment: .center, fontSize: 22)
    let heartButton = UIButton(type: .system)
    let cityListVC = CityListVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        embedCityListViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cityListVC = children.first as? CityListVC {
            cityListVC.dataSource.refresh()
            cityListVC.collectionView.reloadData()
        }
    }
    
    func configureNavigationBar() {
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .systemGreen
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        universitelerLabel.text = "ÜNİVERSİTELER"
        universitelerLabel.textColor = .systemGreen
        view.addSubview(universitelerLabel)
        NSLayoutConstraint.activate([
            universitelerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            universitelerLabel.topAnchor.constraint(equalTo: closeButton.topAnchor)
        ])
        
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .systemGreen
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heartButton)
        NSLayoutConstraint.activate([
            heartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            heartButton.topAnchor.constraint(equalTo: universitelerLabel.topAnchor)
        ])
    }
    
    func embedCityListViewController() {
        addChild(cityListVC)
        cityListVC.view.translatesAutoresizingMaskIntoConstraints = false
        cityListVC.delegate = self
        view.addSubview(cityListVC.view)
        
        NSLayoutConstraint.activate([
            cityListVC.view.topAnchor.constraint(equalTo: universitelerLabel.bottomAnchor, constant: 32),
            cityListVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            cityListVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            cityListVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        cityListVC.didMove(toParent: self)
    }
    
    @objc func closeButtonTapped() {
        if let cityListVC = children.first as? CityListVC {
            if let selectedIndexPaths = cityListVC.collectionView.indexPathsForSelectedItems {
                for indexPath in selectedIndexPaths {
                    cityListVC.collectionView.deselectItem(at: indexPath, animated: true)
                }
                cityListVC.dataSource.refresh()
            }
        }
    }

    @objc func heartButtonTapped() {
        let destinationVC = FavouritesListVC()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension HomeVC: CityListVCDelegate {
    func didTapWebsite(with url: URL) {
        presentSafariVC(with: url)
    }
    func didTapPhone(with url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
