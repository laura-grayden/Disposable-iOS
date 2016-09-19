//
//  Transaction.swift
//  Disposable
//
//  Created by Laura Grayden on 8/09/2015.
//  Copyright (c) 2015 Lance Apps. All rights reserved.
//

import Foundation

class Transaction: NSObject, NSCoding {
    
    var desc: String
    var amount: Int
    var occurance: String
    var startDate: NSDate
    var credit: Bool
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("transactions")
    
    struct PropertyKey {
    
        static let descKey = "desc"
        static let amountKey = "amount"
        static let creditKey = "credit"
        static let occuranceKey = "occurance"
        static let startDateKey = "startDate"
    
    }
    
    override init() {
        
        self.desc = ""
        self.amount = 0
        self.occurance = ""
        
        let dataString = "1 January, 1970" as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        self.startDate = dateFormatter.dateFromString(dataString) as NSDate!
        
        self.credit = false
        
    }
    
    init (description: String, amount: Int, occurance: String, startDate: NSDate)
    {
        
        self.desc = description
        self.amount = amount
        self.occurance = occurance
        self.startDate = startDate
        self.credit = false
        
        super.init()
        
    }
    
    init (description: String, amount: Int, credit: Bool, occurance: String, startDate: NSDate)
    {
        self.desc = description
        self.amount = amount
        self.occurance = occurance
        self.startDate = startDate
        self.credit = credit
        
        super.init()
    }
    
    func getAmountString() -> String
    {
        
        let string = "$" + String(amount)
        
        return string
    }
    
    func occursOnDate(date: NSDate) -> Bool
    {
        
        let dateToDate = Util.removeTimeComponent(date)
        
        if self.occurance == Constants.ONE_OFF
        {
            if dateToDate.isEqualToDate(Util.removeTimeComponent(self.startDate))
            {
                return true
            }
            else
            {
                return false
            }
        }
        else if self.occurance == Constants.WEEKLY
        {
            let transactionOccursDate = self.startDate
            
            var transactionOccursDateToDate = Util.removeTimeComponent(transactionOccursDate)
            
            while transactionOccursDateToDate.compare(dateToDate) != NSComparisonResult.OrderedDescending
            {
                if transactionOccursDateToDate.compare(dateToDate) == NSComparisonResult.OrderedSame
                {
                    return true
                }
                else if transactionOccursDateToDate.compare(dateToDate) != NSComparisonResult.OrderedDescending
                {
                    transactionOccursDateToDate = NSCalendar.currentCalendar().dateByAddingUnit(
                        .Day,
                        value: 7,
                        toDate: transactionOccursDateToDate,
                        options: NSCalendarOptions(rawValue: 0))!
                }
                else
                {
                    return false
                }
            }
        }
        else if self.occurance == Constants.FORTNIGHTLY
        {
            let transactionOccursDate = self.startDate
            
            var transactionOccursDateToDate = Util.removeTimeComponent(transactionOccursDate)
            
            while transactionOccursDateToDate.compare(dateToDate) != NSComparisonResult.OrderedDescending
            {
                if transactionOccursDateToDate.isEqualToDate(dateToDate)
                {
                    return true
                }
                else if transactionOccursDateToDate.compare(date) != NSComparisonResult.OrderedDescending
                {
                    transactionOccursDateToDate = NSCalendar.currentCalendar().dateByAddingUnit(
                        .Day,
                        value: 14,
                        toDate: transactionOccursDateToDate,
                        options: NSCalendarOptions(rawValue: 0))!
                }
                else
                {
                    return false
                }
            }
        }
        else if self.occurance == Constants.MONTHLY
        {
            let transactionOccursDate = self.startDate
            
            var numberOfMonths = 1
            
            var transactionOccursDateToDate = Util.removeTimeComponent(transactionOccursDate)
            
            while transactionOccursDateToDate.compare(dateToDate) != NSComparisonResult.OrderedDescending
            {
                if transactionOccursDateToDate.compare(dateToDate) == NSComparisonResult.OrderedSame
                {
                    return true
                }
                else if transactionOccursDateToDate.compare(dateToDate) != NSComparisonResult.OrderedDescending
                {
                    transactionOccursDateToDate = NSCalendar.currentCalendar().dateByAddingUnit(
                        .Month,
                        value: numberOfMonths,
                        toDate: Util.removeTimeComponent(self.startDate),
                        options: NSCalendarOptions(rawValue: 0))!
                    
                    numberOfMonths += 1
                }
                else
                {
                    return false
                }
            }
        }
        
        return false
        
    }
    
    // Data persistance
    
    func encodeWithCoder(aCoder: NSCoder) {
    
        aCoder.encodeObject(desc, forKey: PropertyKey.descKey)
        aCoder.encodeInteger(amount, forKey: PropertyKey.amountKey)
        aCoder.encodeBool(credit, forKey: PropertyKey.creditKey)
        aCoder.encodeObject(occurance, forKey: PropertyKey.occuranceKey)
        aCoder.encodeObject(startDate, forKey: PropertyKey.startDateKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
    
        let decodedDesc = aDecoder.decodeObjectForKey(PropertyKey.descKey) as! String
        let decodedAmount = aDecoder.decodeIntegerForKey(PropertyKey.amountKey)
        let decodedCredit = aDecoder.decodeBoolForKey(PropertyKey.creditKey)
        let decodedOccurance = aDecoder.decodeObjectForKey(PropertyKey.occuranceKey) as! String
        let decodedStartDate = aDecoder.decodeObjectForKey(PropertyKey.startDateKey) as! NSDate
    
        
        self.init(description: decodedDesc, amount: decodedAmount, credit: decodedCredit, occurance: decodedOccurance, startDate: decodedStartDate)
    }

}
