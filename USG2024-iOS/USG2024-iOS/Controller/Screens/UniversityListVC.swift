//
//  UniversityListVC.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 24.04.2024.
//

import UIKit

protocol UniversityListDelegate: AnyObject {
    func resizeCell()
    func didTapWebsite(with url: URL)
    func didTapPhone(with url: URL)
}

class UniversityListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    private let padding: CGFloat = 12
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, University>!
    weak var delegate: UniversityListDelegate?

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
        collectionView.showsVerticalScrollIndicator = false
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
            cell.universityDetailView.delegate = self
            return cell
        })
    }
    
     func updateData(on universities: [University]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, University>()
        snapshot.appendSections([.main])
        snapshot.appendItems(universities)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    private func calculateAvailableWidth() -> CGFloat {
        let width = view.bounds.width
        let availableWidth = width
        return availableWidth - 32
    }
}

extension UniversityListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! ExpandableUniversityCell
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            dataSource.refresh()
            delegate?.resizeCell()
            return true
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            delegate?.resizeCell()
        }
        dataSource.refresh()
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.collectionViewLayout.invalidateLayout()
        delegate?.resizeCell()
    }
}

extension UniversityListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 30
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        
        if isSelected {
            let universityCellHeight: CGFloat = 200
            let totalHeight = universityCellHeight + height
            
            return CGSize(width: calculateAvailableWidth(), height: totalHeight)
        } else {
            return CGSize(width: calculateAvailableWidth(), height: height)
        }
    }
}

extension UniversityListVC: UniversityDetailViewDelegate {
    func didTapPhone(url: URL) {
        guard let delegate = delegate else { return }
        delegate.didTapPhone(with: url)
    }
    
    func didTapWebsite(url: URL) {
        guard let delegate = delegate else { return }
        delegate.didTapWebsite(with: url)
    }
}

