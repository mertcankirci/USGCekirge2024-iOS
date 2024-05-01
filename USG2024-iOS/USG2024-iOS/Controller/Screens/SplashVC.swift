//
//  SplashVC.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 1.05.2024.
//

import UIKit

class SplashVC: UIViewController {
    
    let imageView = UIImageView()
    let greetingLabel = USGTitleLabel(textAlignment: .center, fontSize: 24)
    let padding: CGFloat = 24

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
        greetingLabel.text = "USG-Challange 2024"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "university-logo")
        
        view.addSubview(greetingLabel)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            greetingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            greetingLabel.heightAnchor.constraint(equalToConstant: 2 * padding),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}
