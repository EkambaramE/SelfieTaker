//
//  CollectionViewController.swift
//  SelfieTaker
//
//  Created by Mariusz Wisniewski on 4/14/16.
//  Copyright © 2016 Mariusz Wisniewski. All rights reserved.
//

import UIKit
import syncano_ios

private let reuseIdentifier = "Cell"

protocol SelectedPhotoDelegate {
    func userDidSelectPhoto(photo: UIImage)
}

class CollectionViewController: UICollectionViewController {
    
    //source of images we will show
    var photos : [Photo] = []
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    var delegate : SelectedPhotoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    
        // Do any additional setup after loading the view.
        self.activityIndicator.color = UIColor.blackColor()
        self.activityIndicator.hidesWhenStopped = true
        self.navigationItem.titleView = activityIndicator
    }
    
    //method used to download images from Syncano
    func reloadImagesFromSyncano() {
        
        //before we start downloading images, start loading indicator
        self.activityIndicator.startAnimating()
        
        //ask for photos from Syncano
        //every SCDataObject class (and subclasses) offers please() method - always use it to download objects
        //if you want to filter your objects, use please().giveMeDataObjectsWithPredicate
        //and SCPredicate.whereKey -- to define search criteria
        Photo.please().giveMeDataObjectsWithPredicate(SCPredicate.whereKey("deviceId", isEqualToString: Utilities.getDeviceIdentifier()), parameters: nil) { photos, error in
            
            //after photos were downlaoded, stop loading indicator
            self.activityIndicator.stopAnimating()
            
            //save downloaded photos list to memory
            if let photos = photos as? [Photo] {
                self.photos = photos
            }
            
            //reload our view with newly downloaded images
            self.collectionView?.reloadData()
        }
    }
    
    //called before this view appears on the screen
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //reload data before view is displayed
        self.reloadImagesFromSyncano()
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    //how many sections should our view have -- for simplicity, we use `1`
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //how many items are in a section - for simplicity and because we have only one section, we will use number of photos
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //user number of photos as number of items in section
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //get the cell that should be displayed
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        //cast the cell to our cell class type - CollectionViewCell
        if let cell = cell as? CollectionViewCell {
            //get current photo
            let photo = self.photos[indexPath.row]
            
            //check if we already downloaded current photo
            if let data = photo.image?.data {
                //if yes, we stop loading animation and we set the image on the cell view
                cell.activityIndicator.stopAnimating()
                cell.imageView.image = UIImage(data: data)
            } else if photo.image != nil {
                //if not, we start downloading photo from Syncano
                photo.image?.storeDataAfterFetch = true
                
                //start loading animation, so user knows what's going on
                cell.activityIndicator.startAnimating()
                
                //start download process
                photo.image?.fetchInBackgroundWithCompletion({ data, error in
                    
                    //after downloading image, stop loading indicator and set the image on a cell
                    cell.activityIndicator.stopAnimating()
                    if let data = data {
                        cell.imageView.image = UIImage(data: data)
                    }
                })
            }
        }
        //return configured cell
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    //add function that will be called when image was selected
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //get selected photo
        let photo = self.photos[indexPath.row]
        
        //if there is an image (already downloaded) pass it to delegate
        if let data = photo.image?.data {
            self.delegate?.userDidSelectPhoto(UIImage(data: data)!)
        }
    }
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}

