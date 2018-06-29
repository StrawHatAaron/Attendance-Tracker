//
//  NetworkRequest.swift
//  Cs131
//
//  Created by Aaron Miller on 6/6/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GoogleToolboxForMac
import GTMOAuth2
import SVProgressHUD

public class NetworkRequest:UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, ShowAlert{
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets, kGTLRAuthScopeSheetsDrive]
    private let service = GTLRSheetsService()
    let signInButton = GIDSignInButton()

    var requestType = ""
    var profClassNumber = ""
    var studClassNumber = ""
    var studentId = ""
    var studentKey = ""
    var studColPost = ""
    var studRowNumber = 1
    var studRows:[[String]] = [[]]
    var profRows:[[Any]] = [[]]
    var randomKey = 0
    var profPostWasMade = false
    var gotSHA = false
    
    
    func gIDPrepare(){
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        // Add the sign-in button.
        view.addSubview(signInButton)
        
    }
    
    //GET the key and the time that is valid
    func studentGetSheet(classSection:String, id:String, key:String) {
        requestType = "SGS"
        studentId = id
        studentKey = key
        studClassNumber = classSection.components(separatedBy: .whitespaces).joined()
        gIDPrepare()
    }
    
    //POST an X for the people that made it on time
    func studentPostX(){
        requestType = "SP"
        gIDPrepare()
    }
    
    //GET request for specific tab
    //grab the hash and store it
    func professorGetClass(classNumber:String){
        requestType = "PGC"
        profClassNumber = classNumber.components(separatedBy: .whitespaces).joined()
        gIDPrepare()
    }
    
    func professorGetSHA(){
        requestType = "PGS"
        gIDPrepare()
    }

    //POST request to put in a date in the next column and
    //
    func professorPOST(randomKey:Int) {
        requestType = "PP"
        self.randomKey = randomKey
        gIDPrepare()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert("problem", message: "Authentication Error", action: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            switch requestType {
                case "SGS":
                    print("student get cells")
                    getCells(cellRange: "\(studClassNumber)!A1:Z")
                    sleep(2)
                case "PGC":
                    getCells(cellRange: "\(profClassNumber)!A1:Z")
                case "PGS":
                    print("get the SHA")
                    getCells(cellRange: "SHA!B3:B3")
                case "PP":
                    if findColumnToPost(user: "professor") == "dontPost"{
                        print("dont post get the time and display it on the reciept")
                        showAlert("Check Google Sheet", message: "You already signed in for this class today.", action: "Ok")
                    } else {
                        postCells(range: "\(profClassNumber)!\(findColumnToPost(user: "professor"))")
                    }
                case "SP":
                    postCells(range: "\(studClassNumber)!\(findColumnToPost(user: "student"))")
                default:
                    print("something wrong happened")
            }
        }
    }
    

    
    func postCells(range:String){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let today:String = formatter.string(from: Date())
        var colArray = [today]
        for _ in 1...30 {
            colArray.append("")
        }
        colArray.append(String(randomKey))
        
        
        let date = Date().adding(minutes: 15)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        colArray.append("\(hour):\(minutes):\(seconds)")
        
        
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        var descriptions: [String: Any]
        
        //professor
        if requestType == "PP" {
            descriptions = ["range" : range,
                           "majorDimension" : "COLUMNS",
                           "values" : [ colArray ] ]
        }
        //student
        else {
            descriptions = ["range" : range,
                            "majorDimension" : "COLUMNS",
                            "values" : [ ["X"] ] ]
        }
        let valueRange = GTLRSheets_ValueRange(json: descriptions)
        let query = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: valueRange, spreadsheetId: spreadsheetId, range: range)
        query.valueInputOption = "USER_ENTERED"
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
        profPostWasMade = true
    }
    
    func getCells(cellRange:String) {
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetId, range:cellRange)
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObject result : GTLRSheets_ValueRange, error : NSError?) {
        DispatchQueue.main.async {
            if let error = error {
                self.showAlert("problem", message: "Error", action: error.localizedDescription)
                print(error.localizedDescription)
                return
            }
            print("!self.profPostWasMade: \(!self.profPostWasMade)")
            if !self.profPostWasMade {
                let rows = result.values!
                //print("the rows in the table: \(rows)")
                
                //student GET - check if the key is the same as the key entered
                switch self.requestType {
                    case "SGS":
                        if rows.isEmpty {print("rows were empty")}
                        else {
                            print("student got sheet")
                            //Column to post to
                            self.studRows = rows as! [[String]]
                        }
                    case "PGC":
//                        print("PGC rows: \(rows)")
                        self.profRows = rows
                    case "PGS":
                        print(rows)
                        if rows[0][0] != nil {
                            UserDefaults.standard.set("\(rows[0][0])", forKey: "sheetSHA256")
                            self.gotSHA = true
                        }
                    default:
                        print("something wrong happend displayResultWithTicket in NetworkRequest")
                }
            }
        }
    }
    
    //check if id key
    func studIsCorrect() -> Bool {
        //find matching string in studRows
        var isMatch = false
        var idMatch = false
        var keyMatch = false
        var rowNumber = 1
        //check id
        for rows in studRows{
            if rows.count >= 3 {
                print("\(rows[2]) ?== \(studentId)")
                if rows[2] == studentId {
                    print("there was a id match!!!")
                    idMatch = true
                    studRowNumber = rowNumber
                    print("rowNumber: \(studRowNumber)")
                }
            }
            rowNumber += 1
        }
        //check key
        let key = studRows[31][studRows[32].count-1]
        if key == studentKey {
            print("there was a key match!!!")
            keyMatch = true
        }
        if keyMatch && idMatch{
            isMatch = true
        }
        return isMatch
    }
    
    
    func studIsOnTime() -> Bool {
        var timeGood = false
        let dateString = studRows[0][studRows[32].count-1]
        let timeString = studRows[32][studRows[32].count-1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy'T'HH:mm:ss"
        let sheetDate = dateFormatter.date(from: "\(dateString)T\(timeString)")
        let dateNow = Date()
        let minsApart = minsBetweenDates(startDate: sheetDate!, endDate: dateNow)
        if minsApart <= 15 {
            timeGood = true
        }
        
        return timeGood
    }
    
    func minsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.minute], from: startDate, to: endDate)
        return components.minute!
    }

    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }

    
    func findColumnToPost(user:String) -> String {
        //profRows[rows][cols]
        var col = ""
        var ret = ""
        if user == "professor" {
            //but wait... what if the sheet already has the same date
            for row in profRows {
                print(row)
            }
            
            let dateString = profRows[0][profRows[0].count-1]
            let timeString = profRows[32][profRows[32].count-1]
            print("dateString: \(dateString)")
            print("timeString: \(timeString)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy'T'HH:mm:ss"
            let sheetDate = dateFormatter.date(from: "\(dateString)T\(timeString)")
            let dateNow = Date()
            
            if sheetDate == nil {
                //date does not exist so make a new one
                col = colToPost(num:profRows[0].count)
                ret = "\(col)1:\(col)33"
            }else {
                let daysApart = daysBetweenDates(startDate: sheetDate!, endDate: dateNow)
                if daysApart <= 0 {
                    //there is no need to make another column
                    ret = "dontPost"
                } else {
                    col = colToPost(num:profRows[0].count)
                    ret = "\(col)1:\(col)33"
                }
            }
        }else {
            col = colToPost(num: studRows[0].count - 1)
            ret = "\(col)\(studRowNumber):\(col)\(studRowNumber)"
            print("the cell I want to POST to: \(ret)")
        }
        
        return ret
    }
    
    //return the alphabet column I want to read or post from
    //num=row.length     |     str=""
    func colToPost(num:Int) -> String{
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

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}





