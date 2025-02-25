//
//  CityListViC.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 9.04.2024.
//

import UIKit

protocol CityListVCDelegate: AnyObject {
    func didTapWebsite(with url: URL)
    func didTapPhone(with url: URL)
}

class CityListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var cities: [City] = []
    var hasMoreCities: Bool = true
    
    var collectionView: UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, City>!
    
    weak var delegate: CityListVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        configureViewController()
        configureDataSource()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in
            self.collectionView.collectionViewLayout = UIHelper.createCityListCollectionViewFlowLayout(in: self.view)
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func configureViewController() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCityListCollectionViewFlowLayout(in: view))
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
        collectionView.register(ExpandableCityCell.self, forCellWithReuseIdentifier: ExpandableCityCell.reuseID)
        collectionView.register(ExpandableUniversityCell.self, forCellWithReuseIdentifier: ExpandableUniversityCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, City>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, city) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpandableCityCell.reuseID, for: indexPath) as! ExpandableCityCell
            cell.set(city: city)
            cell.universityListVC.delegate = self
            return cell
        })
    }
    
    func updateData(on cities: [City]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, City>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cities)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func getCities() {
        showLoadingView()
        NetworkManager.shared.getCities() { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let result):
                if result.currentPage >= result.totalPage { self.hasMoreCities = false }
                self.cities.append(contentsOf: result.data)
                self.updateData(on: cities)
            case .failure(let error):
                self.presentUSGAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func calculateAvailableWidth() -> CGFloat {
        let width = view.bounds.width
        let availableWidth = width - 48
        return availableWidth
    }
    
}

extension CityListVC : UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offSetY > contentHeight - height {
            guard hasMoreCities else { return }
            NetworkManager.shared.page += 1
            getCities()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! ExpandableCityCell
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            dataSource.refresh()
            return true
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        dataSource.refresh()
        
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates {
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

extension UICollectionViewDiffableDataSource {
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}

extension CityListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let city = cities[indexPath.row]
        let height: CGFloat = 40
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        
        if isSelected {
            let universityCellHeight = CGFloat(city.universities.count) * 40
            var totalHeight = universityCellHeight + height
            if let cell = collectionView.cellForItem(at: indexPath) as? ExpandableCityCell {
                let universityListVC = cell.universityListVC
                if let selectedIndexPaths = universityListVC.collectionView.indexPathsForSelectedItems {
                    totalHeight += CGFloat(selectedIndexPaths.count * 200)
                }
            }
            
            return CGSize(width: calculateAvailableWidth(), height: totalHeight)
        } else {
            return CGSize(width: calculateAvailableWidth(), height: height)
        }
    }
}

extension CityListVC: UniversityListDelegate {
    func didTapPhone(with url: URL) {
        guard let delegate = delegate else { return }
        delegate.didTapPhone(with: url)
    }
    
    func resizeCell() {
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    func didTapWebsite(with url: URL) {
        guard let delegate = delegate else { return }
        delegate.didTapWebsite(with: url)
    }
}





