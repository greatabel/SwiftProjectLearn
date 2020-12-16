//
//  MoviesCollectionViewCell.swift
//  b8310_movie
//
//  Created by abel on 2020/12/16.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
//    @IBOutlet var spinner: UIActivityIndicatorView!


    func update(with image: UIImage?) {
        if let imageToDisplay = image {
//            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
//            spinner.startAnimating()
            imageView.image = nil
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }

}
