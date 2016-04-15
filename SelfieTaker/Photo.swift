//
//  Photo.swift
//  SelfieTaker
//
//  Created by Mariusz Wisniewski on 4/14/16.
//  Copyright © 2016 Mariusz Wisniewski. All rights reserved.
//

import Foundation
import UIKit
import syncano_ios

//class defining our Photo class
class Photo : SCDataObject {
    var name = ""
    var deviceId = ""
    var image : SCFile?
    var downloadedImage : UIImage?
    
    //custom init method - useful for quick creation of new objects of this type
    init(name: String, image: UIImage?) {
        self.name = name
        if image != nil {
            let data = UIImageJPEGRepresentation(image!, 0.5)
            self.image = SCFile(aData: data)
        }
        self.deviceId = Utilities.getDeviceIdentifier()
        super.init()
    }
    
    required init(dictionary dictionaryValue: [NSObject : AnyObject]!) throws {
        try super.init(dictionary: dictionaryValue)
    }
    
    required init!(coder: NSCoder!) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
    }
}
