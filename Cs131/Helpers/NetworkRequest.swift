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
    
    
    //GET the key and the time that is valid
    func studentGET(classSection:String) -> String? {
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        // Add the sign-in button.
        view.addSubview(signInButton)
        print("this is returning before the selector is finishing I think")
        return UserDefaults.standard.string(forKey: "studentContent")
    }
    
    func studentPOST(){}
    
    func professorGET(){}

    func professorPOST(){
        
    }
    
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert("problem", message: "Authentication Error", action: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            grabCells(cellRange: "")
        }
    }
    
    // Display (in the UITextView) the names and majors of students in a sample
    // spreadsheet:
    // our sheet ID: 1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8
    // https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
    func grabCells(cellRange:String) {
        output.text = "Getting sheet data..."
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        let range = "A38:D"
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
            if rows.isEmpty {
                self.output.text = "No data found."
                return
            }
            var majorsString:String = ""
            var i = 0
            for row in rows {
                if row.isEmpty == false {
                    print("for zero: \(row[0])")
                    print("for one : \(row[1])")
                    print("for four: \(row[3])")
                    let name = row[0]
                    let major = row[1]
                    majorsString += "\(name), \(major) \n"
                }
                print("row     : \(i)")
                i += 1
            }
            UserDefaults.standard.set(majorsString, forKey: "studentContent")
        }
    }
    
    
    func studentGETCells() -> [String] {
        return []
    }
    
}





