//
//  CollectionViewCell.swift
//  test1
//
//  Created by Swarandeep on 11/05/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    var task: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.5
    }
    
    func setUpContent(imageURL: String, id: String) {
        imageView.image = nil
        task?.cancel()
        task = ImageClass.shared.fetchImage(url: imageURL, id: id) { [weak self] image in
            self?.imageView.image = image
        }
    }

}
