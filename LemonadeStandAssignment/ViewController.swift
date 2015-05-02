//
//  ViewController.swift
//  LemonadeStandAssignment
//
//  Created by Alex Paul on 4/27/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//
//
//  The goal of the game will be to maintain a profit each day of the game. As soon as you run out of money to purchase new inventory, the game should end.
//
//  The player should start with $10, 1 Lemon, and 1 Ice Cube. Each additional Lemon will cost $2, and each additional Ice Cube $1.
//
//  Storyboard has 4 sections: What supplies you (the player) have, a section to purchase supplies (like more lemons, ice cubes, etc.), a third area where you can create the lemonade, and lastly, a section with your sell lemonade button.

import UIKit

class ViewController: UIViewController {
    
    
    // Player Inventory Outlets
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var lemonsLabel: UILabel!
    @IBOutlet weak var iceCubesLabel: UILabel!
    
    // Purchase Supplies Outlets
    @IBOutlet weak var lemonsPurchasedLabel: UILabel!
    @IBOutlet weak var iceCubesPurchasedLabel: UILabel!
    
    // Mix Your Lemonade Outlets
    @IBOutlet weak var lemonsToMixLabel: UILabel!
    @IBOutlet weak var IceCubesToMixLabel: UILabel!
    
    var todaysRatio = 0.0
    var todaysRange = Customer.LemonadePreferenceRange.Default
    
