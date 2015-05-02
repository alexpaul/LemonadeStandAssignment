//
//  Customer.swift
//  LemonadeStandAssignment
//
//  Created by Alex Paul on 5/1/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import Foundation

struct Customer {
    var preference = 0.0 // taste preference 
    var range = LemonadePreferenceRange.Default
    var revenue = (0, "") // (Paid Int, Paid String)
    
    enum LemonadePreferenceRange: String {
        case Acidic = "Acidic"          // 0 - 0.4
        case EqualParts = "Equal Parts" // 0.4 - 0.6
        case Diluted = "Diluted"        // 0.6 - 1
        case Default = "Error"          //
    }
    
    static func getCustomerLemonadeRange(customerPreference: Double) -> (LemonadePreferenceRange){
        var customerLemonadeRange = LemonadePreferenceRange.Default
        
        switch customerPreference {
        case 0...0.4: // favors Acidic Lemonade
            customerLemonadeRange = .Acidic
        case 0.4...0.6: // favors Equal Parts Lemonade
            customerLemonadeRange = .EqualParts
        case 0.6...1.0: // favors Diluted Lemonade
            customerLemonadeRange = .Diluted
        default:
            customerLemonadeRange = .Default
            println("Error - Favor Not Found!")
        }
        return customerLemonadeRange
    }
}