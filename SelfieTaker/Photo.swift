//
//  Photo.swift
//  SelfieTaker
//
//  Created by Mariusz Wisniewski on 4/14/16.
//  Copyright © 2016 Mariusz Wisniewski. All rights reserved.
//

import Foundation
import UIKit

//class defining our Photo class
class Photo {
    var name = ""
    var deviceId = ""
    var image : UIImage?
    
    //custom init method - useful for quick creation of new objects of this class
    init(name: String, image: UIImage?) {
        self.name = name;
        self.image = image
        self.deviceId = Utilities.getDeviceIdentifier()
    }
}
