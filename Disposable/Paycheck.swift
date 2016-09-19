//
//  Paycheck.swift
//  Disposable
//
//  Created by Laura Grayden on 16/09/2015.
//  Copyright (c) 2015 Lance Apps. All rights reserved.
//

import Foundation

class Paycheck: NSObject, NSCoding {
    
    var amount: Int
    var payFrequency: String
    var firstPayDate: NSDate
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("paycheck")
    
    struct PropertyKey {
        
        static let amountKey = "amount"
        static let payFrequencyKey = "payFrequency"
        static let firstPayDateKey = "firstPayDate"
    }
    
    override init() {
        
        self.amount = 0
        self.payFrequency = ""
        
        let dataString = "1 January, 1970" as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        self.firstPayDate = dateFormatter.dateFromString(dataString) as NSDate!
        
    }
    
    init(amount: Int, payFrequency: String, firstPayDate: NSDate)
    {

        self.amount = amount
        self.payFrequency = payFrequency
        self.firstPayDate = firstPayDate
        
        super.init()
        
    }
    
    func getAmountString() -> String
    {
        
        let string = "$" + String(amount)
        
        return string
    }
    
    // Data persistance
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeInteger(amount, forKey: PropertyKey.amountKey)
        aCoder.encodeObject(payFrequency, forKey: PropertyKey.payFrequencyKey)
        aCoder.encodeObject(firstPayDate, forKey: PropertyKey.firstPayDateKey)
        
    }

    required convenience init?(coder aDecoder: NSCoder) {
        
        let decodedAmount = aDecoder.decodeIntegerForKey(PropertyKey.amountKey)
        let decodedPayFrequency = aDecoder.decodeObjectForKey(PropertyKey.payFrequencyKey) as! String
        let decodedFirstPayDate = aDecoder.decodeObjectForKey(PropertyKey.firstPayDateKey) as! NSDate
        
        
        self.init(amount: decodedAmount, payFrequency: decodedPayFrequency, firstPayDate: decodedFirstPayDate)
    }
    
    
}