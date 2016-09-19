//
//  UtilsTEST.swift
//  Disposable
//
//  Created by Laura Grayden on 8/11/2015.
//  Copyright © 2015 Lance Apps. All rights reserved.
//

import XCTest
@testable import Disposable

class UtilsTEST: XCTestCase {
    
    var baseDate: NSDate!
    
    override func setUp() {
        super.setUp()
        
        let dataString = "01-01-2015" as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        baseDate = dateFormatter.dateFromString(dataString) as NSDate!
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRemoveDateComponentEarlyInDay() {
        
        let dataString = "2015.01.01 00:00:01" as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        var testDate = dateFormatter.dateFromString(dataString) as NSDate!
        
        testDate = Util.removeTimeComponent(testDate)
        
        XCTAssertEqual(baseDate, testDate)
    }
    
    func testRemoveDateComponentLateInDay() {
        
        let dataString = "2015.01.01 23:00:01" as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        var testDate = dateFormatter.dateFromString(dataString) as NSDate!
        
        testDate = Util.removeTimeComponent(testDate)
        
        XCTAssertEqual(baseDate, testDate)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
