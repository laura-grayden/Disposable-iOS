//
//  SummaryViewController.swift
//  Disposable
//
//  Created by Laura Grayden on 8/09/2015.
//  Copyright (c) 2015 Lance Apps. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var currentPaydateLabel: UILabel!
    @IBOutlet weak var incomeTextLabel: UILabel!
    @IBOutlet weak var incomeAmountLabel: UILabel!
    
    @IBOutlet weak var expenseTextLabel: UILabel!
    @IBOutlet weak var expenseDateTextView: UITextView!
    @IBOutlet weak var expenseDescTextView: UITextView!
    @IBOutlet weak var expenseAmountTextView: UITextView!
    
    @IBOutlet weak var disposableIncomeTextLabel: UILabel!
    @IBOutlet weak var disposableIncomeAmountLabel: UILabel!
    
    @IBOutlet weak var nextPaydateButton: UIButton!
    @IBOutlet weak var previousPaydateButton: UIButton!
    
    var paycheck = Paycheck?()
    var transactions = [Transaction]()
    
    var currentPaydate: NSDate?
    var initialPaydate: NSDate?
    
    var monthsFromInitial: Int?
    
    override func viewDidLoad()
    {
        // configure static fields that won't change
        
        currentPaydateLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        currentPaydateLabel.layer.cornerRadius = 8
        currentPaydateLabel.layer.masksToBounds = true
        
        nextPaydateButton.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        nextPaydateButton.layer.cornerRadius = 8
        nextPaydateButton.layer.masksToBounds = true
        
        previousPaydateButton.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        previousPaydateButton.layer.cornerRadius = 8
        previousPaydateButton.layer.masksToBounds = true
        
        incomeTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        incomeTextLabel.layer.cornerRadius = 4
        incomeTextLabel.layer.masksToBounds = true
        
        incomeAmountLabel.backgroundColor = Constants.GREEN_COLOUR
        incomeAmountLabel.layer.cornerRadius = 4
        incomeAmountLabel.layer.masksToBounds = true
        
        expenseTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        expenseTextLabel.layer.cornerRadius = 4
        expenseTextLabel.layer.masksToBounds = true
        
        expenseDateTextView.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        expenseDateTextView.layer.cornerRadius = 8
        expenseDateTextView.layer.masksToBounds = true
        
        expenseDescTextView.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        expenseDescTextView.layer.cornerRadius = 8
        expenseDescTextView.layer.masksToBounds = true
        
        expenseAmountTextView.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        expenseAmountTextView.layer.cornerRadius = 8
        expenseAmountTextView.layer.masksToBounds = true
        
        disposableIncomeTextLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        disposableIncomeTextLabel.layer.cornerRadius = 4
        disposableIncomeTextLabel.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        super.viewWillAppear(animated)
        
        if self.tabBarController != nil
        {
            self.tabBarController!.tabBar.hidden = false
        }
        
        // retrieve paycheck details
        
        let savedPayDetails = loadPayDetails()
        
        if savedPayDetails != nil
        {

            let paycheckUpdated = (paycheck?.amount != savedPayDetails?.amount ||
                                   paycheck?.firstPayDate != savedPayDetails?.firstPayDate ||
                                   paycheck?.payFrequency != savedPayDetails?.payFrequency)
            
            paycheck = savedPayDetails
            
            if currentPaydate == nil || paycheckUpdated
            {
                previousPaydateButton.hidden = true
                currentPaydate = calculateCurrentPaydate(savedPayDetails!.firstPayDate, payFrequency: savedPayDetails!.payFrequency)
                initialPaydate = Util.removeTimeComponent(currentPaydate!)
                
                monthsFromInitial = 0
            }
            
            setUpPaydateLabel()
            incomeAmountLabel.text = "+$" + String(paycheck!.amount)
            
            // retrieve transaction details
            
            if let savedTransactions = loadTransactions()
            {
                
                transactions.removeAll()
                
                transactions = savedTransactions
            }
            
            if transactions.count == 0
            {
                setupDisposableIncomeLabel(transactions)
                setupExpenseTextFields(transactions)
            }
            else
            {
                // set up expenses text fields
                
                if let transactionsForPayPeriod = getTransactionsInPayPeriod()
                {
                    
                    if transactionsForPayPeriod.count > 0
                    {
                        
                        setupExpenseTextFields(transactionsForPayPeriod)
                        setupDisposableIncomeLabel(transactionsForPayPeriod)
                        
                    }
                }
            }
            
        }
        
        (self.expenseDateTextView as UIScrollView).delegate = self;
        (self.expenseDescTextView as UIScrollView).delegate = self;
        (self.expenseAmountTextView as UIScrollView).delegate = self;
    
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if paycheck == nil
        {
            
            // If no paycheck details recorded, navigate to Pay tab
            
            let noPayDetailsAlertController = UIAlertController(title: "Income details required", message:
                "Please enter your income details on the Pay Details page.", preferredStyle: UIAlertControllerStyle.Alert)
            
            noPayDetailsAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: navigateToPayDetails))
            
            self.presentViewController(noPayDetailsAlertController, animated: true, completion: nil)
            
            noPayDetailsAlertController.view.tintColor = Constants.ORANGE_COLOUR
            
        }
        else
        {
            if transactions.count == 0
            {
                let noTransactionsAlertController = UIAlertController(title: "No transactions recorded", message:
                    "Transaction details can be recorded on the Transactions page.", preferredStyle: UIAlertControllerStyle.Alert)
                
                noTransactionsAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                
                noTransactionsAlertController.view.tintColor = Constants.ORANGE_COLOUR
                
                self.presentViewController(noTransactionsAlertController, animated: true, completion: nil)
                
            }

            expenseDescTextView.setContentOffset(CGPointZero, animated: false)
            expenseDateTextView.setContentOffset(CGPointZero, animated: false)
            expenseAmountTextView.setContentOffset(CGPointZero, animated: false)

        }
    }
    
    func navigateToPayDetails(alertView: UIAlertAction!)
    {
        tabBarController?.selectedIndex = Constants.PAY_DETAILS_TAB_INDEX
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func previousPaydateButtonPressed(sender: AnyObject) {
        
        if paycheck?.payFrequency == Constants.WEEKLY
        {
            currentPaydate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: -7,
                toDate: currentPaydate!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        else if paycheck?.payFrequency == Constants.FORTNIGHTLY
        {
            currentPaydate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: -14,
                toDate: currentPaydate!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        else if paycheck?.payFrequency == Constants.MONTHLY
        {
            monthsFromInitial = monthsFromInitial! - 1
            
            currentPaydate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Month,
                value: monthsFromInitial!,
                toDate: initialPaydate!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        
        setUpPaydateLabel()
        
        if transactions.count > 0 {
            
            if let transactionsForPayPeriod = getTransactionsInPayPeriod() {
                
                if transactionsForPayPeriod.count > 0 {
                    
                    setupExpenseTextFields(transactionsForPayPeriod)
                    setupDisposableIncomeLabel(transactionsForPayPeriod)
                    
                }
            }
        }
        
        if initialPaydate?.compare(Util.removeTimeComponent(currentPaydate!)) == NSComparisonResult.OrderedSame
        {
            previousPaydateButton.hidden = true
        }

    }
    
    @IBAction func nextPaydateButtonPressed(sender: AnyObject) {
        
        if paycheck?.payFrequency == Constants.WEEKLY
        {
            currentPaydate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: 7,
                toDate: currentPaydate!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        else if paycheck?.payFrequency == Constants.FORTNIGHTLY
        {
            currentPaydate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: 14,
                toDate: currentPaydate!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        else if paycheck?.payFrequency == Constants.MONTHLY
        {
            monthsFromInitial = monthsFromInitial! + 1
            
            currentPaydate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Month,
                value: monthsFromInitial!,
                toDate: initialPaydate!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        
        setUpPaydateLabel()
        
        if transactions.count > 0 {
            
            if let transactionsForPayPeriod = getTransactionsInPayPeriod() {
                
                if transactionsForPayPeriod.count > 0
                {
                    
                    setupExpenseTextFields(transactionsForPayPeriod)
                    setupDisposableIncomeLabel(transactionsForPayPeriod)
                    
                }
            }
            
        }
        
        previousPaydateButton.hidden = false

    }
    
    func loadPayDetails() -> Paycheck? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Paycheck.ArchiveURL!.path!) as? Paycheck
    }
    
    func loadTransactions() -> [Transaction]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Transaction.ArchiveURL!.path!) as? [Transaction]
    }
    
    func setUpPaydateLabel() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        currentPaydateLabel.text = dateFormatter.stringFromDate(currentPaydate!)
        
    }
    
    func setupExpenseTextFields(transactions: [Transaction]) {
        
        expenseDateTextView.scrollEnabled = false
        expenseDescTextView.scrollEnabled = false
        expenseAmountTextView.scrollEnabled = false
        
        var dateViewString: String = ""
        var descViewString: String = ""
        let amountViewString = NSMutableAttributedString(string: "")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        for transaction in transactions
        {
            if dateViewString == ""
            {
                dateViewString = dateFormatter.stringFromDate(transaction.startDate) + "\n"
                descViewString = transaction.desc + "\n"

            }
            else
            {
                dateViewString = dateViewString + dateFormatter.stringFromDate(transaction.startDate) + "\n"
                descViewString = descViewString + transaction.desc + "\n"
            }
            
            var amountString: NSString
            var tempAttributedString: NSMutableAttributedString
            
            if transaction.credit
            {
                amountString = "+" + transaction.getAmountString() + "\n"
                
                let range = NSRange(location: 0,length: amountString.length)
                
                tempAttributedString = NSMutableAttributedString(string: amountString as String)
                tempAttributedString.addAttribute(NSForegroundColorAttributeName, value: Constants.GREEN_COLOUR, range: range)
            }
            else
            {
                amountString = "-" + transaction.getAmountString() + "\n"
                
                let range = NSRange(location: 0,length: amountString.length)
                
                tempAttributedString = NSMutableAttributedString(string: amountString as String)
                tempAttributedString.addAttribute(NSForegroundColorAttributeName, value: Constants.RED_COLOUR, range: range)
            }
            
            let range = NSRange(location: 0,length: amountString.length)
            
            tempAttributedString.addAttribute(NSFontAttributeName, value: Constants.SUMMARY_FONT!, range: range)
            
            amountViewString.appendAttributedString(tempAttributedString)
        }
        
        expenseDateTextView.text = dateViewString
        expenseDescTextView.text = descViewString
        expenseAmountTextView.attributedText = amountViewString
        
        expenseDateTextView.scrollEnabled = true
        expenseDescTextView.scrollEnabled = true
        expenseAmountTextView.scrollEnabled = true
        
        // configure display
        
        expenseAmountTextView.textAlignment = NSTextAlignment.Right
        
    }
    
    // If one transcations list view is scrolled, ensure all three are kept coordinated
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView == expenseDateTextView
        {
            expenseDescTextView.setContentOffset(expenseDateTextView.contentOffset, animated: false)
            expenseAmountTextView.setContentOffset(expenseDateTextView.contentOffset, animated: false)
        }
        else if scrollView == expenseDescTextView
        {
            expenseDateTextView.setContentOffset(expenseDescTextView.contentOffset, animated: false)
            expenseAmountTextView.setContentOffset(expenseDescTextView.contentOffset, animated: false)
        }
        else if scrollView == expenseAmountTextView
        {
            expenseDescTextView.setContentOffset(expenseAmountTextView.contentOffset, animated: false)
            expenseDateTextView.setContentOffset(expenseAmountTextView.contentOffset, animated: false)
        }
    }
    
    func setupDisposableIncomeLabel(transactions: [Transaction]) {
        
        var disposableTotal = getDisposableIncomeAmount()
        
        var labelPrefix: String = ""
        
        if disposableTotal > 0
        {
            labelPrefix = "+$"
            disposableIncomeAmountLabel.backgroundColor = Constants.GREEN_COLOUR
        }
        else if disposableTotal == 0
        {
            labelPrefix = "$"
            disposableIncomeAmountLabel.backgroundColor = Constants.ORANGE_COLOUR_WITH_ALPHA
        }
        else
        {
            labelPrefix = "-$"
            disposableTotal = disposableTotal * -1
            disposableIncomeAmountLabel.backgroundColor = Constants.RED_COLOUR
        }
        
        disposableIncomeAmountLabel.text = labelPrefix + String(disposableTotal)
        
        disposableIncomeAmountLabel.layer.cornerRadius = 4
        disposableIncomeAmountLabel.layer.masksToBounds = true
        
    }
    
    func getDisposableIncomeAmount() -> Int {
        
        var disposableTotal = paycheck?.amount
        
        disposableTotal = disposableTotal! - sumTransactionsInPayPeriod(getTransactionsInPayPeriod()!)
        
        return disposableTotal!
    }
    
    func sumTransactionsInPayPeriod(transactions: [Transaction]) -> Int {
        
        var total = 0
        
        for transaction in transactions
        {
            if transaction.credit
            {
                total = total - transaction.amount
            }
            else
            {
                total = total + transaction.amount
            }
            
        }
        
        return total
        
    }
    
    func getTransactionsInPayPeriod() -> [Transaction]? {
        
        let payPeriodStartDate = currentPaydate
        var payPeriodEndDate: NSDate?
        
        var transactionsInPayPeriod = [Transaction]()
        
        if paycheck?.payFrequency == Constants.WEEKLY
        {
                payPeriodEndDate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: 6,
                toDate: payPeriodStartDate!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        else if paycheck?.payFrequency == Constants.FORTNIGHTLY
        {
                payPeriodEndDate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: 13,
                toDate: payPeriodStartDate!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        else if paycheck?.payFrequency == Constants.MONTHLY
        {
                payPeriodEndDate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Month,
                value: 1,
                toDate: payPeriodStartDate!,
                options: NSCalendarOptions(rawValue: 0))!
            
                payPeriodEndDate = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: -1,
                toDate: payPeriodEndDate!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        
        var date = payPeriodStartDate
        
        while date?.compare(payPeriodEndDate!) != NSComparisonResult.OrderedDescending
        {
            for transaction in transactions
            {
                // Ignore One-off transactions that have passed their date
                
                if (!(transaction.occurance == Constants.ONE_OFF && transaction.startDate.compare(currentPaydate!) == NSComparisonResult.OrderedAscending))
                {
                    if transaction.occursOnDate(date!)
                    {
                        let transactionInRange = Transaction(description: transaction.desc, amount: transaction.amount, credit: transaction.credit, occurance: transaction.occurance, startDate: date!)
                        
                        transactionsInPayPeriod.append(transactionInRange)
                    }
                }
            }
            
            if date!.compare(payPeriodEndDate!) == NSComparisonResult.OrderedSame
            {
                return transactionsInPayPeriod
            }
            
            date = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: 1,
                toDate: date!,
                options: NSCalendarOptions(rawValue: 0))!
        }
        
        return transactionsInPayPeriod
        
    }
    
    func calculateCurrentPaydate(firstPaydate: NSDate, payFrequency: String) -> NSDate
    {
        let currentSystemDate = NSDate()
        var currentPayDate = firstPaydate
        
        var nextPayDate: NSDate?
        
        var numberOfMonths = 1
        
        while currentPayDate.compare(currentSystemDate) != NSComparisonResult.OrderedDescending
        {

            if payFrequency == Constants.WEEKLY
            {
                nextPayDate = NSCalendar.currentCalendar().dateByAddingUnit(
                    .Day,
                    value: 7,
                    toDate: currentPayDate,
                    options: NSCalendarOptions(rawValue: 0))
            }
            else if payFrequency == Constants.FORTNIGHTLY
            {
                nextPayDate = NSCalendar.currentCalendar().dateByAddingUnit(
                    .Day,
                    value: 14,
                    toDate: currentPayDate,
                    options: NSCalendarOptions(rawValue: 0))
            }
            else if payFrequency == Constants.MONTHLY
            {
                nextPayDate = NSCalendar.currentCalendar().dateByAddingUnit(
                    .Month,
                    value: numberOfMonths,
                    toDate: firstPaydate,
                    options: NSCalendarOptions(rawValue: 0))
                
                numberOfMonths += 1
            }
            
            if nextPayDate!.compare(currentSystemDate) != NSComparisonResult.OrderedDescending
            {
                currentPayDate = nextPayDate!
            }
            else
            {
                return currentPayDate
            }
        }
        
        return currentPayDate
    }
    
    // UNIT TEST METHODS
    
    // The below methods are only intended for use in unit test classes
    
    convenience init (paycheck: Paycheck, transactions: [Transaction], currentPayDate: NSDate)
    {
        
        self.init()
        
        self.paycheck = paycheck
        self.transactions = transactions
        
        self.currentPaydate = currentPayDate
        self.initialPaydate = Util.removeTimeComponent(currentPaydate!)
        
    }
    
    func getCurrentPaydate() -> NSDate
    {
        return currentPaydate!
    }
    
    func getPaycheck() -> Paycheck
    {
        return paycheck!
    }
    
}
