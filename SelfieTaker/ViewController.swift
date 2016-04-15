//
//  ViewController.swift
//  SelfieTaker
//
//  Created by Mariusz Wisniewski on 4/14/16.
//  Copyright © 2016 Mariusz Wisniewski. All rights reserved.
//

import UIKit

// UIViewController is the base class
// UIImagePickerControllerDelegate and UINavigationControllerDelegate are protocols - they define set of behaviors 
// that your class can or have to implement (methods/functions in protocol can be either required or optional)
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //@IBOutlet marks a variable that is connected to element of UI defined in Storyboard
    //it usually is created for you by XCode, when you use drag&drop from UI to code
    @IBOutlet weak var imageView: UIImageView!
    
    
    //this method is called once, when this view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //called when app received memory warning from the system
    //good place to get rid of not used variables that can take a lot of memory space, e.g. images
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //for example - get rid of our selfie image
        self.imageView.image = nil
    }

    //@IBAction - similar to @IBOutlet - but the connection here is between UI element and a function
    //it means that this function will be fired, when an action was taken on UI element, e.g. button was pressed
    @IBAction func takeSelfiePressed(sender: AnyObject) {
        //UIImagePickerController is a system controller that allows browsing images or taking new ones
        let imagePicker = UIImagePickerController()
        
        //defines what is the source of images - device's photo album, or camera
        imagePicker.sourceType = .SavedPhotosAlbum
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            //camera can be either .Front or .Rear
            imagePicker.cameraDevice = .Front
        }
        //should we allow editing photos after they were taken
        imagePicker.allowsEditing = false
        //do we want to capture photos or videos
        imagePicker.cameraCaptureMode = .Photo
        //which class will be notified when image is taken. `self` means class you're currently in
        imagePicker.delegate = self
        //call this method to present any view controller on screen - here, we show the image picker
        self.presentViewController(imagePicker, animated: true, completion: nil);
    }

    @IBAction func removeSelfiePressed(sender: AnyObject) {
        //after user pressed trash icon, we want to remove picture from the view
        self.imageView.image = nil
    }
    
    //this method is called, before transition defined in storyboard is performed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //we check the name of the transition
        if segue.identifier == "toCollectionView" {
            //we get the destination view controller - meaning the controller that will be shown on the screen next
            if let collectionViewController = segue.destinationViewController as? CollectionViewController {
                //we add a photo to the next view controller
               collectionViewController.photos = [Photo(name: "name", image: self.imageView.image)]
            }
        }
    }
}

// MARK: UIImagePickerControllerDelegate
//in this class extension we put methods defined in UIImagePickerControllerDelegate protocol
extension ViewController {
    //this method will be called every time image picker controller finishes picking new image (from album or camera)
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //we get the original image
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //we add taken picture to our image -- and show it on screen doing so
            imageView.image = pickedImage
        }
        //we hide image picker controller (image was taken, we don't need it anymore)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //called when user pressed cancel on image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //if user pressed cancel, we want to hide image picker from the screen
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

