//
//  CityListViC.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 9.04.2024.
//

import UIKit
//MARK: Burayi githubfollowers ve son cloneladigin repodan yap , sonrasinda cityCelldeki expandable icine universityVC olusturup koy , universityCell de olusturman lazim cloneladigin projeyle benzer
class CityListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var cities: [City] = []
    var page: Int = 1
    var hasMoreCities: Bool = true
    private let padding: CGFloat = 12
    var universityListVC = UniversityListVC()
    
    var collectionView: UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section, City>!
    var flowLayout: UICollectionViewFlowLayout!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureFlowLayout()
        configureCollectionView()
        configureViewController()
        configureDataSource()
        getCities(page: page)
        
        //        collectionView.layer.cornerRadius = 8
        //        collectionView.layer.borderColor = UIColor.systemGreen.cgColor
        //        collectionView.layer.borderWidth = 2
    }
    
    
    func configureViewController() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureFlowLayout() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: calculateAvailableWidth(), height: 30)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCityListCollectionViewFlowLayout(in: view))
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
            return cell
        })
    }
    
    private func updateData(on cities: [City]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, City>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cities)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func getCities(page: Int) {
        showLoadingView()
        NetworkManager.shared.getCities(page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let result):
                if result.currentPage >= result.totalPage { self.hasMoreCities = false }
                self.cities.append(contentsOf: result.data)
                self.updateData(on: cities)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func calculateAvailableWidth() -> CGFloat {
        let width = view.bounds.width
        let availableWidth = width - 64
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
            page += 1
            getCities(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! ExpandableCityCell
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            return true
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        dataSource.refresh()
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Trigger a layout update when an item is selected
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Trigger a layout update when an item is deselected
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
}

extension UICollectionViewDiffableDataSource {
    /// Reapplies the current snapshot to the data source, animating the differences.
    /// - Parameters:
    ///   - completion: A closure to be called on completion of reapplying the snapshot.
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
            let totalHeight = universityCellHeight + height
            print(city.universities.count)
            return CGSize(width: calculateAvailableWidth(), height: totalHeight)
        } else {
            return CGSize(width: calculateAvailableWidth(), height: height)
        }
    }
}





