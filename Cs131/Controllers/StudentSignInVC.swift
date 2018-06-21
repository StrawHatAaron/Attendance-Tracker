//
//  SignInViewController.swift
//  Cs131
//
//  Created by Aaron Miller on 6/1/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class StudentSignInVC: NetworkRequest, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ShowAlert {

    
    @IBOutlet weak var studentIdText: UITextField!
    @IBOutlet weak var studentKeyText: UITextField!
    @IBOutlet weak var classPicker: UIPickerView!
    @IBOutlet weak var classNumberLabel: UILabel!
    lazy var classes:[String] = ["Section 1", "Section 2", "Section 3", "Section 4" ]
    var keys = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classNumberLabel.text! = classes[0]
        self.hideKeyboardWhenTappedAround()
        self.studentKeyText.delegate = self
        self.classPicker.delegate = self
        
        keys = googleModule()
        print(keys)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkStudentIn(_ sender: Any) {
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



