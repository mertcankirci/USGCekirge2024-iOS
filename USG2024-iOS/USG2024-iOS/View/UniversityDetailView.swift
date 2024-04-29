//
//  UniversityDetailView.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 29.04.2024.
//

import UIKit

class UniversityDetailView: UIView {
    
    // University bilgilerini tutacak değişken
    var university: University? {
        didSet {
            updateUI()
        }
    }
    

    private let phoneLabel = USGBodyLabel(textAlignment: .left)
    private let rectorLabel = USGBodyLabel(textAlignment: .left)
    private let emailLabel = USGBodyLabel(textAlignment: .left)
    private let faxLabel = USGBodyLabel(textAlignment: .left)
    private let websiteLabel = USGBodyLabel(textAlignment: .left)
    private let addressLabel = USGBodyLabel(textAlignment: .left)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUIView() {
        phoneLabel.text = university?.phone
        rectorLabel.text = university?.rector
        emailLabel.text = university?.email
        faxLabel.text = university?.fax
        websiteLabel.text = university?.name
        addressLabel.text = university?.adress
    }
    
    private func setupUI() {
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(phoneLabel)
        stackView.addArrangedSubview(rectorLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(faxLabel)
        stackView.addArrangedSubview(websiteLabel)
        stackView.addArrangedSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Telefon numarasına tıklama gesture'ı ekleme
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(callUniversity))
        phoneLabel.addGestureRecognizer(tapGesture)
    }
    
    // UI elemanlarını güncelleme
    private func updateUI() {
        phoneLabel.text = university?.phone
        rectorLabel.text = university?.rector
        emailLabel.text = university?.email
        faxLabel.text = university?.fax
        websiteLabel.text = university?.name
        addressLabel.text = university?.adress
    }
    
    
    @objc private func callUniversity() {
        guard let phoneNumber = university?.phone else { return }
        if let phoneURL = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
}

