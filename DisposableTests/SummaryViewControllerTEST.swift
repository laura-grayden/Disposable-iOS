//
//  SummaryViewControllerTEST.swift
//  Disposable
//
//  Created by Laura Grayden on 1/11/2015.
//  Copyright © 2015 Lance Apps. All rights reserved.
//

import XCTest
import UIKit
@testable import Disposable

class SummaryViewControllerTEST: XCTestCase {
    
    var view: SummaryViewController!
    
    var weeklyPay = Paycheck?()
    var fortnightlyPay = Paycheck?()
    var monthlyPay = Paycheck?()
    var transactionList = [Transaction]()
    
    var weeklyTransaction1: Transaction!
    var fortnightlyTransaction1: Transaction!
    var monthlyTransaction1: Transaction!
    var monthlyTransaction2: Transaction!
    
    var startDate: NSDate!
    var earlyInMonth: NSDate!
    var lateInMonth: NSDate!
    
    
    override func setUp() {
        super.setUp()
        
        var dataString = "1 October, 2015" as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        startDate = dateFormatter.dateFromString(dataString) as NSDate!
        
        dataString = "3 October, 2015" as String
        earlyInMonth = dateFormatter.dateFromString(dataString) as NSDate!
        
        dataString = "22 October, 2015" as String
        lateInMonth = dateFormatter.dateFromString(dataString) as NSDate!
        
        weeklyTransaction1 = Transaction(description: "Weekly", amount: 100, occurance: Constants.WEEKLY, startDate: startDate)
        
        transactionList.append(weeklyTransaction1)
        
        fortnightlyTransaction1 = Transaction(description: "Fortnightly", amount: 500, occurance: Constants.FORTNIGHTLY, startDate: startDate)
        
        transactionList.append(fortnightlyTransaction1)
        
        monthlyTransaction1 = Transaction(description: "Monthly", amount: 65, occurance: Constants.MONTHLY, startDate: earlyInMonth)
        
        transactionList.append(monthlyTransaction1)
        
        monthlyTransaction2 = Transaction(description: "Monthly", amount: 50, occurance: Constants.MONTHLY, startDate: lateInMonth)
        
        transactionList.append(monthlyTransaction2)

    }
    
    func testWeeklyPay() {

        weeklyPay = Paycheck(amount: 937, payFrequency: Constants.WEEKLY, firstPayDate: startDate)
        
        view = SummaryViewController(paycheck: weeklyPay!, transactions: transactionList, currentPayDate: startDate)
        
        // Income amount is correct
        
        XCTAssertEqual(view.getPaycheck().amount, 937)
        
        // Correct transactions retrieved for pay period
        
        XCTAssertEqual(view.getTransactionsInPayPeriod()?.count, 3)
        
        // Correct disposable income amount
        
        XCTAssertEqual(view.getDisposableIncomeAmount(), 272)
        
    }
    
    func testFortnightlyPay() {
        
        fortnightlyPay = Paycheck(amount: 1875, payFrequency: Constants.FORTNIGHTLY, firstPayDate: startDate)
        
        view = SummaryViewController(paycheck: fortnightlyPay!, transactions: transactionList, currentPayDate: startDate)
        
        // Income amount is correct
        
        XCTAssertEqual(view.getPaycheck().amount, 1875)
        
        // Correct transactions retrieved for pay period
        
        XCTAssertEqual(view.getTransactionsInPayPeriod()?.count, 4)
        
        // Correct disposable income amount
        
        XCTAssertEqual(view.getDisposableIncomeAmount(), 1110)
        
    }
    
    func testMonthlyPay() {
        
        monthlyPay = Paycheck(amount: 4000, payFrequency: Constants.MONTHLY, firstPayDate: startDate)
        
        view = SummaryViewController(paycheck: monthlyPay!, transactions: transactionList, currentPayDate: startDate)
        
        // Income amount is correct
        
        XCTAssertEqual(view.getPaycheck().amount, 4000)
        
        // Correct transactions retrieved for pay period
        
        XCTAssertEqual(view.getTransactionsInPayPeriod()?.count, 10)
        
        // Correct disposable income amount
        
        XCTAssertEqual(view.getDisposableIncomeAmount(), 1885)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
