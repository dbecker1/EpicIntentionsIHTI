//
//  Business.swift
//  HB141
//
//  Created by Daniel Becker on 2/9/17.
//  Copyright © 2017 International Human Trafficking Institute. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Business : NSObject {
    var businessName : String?
    var businessType : String?
    var businessAddress : String?
    var businessPhone : String?
    var businessWebsite : String?
    var location : CLLocationCoordinate2D?
    var placeID : String?
    // I know this violates the idea of separating model from view, but it simplifies things - Daniel
    var image : UIImage?
}
