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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .systemGreen
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
            universitelerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor) // Adjust the centerYAnchor
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .systemGreen
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: universitelerLabel.topAnchor)
        ])
    }
    
}
