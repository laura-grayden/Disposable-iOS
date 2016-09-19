//
//  FrequencySelectionViewController.swift
//  Disposable
//
//  Created by Laura Grayden on 14/11/2015.
//  Copyright © 2015 Lance Apps. All rights reserved.
//

import UIKit

class FrequencySelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    @IBOutlet weak var frequencyPicker: UIPickerView!

    var selectedFrequency: String!
    var options: [String]!
    
    var indexOfOneOff: Int!
    var indexOfWeekly: Int!
    var indexOfFortnightly: Int!
    var indexOfMonthly: Int!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if self.tabBarController != nil
        {
            self.tabBarController!.tabBar.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        super.viewDidAppear(animated)
        
        self.frequencyPicker.dataSource = self;
        self.frequencyPicker.delegate = self;
        
        indexOfOneOff = options.indexOf(Constants.ONE_OFF_FULL)
        indexOfWeekly = options.indexOf(Constants.WEEKLY_FULL)
        indexOfFortnightly = options.indexOf(Constants.FORTNIGHTLY_FULL)
        indexOfMonthly = options.indexOf(Constants.MONTHLY_FULL)
        
        if selectedFrequency ==  Constants.ONE_OFF
        {
            frequencyPicker.selectRow(indexOfOneOff!, inComponent: 0, animated: false)
        }
        else if selectedFrequency == Constants.WEEKLY
        {
            frequencyPicker.selectRow(indexOfWeekly!, inComponent: 0, animated: false)
        }
        else if selectedFrequency == Constants.FORTNIGHTLY
        {
            frequencyPicker.selectRow(indexOfFortnightly!, inComponent: 0, animated: false)
        }
        else if selectedFrequency == Constants.MONTHLY {
            
            frequencyPicker.selectRow(indexOfMonthly!, inComponent: 0, animated: false)
        }
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        navigationController!.popViewControllerAnimated(true)
        
    }
    
    // PICKER VIEW IMPLEMENTATION
    
    func numberOfComponentsInPickerView(frequencyPicker: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return options.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return options[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (indexOfOneOff != nil && row == indexOfOneOff)
        {
            selectedFrequency = Constants.ONE_OFF
        }
        else if(row == indexOfWeekly)
        {
            selectedFrequency = Constants.WEEKLY
        }
        else if(row == indexOfFortnightly)
        {
            selectedFrequency = Constants.FORTNIGHTLY
        }
        else if(row == indexOfMonthly)
        {
            selectedFrequency = Constants.MONTHLY
        }
        
    }

}

