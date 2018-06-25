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
    
    var profRows:[[Any]] = [[]]
    var requestType = ""
    var profClassNumber = ""
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
        profClassNumber = classNumber.components(separatedBy: .whitespaces).joined()
        print(profClassNumber)
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
                    print("get the SHA")
                    getCells(cellRange: "SHA!B3:B3")
                case "PP":
                    postCells(range: "\(profClassNumber)!\(findProfColumnToPost())")
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
        let spreadsheetId = "1HEkPX-wEowUAOSH3rAzwLOndnAMZ_WsCkxR_aonbyu8"
        let descriptions: [String: Any] = ["range" : range,
                                           "majorDimension" : "COLUMNS",
                                           "values" : [ colArray ] ]
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
            print("!self.profPostWasMade: \(!self.profPostWasMade)")
            if !self.profPostWasMade {
                let rows = result.values!
                //print("the rows in the table: \(rows)")
                
                //student GET - check if the key is the same as the key entered
                switch self.requestType {
                    case "SG":
                        if rows.isEmpty {return}
                    case "PGC":
                        print("PGC rows: \(rows)")
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
    
    
    func findProfColumnToPost() -> String {
        //profRows[rows][cols]
        //length of first cell is the amount of columns
        let col = colToPost(num:profRows[0].count)
        return "\(col)1:\(col)32"
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





