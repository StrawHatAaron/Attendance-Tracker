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

public class NetworkRequest:UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, ShowAlert{
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    private let service = GTLRSheetsService()
    let signInButton = GIDSignInButton()
    let output = UITextView()

    
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
    func studentGET() -> String? {
        UserDefaults.standard.set("SG", forKey: "requestType")
        gIDPrepare()
        return UserDefaults.standard.string(forKey: "studentContent")
    }
    
    //POST an X for the people that made it on time
    func studentPOST(){
        UserDefaults.standard.set("SP", forKey: "requestType")
        gIDPrepare()
    }
    
    //GET request for specific tab
    //grab the hash and store it
    func professorGET(){
        UserDefaults.standard.set("PG", forKey: "requestType")
        gIDPrepare()
    }

    func professorPOST(){
        UserDefaults.standard.set("PP", forKey: "requestType")
        gIDPrepare()
    }
    
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert("problem", message: "Authentication Error", action: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            switch UserDefaults.standard.string(forKey: "requestType") {
                case "SG":
                    grabCells(cellRange: "A1:B")
                case "PG":
                    grabCells(cellRange: "SHA!B3:B3")
                default:
                    print("something wrong happened")
            }
        }
    }
    
    // Display (in the UITextView) the names and majors of students in a sample
    // spreadsheet:
    // our sheet ID: 1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8
    // https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
    func grabCells(cellRange:String) {
        output.text = "Getting sheet data..."
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        let range = cellRange
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetId, range:range)
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObject result : GTLRSheets_ValueRange, error : NSError?) {
        DispatchQueue.main.async {
            if let error = error {
                self.showAlert("problem", message: "Error", action: error.localizedDescription)
                return
            }
            let rows = result.values!
            print(rows)
            
            //student GET - check if the key is the same as the key entered
            if UserDefaults.standard.string(forKey: "requestType") == "SG" {
                if rows.isEmpty {
                    self.output.text = "No data found."
                    return
                }
                var majorsString:String = ""
                var i = 0
                for row in rows {
                    if row.isEmpty == false {
                        let name = row[0]
                        let major = row[1]
                        majorsString += "\(name), \(major) \n"
                    }
                    print("row     : \(i)")
                    i += 1
                }
                UserDefaults.standard.set(majorsString, forKey: "studentContent")
            }
            //professor GET - get the SHA encryption and store it
            else {
                print(rows[0][0])
                UserDefaults.standard.set("\(rows[0][0])", forKey: "sheetSHA256")
            }
        }
    }
    
    
    func studentGETCells() -> [String] {
        return []
    }
    
}