    let arrayOfPreferences = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0] // array of Customer Preferences
    
    var customers = [Customer]() // Customers array will hold 1 - 10 Customers
    
    var playerInventory = PlayerInventory()
    
    // MARK: View
    
    override func viewDidLoad() {
        updateView()    
    }
    
    func updateView(){
        // Update Player Inventory Labels
        self.cashLabel.text = "$\(self.playerInventory.cash)"
        self.lemonsLabel.text = "\(self.playerInventory.lemons) Lemons"
        self.iceCubesLabel.text = "\(self.playerInventory.iceCubes) Ice Cubes"
        
        // Update Purchase Supplies Labels
        self.lemonsPurchasedLabel.text = "\(self.playerInventory.lemonsPurchased)"
        
        // Update Mix Your Lemonade Labels
        self.lemonsToMixLabel.text = "\(self.playerInventory.lemonsToBeMixed)"
        self.IceCubesToMixLabel.text = "\(self.playerInventory.iceCubesToBeMixed)"
        
    }
    
    // MARK: Purchase Supplies Actions
    
    @IBAction func addLemonsButtonPressed(sender: UIButton) {
        
        // Player needs at least $2
        
        if self.playerInventory.cash >= 2{
            // add 1 lemons
            self.playerInventory.lemons++
            self.playerInventory.lemonsPurchased++
            
            // decrease cash by $2
            self.playerInventory.cash -= 2
            
            updateView()
        }else{
            showAlertView(header: "Insufficient Funds", message: "You need at least $2 to a lemon")
        }
    }
    
    @IBAction func subtractLemonsButtonPressed(sender: UIButton) {
        
        // Player needs at least 1 Lemon
        
        if self.playerInventory.lemons >= 1{
            
            // subtract lemons count
            self.playerInventory.lemons--
            
            // increase cash
            self.playerInventory.cash += 2
            
            updateView()
        }else{
            showAlertView(header: "No More Lemons", message: "You need at least 1 lemon to get a refund")
        }
    }
    
    @IBAction func addIceCubesButtonPressed(sender: UIButton) {
        
        // Player needs at least $1
        
        if self.playerInventory.cash >= 1{
            // add 1 ice cube
            self.playerInventory.iceCubes++
            
            // decrease cash by $1
            self.playerInventory.cash--
            
            updateView()
        }else{
            showAlertView(header: "Insufficient Funds", message: "You need at least $1 to purchase an Ice Cube")
        }
    }
    
    @IBAction func subtractIceCubesButtonPressed(sender: UIButton) {
        
        // Player needs at least 1 Ice Cube
        
        if self.playerInventory.iceCubes >= 1{
            
            // subtract 1 ice cube
            self.playerInventory.iceCubes--
            
            // increase cash by $1
            self.playerInventory.cash++
            
            updateView()
        }else{
            showAlertView(header: "No More Ice Cubes", message: "You need to have at least 1 Ice Cube for a refund")
        }
    }
    
    // MARK: Mix Your Lemonade Actions
    
    @IBAction func addLemonsToBeMiixed(sender: UIButton) {
        self.playerInventory.lemonsToBeMixed++
        updateView()
    }
    
    @IBAction func subtractLemonsToBeMixed(sender: UIButton) {
        self.playerInventory.lemonsToBeMixed--
        updateView()
    }
    
    @IBAction func addIceCubesToBeMixed(sender: UIButton) {
        self.playerInventory.iceCubesToBeMixed++
        updateView()
    }
    
    @IBAction func subtractIceCubesToBeMixed(sender: UIButton) {
        self.playerInventory.iceCubesToBeMixed--
        updateView()
    }
    
    // MARK: Start Day Action
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
        // Set Today's Lemonade Ratio from "Mix Your Lemonade" values (lemons / ice cubes)
        if var ratio = lemonsOverIceCubesRatio(Double(self.playerInventory.lemonsToBeMixed), iceCubes: Double(self.playerInventory.iceCubesToBeMixed)){
            todaysRatio = ratio // set Today's Ratio
        }else{
            println("Error")
        }
        
        // Set Today's Lemonade Preference Range
        setLemonadePreferenceRange()
        
        // Create a Random Number of Customers (between 1 and 10) that will visit the Lemonade Stand Today
        let randomNumberOfCustomers = Int(arc4random_uniform(UInt32(10))) // 0 - 9, increment by 1 to get customer count 1 - 10
        
        println("Today there are: \(randomNumberOfCustomers + 1) customers\n")
        
        // Create 1 - 10 Customers with their preference and corresponding Lemonade favor range
        for var index = 0; index < randomNumberOfCustomers + 1; index++ {
            var aRandomCustomerPreferenceNumber = Int(arc4random_uniform(UInt32(10)))
            var customer = Customer() // create a customer instance
            
            customer.preference = self.arrayOfPreferences[aRandomCustomerPreferenceNumber]
            customer.range = Customer.getCustomerLemonadeRange(customer.preference)
            customer.revenue = queryForRevenuePaidByCustomer(customer.range, todaysRange: self.todaysRange)
            self.customers.append(customer) // add customer to customers array
        }
        
        // Print Revenue Generated by each customer
        printRevenueGeneratedFromEachCustomer()
    }
    
    // MARK: Alert View
    
    func showAlertView(header: String = "Warning", message: String){
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Helper Methods
    
    // Get the Lemonade Ratio that will affect sales, (lemons over ice cubes), i.e. more acidic, equal parts, or less acidic lemonade.
    // lemons over ice cubes
    func lemonsOverIceCubesRatio(lemons: Double, iceCubes: Double) -> Double?{
        var ratio: Double?
        if iceCubes != 0{
            ratio = lemons/iceCubes
        }else{
            ratio = nil
        }
        return ratio
    }
    
    // Set Today's Lemonade Preference Range
    func setLemonadePreferenceRange() {
        if todaysRatio > 1 {
            // Acidic Lemonade
            self.todaysRange = .Acidic
        }
        if todaysRatio == 1 {
            // Equal Parts
            self.todaysRange = .EqualParts
        }
        if todaysRatio < 1 {
            // Diluted Lemonade
            self.todaysRange = .Diluted
        }
    }
    
    func queryForRevenuePaidByCustomer(customerRange: Customer.LemonadePreferenceRange, todaysRange: Customer.LemonadePreferenceRange) -> (Int, String) {
        var revenueInt: Int
        var revenueString: String
        
        // If Customer Preference/Range is the same as Today's Range, generate $1 revenue - Paid
        if customerRange == todaysRange {
            revenueInt = 1
            revenueString = "Paid!"
        }
        
        // Otherwise Today's Range is NOT the Customer's Preference/Range do NOT generate revenue - No match, No Revenue
        else {
            revenueInt = 0
            revenueString = "No Match, No Revenue!"
        }
        
        return (revenueInt, revenueString)
    }
    
    func printRevenueGeneratedFromEachCustomer(){
        for customer in self.customers {
            println("Customer Preference is: \(customer.preference)")
            println("Custoemr Revenue is: \(customer.revenue)")
            println("Today's Range is: \(self.todaysRange.rawValue)\n")
        }
    }
    
}

