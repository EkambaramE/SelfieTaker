//
//  CollectionViewCell.swift
//  SelfieTaker
//
//  Created by Mariusz Wisniewski on 4/14/16.
//  Copyright © 2016 Mariusz Wisniewski. All rights reserved.
//

import UIKit

//our custom cell
class CollectionViewCell: UICollectionViewCell {
    //outlet to image view in our custom cell
    @IBOutlet weak var imageView: UIImageView!
    
    //add activity indictor showing that image is being downloaded
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
