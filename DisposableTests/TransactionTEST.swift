//
//  TransactionTEST.swift
//  Disposable
//
//  Created by Laura Grayden on 31/10/2015.
//  Copyright © 2015 Lance Apps. All rights reserved.
//

import XCTest
@testable import Disposable

class TransactionTEST: XCTestCase {
    
    var oneOffTransaction: Transaction!
    var weeklyTransaction: Transaction!
    var fortnightlyTransaction: Transaction!
    var monthlyTransaction: Transaction!
    
    var startDate: NSDate!
    var dayBefore: NSDate!
    var dayAfter:  NSDate!
    var weekAfter: NSDate!
    var fortnightAfter: NSDate!
    var monthAfter: NSDate!
    
    override func setUp() {
        super.setUp()
        
        var dataString = "22 October, 2015" as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        startDate = dateFormatter.dateFromString(dataString) as NSDate!
        
        oneOffTransaction = Transaction(description: "One Off", amount: 100, occurance: Constants.ONE_OFF, startDate: startDate)
        
        weeklyTransaction = Transaction(description: "Weekly", amount: 100, occurance: Constants.WEEKLY, startDate: startDate)
        
        fortnightlyTransaction = Transaction(description: "Fortnightly", amount: 100, occurance: Constants.FORTNIGHTLY, startDate: startDate)
        
        monthlyTransaction = Transaction(description: "Monthly", amount: 100, occurance: Constants.MONTHLY, startDate: startDate)
        
        dataString = "21 October, 2015" as String
        dayBefore = dateFormatter.dateFromString(dataString) as NSDate!
        
        dataString = "23 October, 2015" as String
        dayAfter = dateFormatter.dateFromString(dataString) as NSDate!
        
        dataString = "29 October, 2015" as String
        weekAfter = dateFormatter.dateFromString(dataString) as NSDate!
        
        dataString = "5 November, 2015" as String
        fortnightAfter = dateFormatter.dateFromString(dataString) as NSDate!
        
        dataString = "22 November, 2015" as String
        monthAfter = dateFormatter.dateFromString(dataString) as NSDate!
    }
    
    func testOccursOnDateForOneOff() {
        
        var occurs = oneOffTransaction.occursOnDate(dayBefore)
        
        XCTAssert(!occurs)
        
        occurs = oneOffTransaction.occursOnDate(startDate)
        
        XCTAssert(occurs)
        
        occurs = oneOffTransaction.occursOnDate(dayAfter)
        
        XCTAssert(!occurs)
        
    }
    
    func testOccursOnDateForWeekly() {
        
        var occurs = weeklyTransaction.occursOnDate(dayBefore)
        
        XCTAssert(!occurs)
        
        occurs = weeklyTransaction.occursOnDate(startDate)
        
        XCTAssert(occurs)
        
        occurs = weeklyTransaction.occursOnDate(dayAfter)
        
        XCTAssert(!occurs)
        
        occurs = weeklyTransaction.occursOnDate(weekAfter)
        
        XCTAssert(occurs)
        
    }
    
    func testOccursOnDateForFortnightly() {
        
        var occurs = fortnightlyTransaction.occursOnDate(dayBefore)
        
        XCTAssert(!occurs)
        
        occurs = fortnightlyTransaction.occursOnDate(startDate)
        
        XCTAssert(occurs)
        
        occurs = fortnightlyTransaction.occursOnDate(dayAfter)
        
        XCTAssert(!occurs)
        
        occurs = fortnightlyTransaction.occursOnDate(weekAfter)
        
        XCTAssert(!occurs)
        
        occurs = fortnightlyTransaction.occursOnDate(fortnightAfter)
        
        XCTAssert(occurs)
        
    }
    
    func testOccursOnDateForMonthly() {
        
        var occurs = monthlyTransaction.occursOnDate(dayBefore)
        
        XCTAssert(!occurs)
        
        occurs = monthlyTransaction.occursOnDate(startDate)
        
        XCTAssert(occurs)
        
        occurs = monthlyTransaction.occursOnDate(dayAfter)
        
        XCTAssert(!occurs)
        
        occurs = monthlyTransaction.occursOnDate(weekAfter)
        
        XCTAssert(!occurs)
        
        occurs = monthlyTransaction.occursOnDate(fortnightAfter)
        
        XCTAssert(!occurs)
        
        occurs = monthlyTransaction.occursOnDate(monthAfter)
        
        XCTAssert(occurs)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
