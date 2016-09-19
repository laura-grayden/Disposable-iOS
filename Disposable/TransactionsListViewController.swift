//
//  TransactionsListViewController.swift
//  Disposable
//
//  Created by Laura Grayden on 8/09/2015.
//  Copyright (c) 2015 Lance Apps. All rights reserved.
//

import UIKit

class TransactionsListViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var transactions = [Transaction]()
    var filteredTransactions = [Transaction]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    var tblSearchResults: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let savedTransactions = loadTransactions()
        {
            transactions += savedTransactions
        }
        
        configureSearchController()
        
        tblSearchResults = tableView
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.tabBarController != nil
        {
            self.tabBarController!.tabBar.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults
        {
            if (filteredTransactions.count == 0)
            {
                return 1
            }
            else
            {
                return filteredTransactions.count
            }
            
        }
        else
        {
            return transactions.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TransactionsListTableViewCell", forIndexPath: indexPath) as! TransactionsListTableViewCell
        
        var transaction : Transaction
        
        if shouldShowSearchResults
        {
            if (!filteredTransactions.isEmpty)
            {
                transaction = self.filteredTransactions[indexPath.row]
                
                cell.descriptionLabel.text = transaction.desc
                cell.amountLabel.text = transaction.getAmountString()
                
                if transaction.credit
                {
                    cell.amountLabel.text = cell.amountLabel.text! + " CR"
                }
                
                cell.reoccuranceLabel.text = transaction.occurance
                
                return cell
            }
            else
            {
                cell.descriptionLabel.text = ""
                cell.amountLabel.text = ""
                cell.reoccuranceLabel.text = ""
                
                return cell
            }
            
        }
        else
        {
            transaction = self.transactions[indexPath.row]
            
            cell.descriptionLabel.text = transaction.desc
            cell.amountLabel.text = transaction.getAmountString()
            
            if transaction.credit
            {
                cell.amountLabel.text = cell.amountLabel.text! + " CR"
            }
            
            cell.reoccuranceLabel.text = transaction.occurance
            
            return cell
        }
    
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            // Delete the row from the data source
            
            if shouldShowSearchResults
            {
                let indexInMainArray = transactions.indexOf(filteredTransactions[indexPath.row])
                
                transactions.removeAtIndex(indexInMainArray!)
                filteredTransactions.removeAtIndex(indexPath.row)
                
                saveTransactions()
                
                tblSearchResults.reloadData()

            }
            else
            {
                transactions.removeAtIndex(indexPath.row)
                
                saveTransactions()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }

        }

    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    @IBAction func unwindToTransactionList(sender: UIStoryboardSegue) {
    
        if let sourceViewController = sender.sourceViewController as? TransactionDetailsViewController, let transaction = sourceViewController.transaction {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow
            {
                if shouldShowSearchResults
                {
                    let indexInMainArray = transactions.indexOf(filteredTransactions[selectedIndexPath.row])
                    
                    transactions[indexInMainArray!] = transaction
                }
                else
                {
                    transactions[selectedIndexPath.row] = transaction
                }
                
                
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else
            {
                
                let newIndexPath = NSIndexPath(forRow: transactions.count, inSection: 0)
                
                transactions.append(transaction)
                
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            saveTransactions()
            
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            
            let transactionDetailViewController = segue.destinationViewController as! TransactionDetailsViewController
            
            // Get the cell that generated this segue.
            
            if let selectedTransactionCell = sender as? TransactionsListTableViewCell {
                
                var indexPath : NSIndexPath
                var selectedTransaction : Transaction
                
                if shouldShowSearchResults
                {
                    indexPath = self.tableView.indexPathForCell(selectedTransactionCell)!
                    selectedTransaction = filteredTransactions[indexPath.row]
                }
                else
                {
                    indexPath = self.tableView.indexPathForCell(selectedTransactionCell)!
                    selectedTransaction = transactions[indexPath.row]
                }

                transactionDetailViewController.transaction = selectedTransaction
            }
        }
    }
    
    // Search functionality
    
    func configureSearchController()
    {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Transactions"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        searchController.searchBar.barTintColor = Constants.LIGHT_ORANGE_COLOUR
        searchController.searchBar.tintColor = Constants.ORANGE_COLOUR
        searchController.searchBar.backgroundImage = UIImage()
        
        tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        if !shouldShowSearchResults
        {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those transactions that match the search text.
        
        filteredTransactions = transactions.filter({ (Transaction) -> Bool in
            let descText: NSString = Transaction.desc
            
            return (descText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
 
    func didStartSearching()
    {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton()
    {
        if !shouldShowSearchResults
        {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
    }
    
    
    func didTapOnCancelButton()
    {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func didChangeSearchText(searchText: String)
    {
        // Filter the data array and get only those countries that match the search text.
        filteredTransactions = transactions.filter({ (Transaction) -> Bool in
            let descText: NSString = Transaction.desc
            
            return (descText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }

    
    // Data persistance
    
    func saveTransactions() {
        
        NSKeyedArchiver.archiveRootObject(transactions, toFile: Transaction.ArchiveURL!.path!)
    }
    
    func loadTransactions() -> [Transaction]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Transaction.ArchiveURL!.path!) as? [Transaction]
    }
    
}
