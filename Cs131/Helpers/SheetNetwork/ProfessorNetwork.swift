//
//  ProfessorNetwork.swift
//  Cs131
//
//  Created by Aaron Miller on 6/29/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GoogleToolboxForMac
import GTMOAuth2
import SVProgressHUD

public class ProfessorNetwork:UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, ShowAlert{
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets, kGTLRAuthScopeSheetsDrive]
    private let service = GTLRSheetsService()
    let signInButton = GIDSignInButton()
    
    var requestType = ""
    var profClassNumber = ""
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
            case "PGC":
                getCells(cellRange: "\(profClassNumber)!A1:Z")
            case "PGS":
                print("get the SHA")
                getCells(cellRange: "SHA!B3:B3")
            case "PP":
                if findColumnToPost(user: "professor") == "dontPost"{
                    showAlert("Check Google Sheet", message: "You already signed in for this class today.", action: "Ok")
                } else {
                    postCells(range: "\(profClassNumber)!\(findColumnToPost(user: "professor"))")
                }
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
                switch self.requestType {
                case "PGC":
                    self.profRows = rows
                case "PGS":
                    print(rows)
                    if rows[0][0] != nil {
                        UserDefaults.standard.set("\(rows[0][0])", forKey: "sheetSHA256")
                        self.gotSHA = true
                    }
                default:
                    print("something wrong happend displayResultWithTicket in TeacherNetwork")
                }
            }
        }
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
            col = CellHelper.colToPost(num:profRows[0].count)
            ret = "\(col)1:\(col)33"
        }else {
            let daysApart = daysBetweenDates(startDate: sheetDate!, endDate: dateNow)
            if daysApart <= 0 {
                //there is no need to make another column
                ret = "dontPost"
            } else {
                col = CellHelper.colToPost(num:profRows[0].count)
                ret = "\(col)1:\(col)33"
            }
        }
        return ret
    }

    
}






