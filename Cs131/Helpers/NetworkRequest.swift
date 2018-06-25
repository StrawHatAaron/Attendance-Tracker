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
    var profPostWasMade = false
    var profClassNumber = ""
    var randomKey = 0
    
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
        requestType = "SG"
        gIDPrepare()
        return UserDefaults.standard.string(forKey: "studentContent")
    }
    
    //POST an X for the people that made it on time
    func studentPOST(){
        requestType = "SP"
        gIDPrepare()
    }
    
    //GET request for specific tab
    //grab the hash and store it
    func professorGetClass(classNumber:String){
        requestType = "PGC"
        profClassNumber = classNumber.trimmingCharacters(in: .whitespaces)
        gIDPrepare()
    }
    
    func professorGetSHA(){
        requestType = "PGS"
        gIDPrepare()
    }

    //POST request to put in a date in the next column and
    //
    func professorPOST(randomKey:Int) -> Bool {
        requestType = "PP"
        self.randomKey = randomKey
        gIDPrepare()
        return true
    }
    
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert("problem", message: "Authentication Error", action: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            switch requestType {
                case "SG":
                    getCells(cellRange: "A1:B")
                case "PGC":
                    getCells(cellRange: "\(profClassNumber)!A1:Z")
                case "PGS":
                    getCells(cellRange: "SHA!B3:B3")
                case "PP":
                    postCells(range: "Test!A1:A2")
                default:
                    print("something wrong happened")
            }
        }
    }
    

    
    func postCells(range:String){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let today:String = formatter.string(from: Date())
        
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        let descriptions: [String: Any] = ["range" : range,
                                           "majorDimension" : "ROWS",
                                           "values" : [ [today], [randomKey] ]
                                          ]
        let valueRange = GTLRSheets_ValueRange(json: descriptions)
        let query = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: valueRange, spreadsheetId: spreadsheetId, range: range)
        query.valueInputOption = "USER_ENTERED"
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
        profPostWasMade = true
    }
    
    func getCells(cellRange:String) {
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetId, range:cellRange)
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Process the response and display output
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObject result : GTLRSheets_ValueRange, error : NSError?) {
        DispatchQueue.main.async {
            if let error = error {
                self.showAlert("problem", message: "Error", action: error.localizedDescription)
                print(error.localizedDescription)
                return
            }
            if !self.profPostWasMade {
                let rows = result.values!
                print(rows)
                
                //student GET - check if the key is the same as the key entered
                switch self.requestType {
                    case "SG":
                        if rows.isEmpty {return}
                    case "PGC":
                        print(rows[0][1])
                    case "PGS":
                        print(rows)
                        UserDefaults.standard.set("\(rows[0][0])", forKey: "sheetSHA256")
                    default:
                        print("something wrong happend displayResultWithTicket in NetworkRequest")
                }
            }
        }
    }
    
    
    func findColumnToPost() -> String {
        
        return ""
    }
    
    
    
    
}





