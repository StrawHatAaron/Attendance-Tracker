//
//  CellFinder.swift
//  Cs131
//
//  Created by Aaron Miller on 6/29/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import Foundation

public class CellHelper {
    
    public static func checkSheetValid(){
        
    }
    
    public static func minsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.minute], from: startDate, to: endDate)
        return components.minute!
    }
    
    public static func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
    
    //return the alphabet column I want to read or post from
    //num=row.length     |     str=""
    public static func colToPost(num:Int) -> String{
        var newStr = ""
        switch num {
        case 0:
            newStr = "A"
        case 1:
            newStr = "B"
        case 2:
            newStr = "C"
        case 3:
            newStr = "D"
        case 4:
            newStr = "E"
        case 5:
            newStr = "F"
        case 6:
            newStr = "G"
        case 7:
            newStr = "H"
        case 8:
            newStr = "I"
        case 9:
            newStr = "J"
        case 10:
            newStr = "K"
        case 11:
            newStr = "L"
        case 12:
            newStr = "M"
        case 13:
            newStr = "N"
        case 14:
            newStr = "O"
        case 15:
            newStr = "P"
        case 16:
            newStr = "Q"
        case 17:
            newStr = "R"
        case 18:
            newStr = "S"
        case 19:
            newStr = "T"
        case 20:
            newStr = "U"
        case 21:
            newStr = "V"
        case 22:
            newStr = "W"
        case 23:
            newStr = "X"
        case 24:
            newStr = "Y"
        case 26:
            newStr = "Z"
        case 27:
            newStr = "AA"
        case 28:
            newStr = "AB"
        case 29:
            newStr = "AC"
        case 30:
            newStr = "AD"
        case 31:
            newStr = "AE"
        case 32:
            newStr = "AF"
        case 33:
            newStr = "AG"
        case 34:
            newStr = "AH"
        case 35:
            newStr = "AI"
        case 36:
            newStr = "AJ"
        case 37:
            newStr = "AK"
        case 38:
            newStr = "AL"
        case 39:
            newStr = "AM"
        case 40:
            newStr = "AN"
        case 41:
            newStr = "AO"
        case 42:
            newStr = "AP"
        case 44:
            newStr = "AQ"
        case 45:
            newStr = "AR"
        case 46:
            newStr = "AS"
        case 47:
            newStr = "AT"
        case 48:
            newStr = "AU"
        case 49:
            newStr = "AV"
        case 50:
            newStr = "AW"
        case 51:
            newStr = "AX"
        case 52:
            newStr = "AY"
        default:
            newStr = "AZ"
        }
        
        return newStr
    }
}
