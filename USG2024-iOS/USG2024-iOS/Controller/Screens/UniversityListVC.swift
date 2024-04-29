//
//  UniversityListVC.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 24.04.2024.
//

import UIKit

class UniversityListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    private let padding: CGFloat = 12
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, University>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
    }
    
    func configureViewController() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createUniversityListCollectionViewFlowLayout(in: view))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true 
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ExpandableUniversityCell.self, forCellWithReuseIdentifier: ExpandableUniversityCell.reuseID)
    }
    
     private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, University>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, university) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpandableUniversityCell.reuseID, for: indexPath) as! ExpandableUniversityCell
            cell.set(university: university)
            
            return cell
        })
    }
    
     func updateData(on universities: [University]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, University>()
        snapshot.appendSections([.main])
        snapshot.appendItems(universities)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}

extension UniversityListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! ExpandableUniversityCell
        
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            return true
        }
        dataSource.refresh()
        return false
    }
}

