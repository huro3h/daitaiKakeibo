//
//  AccountBook+CoreDataProperties.swift
//  daitaiKakeibo
//
//  Created by satoshiii on 2016/05/24.
//  Copyright © 2016年 satoshiii. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import FontAwesomeKit

extension AccountBook {

    @NSManaged var inputDate: Date?
    @NSManaged var foodFee: NSNumber?
    @NSManaged var lifeFee: NSNumber?
    @NSManaged var zappiFee: NSNumber?
    @NSManaged var hokaFee: NSNumber?
    @NSManaged var totalFee: NSNumber?

}
