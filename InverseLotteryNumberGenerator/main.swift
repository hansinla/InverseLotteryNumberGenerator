//
//  main.swift
//  InverseLotteryNumberGenerator
//
//  Created by Hans van Riet on 11/11/14.
//  Copyright (c) 2014 Hans van Riet. All rights reserved.
//

import Foundation

// init an empty array for lottery numbers
var lotteryNumberPicks = Array<Int>()

// init an empty array for mega numbers
var megaNumberPicks = Array<Int>()

//
var totalDrawings = 0
let amountOfNumbersToPick = 5


// open files with lotterynumber frequency and load it
let lotteryNumberFile = "NewWinningNumbers.txt"
let megaNumberFile = "NewMegaNumbers.txt"

if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DesktopDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [NSString] {
    let winningNumberPath = dirs[0].stringByAppendingPathComponent(lotteryNumberFile);
    let megaNumberPath = dirs[0].stringByAppendingPathComponent(megaNumberFile);
    
    //reading
    var error: NSError?
    
    if let allMegaNumbers = NSString(contentsOfFile:megaNumberPath, encoding:NSUTF8StringEncoding, error: &error) {
        var list = allMegaNumbers.componentsSeparatedByString("\n") as [NSString]
        
        // find total number of drawings
        for line in list{
            var lineItems = line.componentsSeparatedByString(",") as [NSString]
            totalDrawings += lineItems[1].integerValue
        }
        
        // Now populate the mega numbers array
        for line in list{
            var lineItems = line.componentsSeparatedByString(",") as [NSString]
            var loopValue = totalDrawings - lineItems[1].integerValue
            var fillValue = lineItems[0].integerValue
            for _ in 1...loopValue {
                megaNumberPicks.append(fillValue)
            }
        }
        
        // Now draw 10 mega numbers
        var upperlimit = UInt32(megaNumberPicks.count)
        println("Picking 10 Mega numbers...")
        for _ in 1...10 {
            var currentPickIndex = Int(arc4random_uniform(upperlimit + 1))
            println("Mega Number Pick: \(megaNumberPicks[currentPickIndex])")
        }
    }
    

    if let allWinningNumbers = NSString(contentsOfFile:winningNumberPath, encoding:NSUTF8StringEncoding, error: &error) {
        
        var list = allWinningNumbers.componentsSeparatedByString("\n") as [NSString]
        for line in list{
            var lineItems = line.componentsSeparatedByString(",") as [NSString]
            var loopValue = totalDrawings - lineItems[1].integerValue
            var fillValue = lineItems[0].integerValue
            for _ in 1...loopValue {
                lotteryNumberPicks.append(fillValue)
            }

        }
        // Now draw 10 series lottery numbers
        println()
        
        var upperlimit = UInt32(lotteryNumberPicks.count)
        println("Picking 10 series of lottery numbers...")
        for _ in 1...10 {
            // init an empty array
            var lotteryPicks = Array<Int>()
            
            do {
                var currentPickIndex = Int(arc4random_uniform(upperlimit + 1))
                var currentPick = lotteryNumberPicks[currentPickIndex]
                if !(contains(lotteryPicks, currentPick)) {
                    lotteryPicks.append(currentPick)
                }
                
            } while (lotteryPicks.count <= amountOfNumbersToPick - 1)
            
            lotteryPicks.sort { $0 < $1 }
            println("\(lotteryPicks)")
        }

    }


    
    // handle errors
    if let theError = error {
        print("\(theError.localizedDescription)")
    }


}