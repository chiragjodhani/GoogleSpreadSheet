//
//  ViewController.swift
//  SheetDemo
//
//  Created by Eryus Developer on 19/07/17.
//  Copyright © 2017 Eryushion Techsol. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import Alamofire
class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets]
    private let service = GTLRSheetsService()
    
    let signInButton = GIDSignInButton()
    let output = UITextView()
    var request = [GTLRSheets_Request]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        let request = GTLRSheets_Spreadsheet()
//        let currentDate = Date()
//        request.spreadsheetId = currentDate.description
//        request.spreadsheetUrl = "https://docs.google.com/spreadsheets/u/0/"
//        let mSpreadsheet = GTLRSheetsQuery_SpreadsheetsCreate.query(withObject: request)
//        service.executeQuery(mSpreadsheet, delegate: self, didFinish: nil)
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        
        // Add a UITextView to display output.
        output.frame = view.bounds
        output.isEditable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        output.isHidden = true
        view.addSubview(output);
        
        
        //        https://docs.google.com/forms/d/e/1FAIpQLScsrJYZCsQIJsy3lEM_eJLmU7Up7sm175ESNnYRGGOUrlEUvg/viewform
        //
        //        entry.642921174
        //
        //        entry.252797529
//        let parameters: Parameters = ["entry.642921174": "Test1","entry.252797529":"Test2"]
//        Alamofire.request("https://docs.google.com/forms/d/e/1FAIpQLScsrJYZCsQIJsy3lEM_eJLmU7Up7sm175ESNnYRGGOUrlEUvg/formResponse", method: .post, parameters: parameters).responseString { response in
//            print("Response String: \(String(describing: response.result.value))")
//            }
        
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            //showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            listMajors()
        }
    }
    func listMajors() {
        
//        requests.add(new Request().setAddSheet(new AddSheetRequest().setProperties(new SheetProperties().setTitle(formattedDate))));
//        BatchUpdateSpreadsheetRequest body = new BatchUpdateSpreadsheetRequest().setRequests(requests);
//        BatchUpdateSpreadsheetResponse response = mService.spreadsheets().batchUpdate(spreadsheetId, body).execute();
 
        output.text = "Getting sheet data..."
        let spreadsheetId = "1GEMrwZ-pUh0YBPMTCi5aDLqSqpcOGXT0waqOb2WZ3W8"
        let spreadsheet = GTLRSheets_ValueRange()
        spreadsheet.values = [["Chatur","Sagar","Tejas"]]
       // let sheetname = Date()
        let addnew = GTLRSheets_Request()
        addnew.addSheet = GTLRSheets_AddSheetRequest.init()
        let props = GTLRSheets_SheetProperties.init()
        props.title = "chatur"
        addnew.addSheet?.properties = props
        print(addnew)
        let body = GTLRSheets_BatchUpdateSpreadsheetRequest.init()
        body.requests?.append(addnew)
        //var response = GTLRSheets_BatchUpdateSpreadsheetResponse()
        let query1 = GTLRSheetsQuery_SpreadsheetsBatchUpdate.query(withObject: body, spreadsheetId: spreadsheetId)
       
        print(query1.debugDescription)
        service.executeQuery(query1, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
        
        /*let range = "A1"
        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend
            .query(withObject: spreadsheet, spreadsheetId: spreadsheetId, range: range)
        query.valueInputOption = "RAW"
        service.executeQuery(query,
                             delegate: self,
                             didFinish: nil
        )*/
    }
    func displayResultWithTicket(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRSheets_ValueRange,
                                 error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var majorsString = ""
        let rows = result.values!
        
        if rows.isEmpty {
            output.text = "No data found."
            return
        }
        
        majorsString += "Name, Major:\n"
        for row in rows {
            let name = row[0]
            let major = row[4]
            
            majorsString += "\(name), \(major)\n"
        }
        
        output.text = majorsString
    }
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

