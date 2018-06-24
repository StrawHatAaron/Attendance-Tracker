//
//  ProfessorSignIn.swift
//  Cs131
//
//  Created by Aaron Miller on 6/14/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class ProfessorSignInVC: NetworkRequest, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var classNumberLabel: UILabel!
    @IBOutlet weak var classPicker: UIPickerView!
    
    lazy var classes:[String] = ["CSC 20", "CSC 131", "CSC 133", "CSC 135"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderView.dropShadow()
        
        professorGET()
        
        classNumberLabel.text = classes[0]
        self.hideKeyboardWhenTappedAround()
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.classPicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkIn(_ sender: Any) {
        //check if the fields are empty
        if usernameField.text! == "" || passwordField.text! == "" {
            showAlert("Empty Field", message: "At least one of the text fields have not been filled out", action: "Ok")
        }
        //check with the server if the ID, class section, and key all line up
        else if usernameField.text! != "username" || passwordField.text! != "password" {
            showAlert("Please try again", message: "The information entered does not match the credentials in the system", action: "Ok")
        } else {
            UserDefaults.standard.set(usernameField.text, forKey: "professorUsername")
            UserDefaults.standard.set(classNumberLabel.text, forKey: "classSection")
            self.performSegue(withIdentifier: "professorCheckInToReciept", sender: nil)
        }
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

