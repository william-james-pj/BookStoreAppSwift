//
//  HomeViewController.swift
//  wspr
//
//  Created by Pinto Junior, William James on 14/01/22.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var collectionViewVertical: UICollectionView!
    @IBOutlet weak var collectionViewHorizontal: UICollectionView!
    
    // MARK: - Variables
    var categories: [Category] = []
    var books: [Book] = []
    fileprivate var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    // MARK: - Constantes
    let resuseIdentifier = "CollectionCell"
    let resuseIdentifierHorizontal = "CollectionCellHorizontal"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupData()
    }
    
    // MARK: - Setup
    fileprivate func setupData() {
        categories = viewModel.getCategories()
        books = viewModel.getBooks()
    }
    
    fileprivate func setupCollection() {
        self.collectionViewVertical.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: resuseIdentifier)
        self.collectionViewHorizontal.register(UINib(nibName: "HorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: resuseIdentifierHorizontal)
        
        collectionViewVertical.delegate = self
        collectionViewVertical.dataSource = self
        collectionViewHorizontal.delegate = self
        collectionViewHorizontal.dataSource = self
    }
    
    // MARK: - Methods
    fileprivate let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  collectionView == collectionViewVertical {
            return books.count
        }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewVertical {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifier, for: indexPath) as! CustomCollectionViewCell
            cell.configureCell(text: books[indexPath.row].title, price: books[indexPath.row].price)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifierHorizontal, for: indexPath) as! HorizontalCollectionViewCell
        cell.configureCell(text: categories[indexPath.row].title)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  collectionView == collectionViewVertical {
            let width = collectionView.bounds.width
            let numberOfItemsPerRow: CGFloat = 2
            let spacing: CGFloat = flowLayout.minimumInteritemSpacing
            let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
            let itemDimension = floor(availableWidth / numberOfItemsPerRow)
            return CGSize(width: itemDimension, height: itemDimension + 40)
        }
        return CGSize(width: 100, height: 50)
    }
}
