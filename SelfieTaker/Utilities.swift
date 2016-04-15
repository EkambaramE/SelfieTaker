//
//  Utilities.swift
//  SelfieTaker
//
//  Created by Mariusz Wisniewski on 4/14/16.
//  Copyright © 2016 Mariusz Wisniewski. All rights reserved.
//

import Foundation
import UIKit

//utility class
class Utilities {
    class func getDeviceIdentifier() -> String {
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
}
