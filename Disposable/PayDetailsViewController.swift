//
//  PayDetailsViewController.swift
//  Disposable
//
//  Created by Laura Grayden on 8/09/2015.
//  Copyright (c) 2015 Lance Apps. All rights reserved.
//


import UIKit


class PayDetailsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountTextLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var firstPaydateTextLabel: UILabel!
    @IBOutlet weak var firstPaydateValueText: UIButton!
    @IBOutlet weak var payFrequencyTextLabel: UILabel!
    @IBOutlet weak var payFrequencyValueText: UIButton!
    
    var pickerDataSource = [Constants.WEEKLY_FULL, Constants.FORTNIGHTLY_FULL, Constants.MONTHLY_FULL]
    var paycheck = Paycheck?()
    
    var goneToSelection: Bool!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        amountTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        amountTextLabel.layer.cornerRadius = 4
        amountTextLabel.layer.masksToBounds = true
        
        firstPaydateTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        firstPaydateTextLabel.layer.cornerRadius = 4
        firstPaydateTextLabel.layer.masksToBounds = true
        
        firstPaydateValueText.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        firstPaydateValueText.layer.cornerRadius = 4
        firstPaydateValueText.layer.masksToBounds = true
        
        payFrequencyTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        payFrequencyTextLabel.layer.cornerRadius = 4
        payFrequencyTextLabel.layer.masksToBounds = true
        
        payFrequencyValueText.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        payFrequencyValueText.layer.cornerRadius = 4
        payFrequencyValueText.layer.masksToBounds = true
        
        goneToSelection = false
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        super.viewWillAppear(animated)
        
        if self.tabBarController != nil
        {
            self.tabBarController!.tabBar.hidden = false
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PayDetailsViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let savedPayDetails = loadPayDetails()
        
        if savedPayDetails == nil
        {
            
            // Set default values for first time through
            
            if paycheck == nil
            {
                paycheck = Paycheck(amount: 0, payFrequency: Constants.WEEKLY, firstPayDate: NSDate())
            }
            
        }
        else
        {
            
            if paycheck == nil
            {
                paycheck = savedPayDetails
                
            }
            
        }
        
        amountTextField.text = String(paycheck!.amount)
        amountTextField.delegate = self
        
        setFirstPaydateText()
        setFrequencyText()
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if (!goneToSelection)
        {
            paycheck = nil
        }
        
        goneToSelection = false
        
    }
    
    override func didReceiveMemoryWarning()
    {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        var maxLength = 99
        
        if textField == amountTextField
        {
            maxLength = 8
        }
        
        let currentString: NSString = textField.text!
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
        
    // KEYBOARD IMPLEMENTATION
    
    func DismissKeyboard()
    {
        
        view.endEditing(true)
    }
    
    func setFirstPaydateText()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let buttonText = dateFormatter.stringFromDate((paycheck?.firstPayDate)!)
        
        firstPaydateValueText.setTitle(buttonText, forState: UIControlState.Normal)
    }
    
    func setFrequencyText()
    {
        var text = ""
        
        if paycheck?.payFrequency == Constants.WEEKLY
        {
            text = Constants.WEEKLY_FULL
        }
        else if paycheck?.payFrequency == Constants.FORTNIGHTLY
        {
            text = Constants.FORTNIGHTLY_FULL
        }
        else if paycheck?.payFrequency == Constants.MONTHLY
        {
            text = Constants.MONTHLY_FULL
        }
        
        payFrequencyValueText.setTitle(text, forState: UIControlState.Normal)
    }
    
    @IBAction func goToDateSelection(sender: UIButton)
    {
        goneToSelection = true
        performSegueWithIdentifier("ShowDateSelection", sender: self)
    }
    
    @IBAction func goToFrequencySelection(sender: UIButton)
    {
        goneToSelection = true
        performSegueWithIdentifier("ShowFrequencySelection", sender: self)
    }
    
    @IBAction func unwindToPayDetails(sender: UIStoryboardSegue)
    {
        
        if let sourceViewController = sender.sourceViewController as? DateSelectionViewController
        {
            paycheck?.firstPayDate = sourceViewController.datePicker.date
        
            setFirstPaydateText()
            
        }
        else if let sourceViewController = sender.sourceViewController as? FrequencySelectionViewController
        {
            paycheck?.payFrequency = sourceViewController.selectedFrequency
            
            setFrequencyText()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        paycheck?.amount = Int(amountTextField.text!)!
        
        if segue.identifier == "ShowDateSelection"
        {
            
            let dateSelectionViewController = segue.destinationViewController as! DateSelectionViewController
            
            dateSelectionViewController.selectedDate = paycheck?.firstPayDate
            
        }
        else if segue.identifier == "ShowFrequencySelection"
        {
            let frequencySelectionViewController = segue.destinationViewController as! FrequencySelectionViewController
            
            frequencySelectionViewController.options = pickerDataSource
            frequencySelectionViewController.selectedFrequency = paycheck?.payFrequency
        }
    }
    
    @IBAction func save(sender: UIBarButtonItem)
    {
        
        let amount = Int(amountTextField.text!) ?? 0
        
        if amount == 0 || !amountTextField.hasText() {
            
            let noAmountAlertController = UIAlertController(title: "Amount is required", message:
                "Please enter the pay amount.", preferredStyle: UIAlertControllerStyle.Alert)
            noAmountAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            
            noAmountAlertController.view.tintColor = Constants.ORANGE_COLOUR
            
            self.presentViewController(noAmountAlertController, animated: true, completion: nil)
        }
        else
        {
            let payFrequency = paycheck?.payFrequency
            let firstPaydate = paycheck?.firstPayDate
            
            paycheck = Paycheck(amount: amount, payFrequency: payFrequency!, firstPayDate: firstPaydate!)
            
            savePayDetails()
            
            tabBarController?.selectedIndex = Constants.SUMMARY_SCREEN_TAB_INDEX
        }

    }
    
    // Data persistance
    
    func savePayDetails() {
        
        NSKeyedArchiver.archiveRootObject(paycheck!, toFile: Paycheck.ArchiveURL!.path!)
    }
    
    func loadPayDetails() -> Paycheck?
    {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Paycheck.ArchiveURL!.path!) as? Paycheck
    }
    
}
