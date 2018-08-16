//
//  HelpVC.swift
//  Cs131
//
//  Created by Aaron Miller on 8/15/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

class HelpVC: UINavigationController {

    @IBOutlet weak var topMessage: UILabel!
    @IBOutlet weak var professorInstructions: UILabel!
    @IBOutlet weak var professorNote: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var studentInstructions: UILabel!
    @IBOutlet weak var studentNote: UILabel!
    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var studentComment: UILabel!
    @IBOutlet weak var studentMore: UILabel!
    
    //TODO -- Figure out why the fonts of these labels are nil
    override func viewDidLoad() {
        super.viewDidLoad()
        topMessage.font = topMessage.font.withSize(self.view.frame.height * 0.03)
        professorInstructions.font = professorInstructions.font.withSize(self.view.frame.height * 0.03)
        professorNote.font = professorNote.font.withSize(self.view.frame.height * 0.03)
        username.font = username.font.withSize(self.view.frame.height * 0.03)
        password.font = password.font.withSize(self.view.frame.height * 0.03)
        studentInstructions.font = studentInstructions.font.withSize(self.view.frame.height * 0.03)
        studentNote.font = studentNote.font.withSize(self.view.frame.height * 0.03)
        studentID.font = studentID.font.withSize(self.view.frame.height * 0.03)
        key.font = key.font.withSize(self.view.frame.height * 0.03)
        studentComment.font = studentComment.font.withSize(self.view.frame.height * 0.03)
        studentMore.font = studentMore.font.withSize(self.view.frame.height * 0.03)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
