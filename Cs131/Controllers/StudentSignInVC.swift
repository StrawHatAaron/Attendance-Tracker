//
//  SignInViewController.swift
//  Cs131
//
//  Created by Aaron Miller on 6/1/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit
import SVProgressHUD

class StudentSignInVC: NetworkRequest, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var studentIdText: UITextField!
    @IBOutlet weak var studentKeyText: UITextField!
    @IBOutlet weak var classPicker: UIPickerView!
    @IBOutlet weak var classNumberLabel: UILabel!
    lazy var classes:[String] = ["CSC 20", "CSC 131", "CSC 133", "CSC 135"]
    var keys:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classNumberLabel.text! = classes[0]
        self.hideKeyboardWhenTappedAround()
        self.studentKeyText.delegate = self
        self.classPicker.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkStudentIn(_ sender: Any) {
        if checkinSuccess() {print("lookin good")}
        
        
        print("these are the keys! \(keys)")
        if studentIdText.text! == "" || studentKeyText.text! == "" {
            showAlert("Empty Field", message: "At least one of the text fields have not been filled out", action: "Ok")
        } else if false {
          //check with the server if the ID, class section, and key all line up
            showAlert("Please try again", message: "The information entered does not match the server", action: "Ok")
        } else {
            UserDefaults.standard.set(studentIdText.text, forKey: "studentID")
            UserDefaults.standard.set(classNumberLabel.text!, forKey: "classSection")
            self.performSegue(withIdentifier: "checkInToReceipt", sender: nil)
        }
    }
    
    
    func checkinSuccess() -> Bool {
        var success = false
        if Reachability.isConnectedToNetwork() {
            SVProgressHUD.show()
            studentIdText.isEnabled = false
            studentKeyText.isEnabled = false
            classPicker.isUserInteractionEnabled = false
            studentGetSheet(classSection:classNumberLabel.text!, id:studentKeyText.text!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                self.studentPostX()
                self.studentIdText.isEnabled = true
                self.studentKeyText.isEnabled = true
                self.classPicker.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
            }
            success = true
        }
        return success
    }
    
    //delegate for UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //delegate for UIPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        classNumberLabel.text! = classes[row]
    }
}



