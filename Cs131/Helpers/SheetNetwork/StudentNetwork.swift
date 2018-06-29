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


public class StudentNetwork:UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, ShowAlert{
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets, kGTLRAuthScopeSheetsDrive]
    private let service = GTLRSheetsService()
    let signInButton = GIDSignInButton()

    var get = false
    var requestType = ""
    var studClassNumber = ""
    var studentId = ""
    var studentKey = ""
    var studColPost = ""
    var studRowNumber = 1
    var studRows:[[String]] = [[]]
    
    
    //GET the key and the time that is valid
    func studentGetSheet(classSection:String, id:String, key:String) {
        requestType = "SGS"
        get = true
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
    
    func getCells(cellRange:String) {
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetId, range:"F17:F17")
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    func postCells(range:String){
        print("FUCK A MOTHER FUCKING POST HOLY FUCK!!!!!!a'sdlkfjasdlk;fjasd;lkfjasdl;kfjasdlk;fjasldk;fjasdl;kfjdsla;f")
        
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        var descriptions: [String: Any] = ["range" : range,
                            "majorDimension" : "COLUMNS",
                            "values" : [ ["X"] ] ]
        let valueRange = GTLRSheets_ValueRange(json: descriptions)
        let query = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: valueRange, spreadsheetId: spreadsheetId, range: range)
        query.valueInputOption = "USER_ENTERED"
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
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
                }
            }
            rowNumber += 1
        }
        //check key
        print(studRows)
        let key = studRows[31][studRows[31].count-1]
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
        let dateString = studRows[0][studRows[0].count-1]
        let timeString = studRows[32][studRows[32].count-1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy'T'HH:mm:ss"
        let sheetDate = dateFormatter.date(from: "\(dateString)T\(timeString)")
        let dateNow = Date()
        let minsApart = CellHelper.minsBetweenDates(startDate: sheetDate!, endDate: dateNow)
        print("the mins apart: \(minsApart)")
        if minsApart <= 1 {
            timeGood = true
        }
        
        return timeGood
    }
    
    func findColumnToPost(user:String) -> String {
        //studRows[rows][cols]
        var col = ""
        var ret = ""
        print("the count for the \(studRows[0].count)")
        col = CellHelper.colToPost(num: studRows[0].count)
        ret = "\(col)\(studRowNumber):\(col)\(studRowNumber)"
        print(ret)
        print("the cell I want to POST to: \(ret)")
        return ret
    }
    
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObject result : GTLRSheets_ValueRange, error : NSError?) {
        DispatchQueue.main.async {
            if let error = error {
                self.showAlert("problem", message: "Error", action: error.localizedDescription)
                print(error.localizedDescription)
                return
            }
            if self.get {
                if let rows = result.values {
                    if rows.isEmpty {print("rows were empty")}
                    else {
                        print("student got sheet")
                        self.studRows = rows as! [[String]]
                    }
                }
            }
        }
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
            case "SP":
                print("post the mother fucking cells")
                postCells(range: "\(studClassNumber)!\(findColumnToPost(user: "student"))")
            default:
                print("something wrong happened")
            }
        }
    }
    
    
    func gIDPrepare(){
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        // Add the sign-in button.
        view.addSubview(signInButton)
    }
    
}







