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
import SVProgressHUD

public class NetworkRequest:UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, ShowAlert{
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets, kGTLRAuthScopeSheetsDrive]
    private let service = GTLRSheetsService()
    let signInButton = GIDSignInButton()
    let output = UITextView()
    var requestType = ""
    
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
    func professorGET(){
        requestType = "PG"
        gIDPrepare()
    }

    //POST request to put in a date in the next column and
    //
    func professorPOST(randomKey:Int) -> Bool {
        requestType = "PP"
        gIDPrepare()
        return true
    }
    
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert("problem", message: "Authentication Error", action: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            switch requestType {
                case "SG":
                    getCells(cellRange: "A1:B")
                case "PG":
                    getCells(cellRange: "SHA!B3:B3")
                case "PP":
                    postCells(range: "Test!A1:D5")
                default:
                    print("something wrong happened")
            }
        }
    }
    
    func postCells(range:String){
        SVProgressHUD.show()
        
        let values = [
            ["Item", "Cost", "Stocked", "Ship Date"],
            ["Wheel", "$20.50", "4", "3/1/2016"],
            ["Door", "$15", "2", "3/15/2016"],
            ["Engine", "$100", "1", "30/20/2016"],
            ["Totals", "=SUM(B2:B4)", "=SUM(C2:C4)", "=MAX(D2:D4)"]
        ]
        
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        let range = "Test!A3:D3"
        let params = ["valueInputOption": "RAW"]
        
        let descriptions: [AnyHashable: Any] = [AnyHashable("a1"):"X"]
        let GTLRSheet
        let q = GTLRSheetsQuery_SpreadsheetsValuesBatchUpdate.query(withObject: <#T##GTLRSheets_BatchUpdateValuesRequest#>, spreadsheetId: spreadsheetId)
        
//        let valueRange = GTLRSheets_ValueRange(json: descriptions)
//        let query = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: valueRange, spreadsheetId: spreadsheetId, range: range)
        query.valueInputOption = "RAW"
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))

        
        
        
        
        
        
        
        
        
        
        
//        print("are we getting here")
//        guard let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)?valueInputOption=USER_ENTERED") else {return}
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        print(GIDAuthentication().accessToken)
//        request.addValue("", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField:"Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        guard let myHttpBody = try? JSONSerialization.data(withJSONObject: values, options: []) else {return}
//        request.httpBody = myHttpBody
//        let session = URLSession.shared
//        print("right before data task")
//        session.dataTask(with: request) { (data, response, error) in
//            if let response = response as? HTTPURLResponse  {
//                print("The response: \(response)")
//            }
//            if let data = data {
//                print(data)
//                SVProgressHUD.dismiss()
//            }
//        }.resume()

        
        
    }
    
    

    
    
    // Display (in the UITextView) the names and majors of students in a sample
    // spreadsheet:
    // our sheet ID: 1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8
    // https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
    func getCells(cellRange:String) {
        output.text = "Getting sheet data..."
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





