//
//  DateSelectionViewController.swift
//  Disposable
//
//  Created by Laura Grayden on 14/11/2015.
//  Copyright © 2015 Lance Apps. All rights reserved.
//

import UIKit

class DateSelectionViewController: UIViewController
{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedDate: NSDate!
    
    override func viewWillAppear(animated: Bool)
    {
        
        super.viewWillAppear(animated)
        
        if self.tabBarController != nil
        {
            self.tabBarController!.tabBar.hidden = true
        }
        
        datePicker.setDate(selectedDate, animated: false)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        super.viewDidAppear(animated)
        
        var minimumDate = NSDate()
        
        minimumDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Month,
            value: -1,
            toDate: minimumDate,
            options: NSCalendarOptions(rawValue: 0))!
        
        if selectedDate.compare(minimumDate) != NSComparisonResult.OrderedDescending
        {
            minimumDate = selectedDate
        }
        
        datePicker.minimumDate = minimumDate
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem)
    {
        
        navigationController!.popViewControllerAnimated(true)
        
    }
}
