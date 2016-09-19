//
//  TransactionDetailsViewController.swift
//  Disposable
//
//  Created by Laura Grayden on 8/09/2015.
//  Copyright (c) 2015 Lance Apps. All rights reserved.
//

import UIKit

class TransactionDetailsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var amountTextLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var creditTextLabel: UILabel!
    @IBOutlet weak var creditSwitch: UISwitch!
    
    @IBOutlet weak var firstOccuranceTextLabel: UILabel!
    @IBOutlet weak var firstOccuranceValueText: UIButton!
    
    @IBOutlet weak var frequencyTextLabel: UILabel!
    @IBOutlet weak var frequencyValueText: UIButton!
    
    @IBOutlet weak var firstOccuranceDatePicker: UIDatePicker!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    
    var pickerDataSource = [Constants.ONE_OFF_FULL, Constants.WEEKLY_FULL, Constants.FORTNIGHTLY_FULL, Constants.MONTHLY_FULL]
    var transaction = Transaction?()
    var currentFrequencySelection: String!
    var selectedDate: NSDate!
    var creditSelection: Bool!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        descriptionTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        descriptionTextLabel.layer.cornerRadius = 4
        descriptionTextLabel.layer.masksToBounds = true
        
        amountTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        amountTextLabel.layer.cornerRadius = 4
        amountTextLabel.layer.masksToBounds = true
        
        creditTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        creditTextLabel.layer.cornerRadius = 4
        creditTextLabel.layer.masksToBounds = true
        
        firstOccuranceTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        firstOccuranceTextLabel.layer.cornerRadius = 4
        firstOccuranceTextLabel.layer.masksToBounds = true
        
        firstOccuranceValueText.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        firstOccuranceValueText.layer.cornerRadius = 4
        firstOccuranceValueText.layer.masksToBounds = true
        
        frequencyTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        frequencyTextLabel.layer.cornerRadius = 4
        frequencyTextLabel.layer.masksToBounds = true
        
        frequencyValueText.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        frequencyValueText.layer.cornerRadius = 4
        frequencyValueText.layer.masksToBounds = true

    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        super.viewWillAppear(animated)
        
        if self.tabBarController != nil
        {
            self.tabBarController!.tabBar.hidden = true
        }
        
        descriptionTextField.delegate = self
        amountTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TransactionDetailsViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let transaction = transaction
        {
            
            if descriptionTextField.text == ""
            {
                descriptionTextField.text = transaction.desc
            }
            
            if amountTextField.text == ""
            {
                amountTextField.text = String(transaction.amount)
            }
            
            if creditSelection == nil
            {
                creditSelection = transaction.credit
            }
            
            if selectedDate == nil
            {
                selectedDate = transaction.startDate
            }
            
            if currentFrequencySelection == nil
            {
                currentFrequencySelection = transaction.occurance
            }
            
        }
        else
        {
            if creditSelection == nil
            {
                creditSelection = false
            }
            
            if selectedDate == nil
            {
                selectedDate = NSDate()
            }
            
            if currentFrequencySelection == nil
            {
                currentFrequencySelection = Constants.ONE_OFF
            }
            
        }
        
        creditSwitch.setOn(creditSelection, animated: false)
        creditSwitch.addTarget(self, action: #selector(TransactionDetailsViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        setStartDateText()
        setFrequencyText()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func setStartDateText()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let buttonText = dateFormatter.stringFromDate(selectedDate)
        
        firstOccuranceValueText.setTitle(buttonText, forState: UIControlState.Normal)
    }
    
    func setFrequencyText()
    {
        var text = ""
        
        if currentFrequencySelection == Constants.ONE_OFF
        {
            text = Constants.ONE_OFF_FULL
        }
        else if currentFrequencySelection == Constants.WEEKLY
        {
            text = Constants.WEEKLY_FULL
        }
        else if currentFrequencySelection == Constants.FORTNIGHTLY
        {
            text = Constants.FORTNIGHTLY_FULL
        }
        else if currentFrequencySelection == Constants.MONTHLY
        {
            text = Constants.MONTHLY_FULL
        }
        
        frequencyValueText.setTitle(text, forState: UIControlState.Normal)
    }
    
    // KEYBOARD IMPLEMENTATION
    
    func DismissKeyboard()
    {
        
        view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        
        descriptionTextField.resignFirstResponder()
        
        return true;
    }
    
    // Switch implementation
    
    func switchChanged(mySwitch: UISwitch)
    {
        
        creditSelection = creditSwitch.on
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        var maxLength = 99
        
        if textField == descriptionTextField
        {
            maxLength = 13
        }
        else  if textField == amountTextField
        {
            maxLength = 5
        }

        let currentString: NSString = textField.text!
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    // NAVIGATION
    
    @IBAction func goToDateSelection(sender: UIButton)
    {

        performSegueWithIdentifier("ShowDateSelection", sender: self)
    }
    
    @IBAction func goToFrequencySelection(sender: UIButton)
    {

        performSegueWithIdentifier("ShowFrequencySelection", sender: self)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem)
    {
    
        let isPresentingInAddTransactionMode = presentingViewController != nil
        
        if isPresentingInAddTransactionMode
        {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            navigationController!.popViewControllerAnimated(true)
        }
    
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool
    {
        
        if saveButton === sender {
            
            if !descriptionTextField.hasText()
            {
                let noDescAlertController = UIAlertController(title: "Description is required", message:
                    "Please enter a description for the transaction.", preferredStyle: UIAlertControllerStyle.Alert)
                noDescAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                
                noDescAlertController.view.tintColor = Constants.ORANGE_COLOUR
                
                self.presentViewController(noDescAlertController, animated: true, completion: nil)
                
                return false
            }
            else if !amountTextField.hasText() || amountTextField.text == "0"
            {
                let noAmountAlertController = UIAlertController(title: "Amount is required", message:
                    "Please enter the transaction amount.", preferredStyle: UIAlertControllerStyle.Alert)
                noAmountAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                
                noAmountAlertController.view.tintColor = Constants.ORANGE_COLOUR
                
                self.presentViewController(noAmountAlertController, animated: true, completion: nil)
                
                return false
            }
            
        }
        
        return true
    }
    
    @IBAction func unwindToTransactionDetails(sender: UIStoryboardSegue)
    {
        
        if let sourceViewController = sender.sourceViewController as? DateSelectionViewController
        {
            selectedDate = sourceViewController.datePicker.date
            
            setStartDateText()
            
        }
        else if let sourceViewController = sender.sourceViewController as? FrequencySelectionViewController
        {
            currentFrequencySelection = sourceViewController.selectedFrequency
            
            setFrequencyText()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
    
        if saveButton === sender
        {
            
            let description = descriptionTextField.text ?? ""
            let amount = Int(amountTextField.text!) ?? 0
            let credit = creditSelection
            let startDate = selectedDate
            let occurance = currentFrequencySelection
            
            transaction = Transaction(description: description, amount: amount, credit: credit, occurance: occurance, startDate: startDate)
        
        }
        
        if segue.identifier == "ShowDateSelection"
        {
            
            let dateSelectionViewController = segue.destinationViewController as! DateSelectionViewController
            
            dateSelectionViewController.selectedDate = selectedDate
            
        }
        else if segue.identifier == "ShowFrequencySelection"
        {
            let frequencySelectionViewController = segue.destinationViewController as! FrequencySelectionViewController
            
            frequencySelectionViewController.options = pickerDataSource
            frequencySelectionViewController.selectedFrequency = currentFrequencySelection
        }
        
    }
    
}
