//
//  ViewController.swift
//  iOS Assignment
//
//  Created by Swarandeep on 12/05/24.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var data: [ContentData]?
    let dataURL = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
    let cellReuseIdentifier = "CollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        fetchData(url: dataURL) { [weak self] (data: [ContentData]) in
            self?.data = data
            self?.collectionView.reloadData()
        }
    }
    
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CollectionViewCell {
            if let thumbnail = data?[indexPath.row].thumbnail, let domain = thumbnail.domain, let basePath = thumbnail.basePath, let key = thumbnail.key, let id = thumbnail.id {
                let imageURL = domain + "/" + basePath + "/0/" + key
                cell.setUpContent(imageURL: imageURL, id: id)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10
        return CGSize(width: width, height: width)
    }
}

