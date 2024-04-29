//
//  USGAlertVC.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 8.04.2024.
//

import UIKit

class USGAlertVC: UIViewController {
    
    let containerView = USGContainerView()
    let titleLabel = USGTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = USGBodyLabel(textAlignment: .center)
    let actionButton = USGButton(backgroundColor: .systemRed, title: "OK")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20.0
    
    init(alertTitle: String? = nil, message: String? = nil, buttonTitle: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

}
