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
    
    // Weather Image
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var randomNumberOfCustomers = 0 // Random Number Of Customers
    
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
        self.iceCubesPurchasedLabel.text = "\(self.playerInventory.iceCubesPurchased)"
        
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
            showAlertView(header: "Insufficient Funds", message: "You need at least $2 to a purchase a lemon")
        }
    }
    
    @IBAction func subtractLemonsButtonPressed(sender: UIButton) {
        
        // Player needs at least 1 Lemon
        
        if self.playerInventory.lemons >= 1 && self.playerInventory.lemonsPurchased >= 1{
            
            // subtract lemons count
            self.playerInventory.lemons--
            self.playerInventory.lemonsPurchased--
            
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
            self.playerInventory.iceCubesPurchased++
            
            // decrease cash by $1
            self.playerInventory.cash--
            
            updateView()
        }else{
            showAlertView(header: "Insufficient Funds", message: "You need at least $1 to purchase an Ice Cube")
        }
    }
    
    @IBAction func subtractIceCubesButtonPressed(sender: UIButton) {
        
        // Player needs at least 1 Ice Cube
        
        if self.playerInventory.iceCubes >= 1 && self.playerInventory.iceCubesPurchased >= 1{
            
            // subtract 1 ice cube
            self.playerInventory.iceCubes--
            self.playerInventory.iceCubesPurchased--
            
            // increase cash by $1
            self.playerInventory.cash++
            
            updateView()
        }else{
            showAlertView(header: "No More Ice Cubes", message: "You need at least 1 Ice Cube to get a refund")
        }
    }
    
    // MARK: Mix Your Lemonade Actions
    
    @IBAction func addLemonsToBeMiixed(sender: UIButton) {
        if self.playerInventory.lemons >= 1{
            self.playerInventory.lemonsToBeMixed++
            self.playerInventory.lemons--
            updateView()
        }else{
            // There are No Lemons left that you can Add to the Mix
            showAlertView(header: "No Lemons Left", message: "There are No Lemons left that you can Add to the Mix")
        }
    }
    
    @IBAction func subtractLemonsToBeMixed(sender: UIButton) {
        if self.playerInventory.lemonsToBeMixed >= 1{
            self.playerInventory.lemonsToBeMixed--
            self.playerInventory.lemons++
            updateView()
        }else{
            // There are currently No Lemons in the Mix you can subtract
            showAlertView(header: "No Lemons in the Mix", message: "There are currently No Lemons in the Mix you can subtract")
        }
    }
    
    @IBAction func addIceCubesToBeMixed(sender: UIButton) {
        if self.playerInventory.iceCubes >= 1{
            self.playerInventory.iceCubesToBeMixed++
            self.playerInventory.iceCubes--
            updateView()
        }else{
            // There are No Ice Cubes left that you can Add to the Mix
            showAlertView(header: "No Ice Cubes Left", message: "There are No Ice Cubes left that you can Add to the Mix")
        }
    }
    
    @IBAction func subtractIceCubesToBeMixed(sender: UIButton) {
        if self.playerInventory.iceCubesToBeMixed >= 1{
            self.playerInventory.iceCubesToBeMixed--
            self.playerInventory.iceCubes++
            updateView()
        }else{
            // There are currently No Ice Cubes in the Mix you can subtract
            showAlertView(header: "No Ice Cubes in the Mix", message: "There are currently No Ice Cubes in the Mix you can subtract")
        }
    }
    
    // MARK: Start Day Action
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
        // Set Today's Lemonade Ratio from "Mix Your Lemonade" values (lemons / ice cubes)
        if var ratio = lemonsOverIceCubesRatio(Double(self.playerInventory.lemonsToBeMixed), iceCubes: Double(self.playerInventory.iceCubesToBeMixed)){
            todaysRatio = ratio // set Today's Ratio
        }else{
            println("Error in Calculating Today's Ratio")
        }
        
        // Set Today's Lemonade Preference Range using Today's Ratio
        setLemonadePreferenceRange()
        
        // Creates a Random Number of Customers
        createARandomNumberOfCustomers()
        println("Today there are: \(self.randomNumberOfCustomers) customers\n")
        
        // Base on Today's Weather the number of Customers showing up will be affected
        todaysWeather()
        println("As for Today's weather there are: \(self.randomNumberOfCustomers) customers\n")
        
        // Create 1 - 10 Customers with their preference and corresponding Lemonade favor range
        for var index = 0; index < self.randomNumberOfCustomers; index++ {
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
    
    func createARandomNumberOfCustomers(){
        // Create a Random Number of Customers (between 1 and 10) that will visit the Lemonade Stand Today
        self.randomNumberOfCustomers = Int(arc4random_uniform(UInt32(10))) + 1 // 0 - 9, increment by 1 to get customer count 1 - 10
    }
    
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
    
    // Set Today's Lemonade Preference Range using Today's Ratio
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
    
    // Query for Revenue 
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
            println("Today's Lemonade is: \(self.todaysRange.rawValue)\n")
        }
    }
    
    func todaysWeather(){
        var randomWeatherNumber = Int(arc4random_uniform(UInt32(3)))
        
        switch randomWeatherNumber{
        case 0: // cold weather, -3 customers
            self.weatherImageView.image = UIImage(named: "cold-1")
            self.weatherLabel.text = "Cold"
            self.randomNumberOfCustomers -= 3
        case 1: // mild weather, no customer change
            self.weatherImageView.image = UIImage(named: "mild-1")
            self.weatherLabel.text = "Mild"
        case 2: // warm weather, +4 custoemers
            self.weatherImageView.image = UIImage(named: "warm-1")
            self.weatherLabel.text = "Warm"
            self.randomNumberOfCustomers += 4
        default:
            println("Error in Weather Data")
        }
    }
    
}

