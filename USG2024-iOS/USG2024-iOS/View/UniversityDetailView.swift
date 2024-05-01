//
//  UniversityDetailView.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 29.04.2024.
//

import UIKit
import SafariServices

protocol UniversityDetailViewDelegate: AnyObject {
    func didTapWebsite(url: URL)
    func didTapPhone(url: URL)
}

class UniversityDetailView: UIView {
    
    var university: University? = nil
    let padding: CGFloat = 8.0
    
    var phoneLabel = USGFootnoteLabel(textAlignment: .left)
    var faxLabel = USGFootnoteLabel(textAlignment: .left)
    var websiteLabel = USGFootnoteLabel(textAlignment: .left)
    var emailLabel = USGFootnoteLabel(textAlignment: .left)
    var adressLabel = USGFootnoteLabel(textAlignment: .left)
    var rectorLabel = USGFootnoteLabel(textAlignment: .left)
    var stackView: UIStackView!
    
    weak var delegate: UniversityDetailViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure() {
        [
            self.phoneLabel,
            self.faxLabel,
            self.websiteLabel,
            self.emailLabel,
            self.adressLabel,
            self.rectorLabel,
        ].forEach({ stackView.addArrangedSubview($0) })
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
        
        let phoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneLabelTapped))
        phoneLabel.addGestureRecognizer(phoneTapGesture)
        phoneLabel.isUserInteractionEnabled = true
        
        let websiteTapGesture = UITapGestureRecognizer(target: self, action: #selector(websiteLabelTapped))
        websiteLabel.addGestureRecognizer(websiteTapGesture)
        websiteLabel.isUserInteractionEnabled = true
    }
    
    func updateData(on university: University?) {
        guard let university = university else { return }
        self.phoneLabel.text = "phone: \(String(describing: university.phone))"
        self.faxLabel.text = "fax: \(String(describing: university.fax))"
        self.websiteLabel.text = "website: \(String(describing: university.website))"
        self.emailLabel.text = "email: \(String(describing: university.email))"
        self.adressLabel.text = "address: \(String(describing: university.adress))"
        self.rectorLabel.text = "rector: \(String(describing: university.rector))"
    }
    
    @objc func phoneLabelTapped() {
        guard let phoneNumber = university?.phone, let url = URL(string: "tel://\(phoneNumber)") else { return }
        guard let delegate = delegate else { return }
        delegate.didTapPhone(url: url)
    }
    
    @objc func websiteLabelTapped() {
        guard let website = university?.website, let url = URL(string: website) else { return }
        guard let delegate = delegate else { return }
        delegate.didTapWebsite(url: url)
    }
}

