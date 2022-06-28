//
//  ImageListVC.swift
//  LabTest
//
//  Created by Wong Tian Haw on 26/06/2022.
//

import Foundation

import UIKit
import Combine

class ImageListVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var vm: ImageListVM = {
        return ImageListVM()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        bindVM()
        vm.apply(.list)
    }
    
    private func setupUI(){
        self.title = "List"
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.getNib(), forCellWithReuseIdentifier: ImageCell.identifier)
        
        self.collectionView.bindHeadRefreshHandler({ [weak self] in
            guard let `self` = self else { return }
            if !self.collectionView.headRefreshControl.isTriggeredRefreshByUser {
                self.vm.apply(.list)
            }
            
        }, themeColor: .gray, refreshStyle: .replicatorCircle)
        
        self.collectionView.bindFootRefreshHandler({ [weak self] in
            guard let `self` = self else { return }
            
            if !self.collectionView.footRefreshControl.isTriggeredRefreshByUser {
                
                self.vm.apply(.getMoreData)
            }
            
        }, themeColor: .gray, refreshStyle: .replicatorCircle)
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
                layout.minimumLineSpacing = 10
                layout.minimumInteritemSpacing = 10
                layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                let size = CGSize(width:(collectionView!.bounds.width-30)/2, height: 50)
                layout.itemSize = size
        }
    }
    
    private func bindVM(){
        
        self.vm.bindHeaderRefreshCtrl(self.collectionView.headRefreshControl)
        self.vm.bindFooterRefreshCtrl(self.collectionView.footRefreshControl)
        
        self.vm.$searchResultList
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] list in
                guard let `self` = self else { return }
                self.collectionView.reloadData()
            })
            .store(in: &self.cancellables)
    }
    
}

extension ImageListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.searchResultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell {
            cell.model = self.vm.searchResultList[indexPath.row]
            cell.imgAction = {
                let vc = ImageDetailVC(model: self.vm.searchResultList[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceBetweenCells: CGFloat = 1
        let cellwidth = (collectionView.bounds.width / 2.5) - spaceBetweenCells
        return CGSize(width: cellwidth, height: cellwidth)
    }
    
}
