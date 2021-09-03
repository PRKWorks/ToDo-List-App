//
//  addTaskViewController.swift
//  toDoListSwift
//
//  Created by Ram Kumar on 28/02/20.
//  Copyright © 2020 Ram Kumar. All rights reserved.
//

import UIKit

class addTaskViewController: UIViewController, UITextFieldDelegate{
    
    var update: (() -> Void)?
    var taskTi = ""
    var toDoInfo = String()
    var toDoTitle = String()
    var desiredNameValue: String!
    var desiredDetailValue: String!
    var desiedTimeValue: String!
    var newTitle: String!
    var indexString = String()

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var timePV: UIDatePicker!
    @IBOutlet weak var dateTimeTF: UITextField!
    @IBOutlet weak var detailsTF: UITextField!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    
    // MARK: - PickerView

    @IBAction func dateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short

        let strDate = dateFormatter.string(from: timePV.date)

        dateTimeLabel.text = strDate
    }
    
    // MARK: - Save

    @IBAction func save (_ sender: Any)
    {
      
        if((titleTF.text?.count != 0)&&(detailsTF.text?.count != 0)){
            // save values to Userdefaults
            let defaults = UserDefaults.standard
            if((navigationController?.title = "Edit Tasks") != nil){
                defaults.setValue(indexString, forKey: "indexKey")
            }
            if((navigationController?.title = "Add Tasks") != nil){
                defaults.setValue(titleTF.text, forKey: "ToDoTitle")
                defaults.setValue(detailsTF.text, forKey: "ToDoDetail")
                defaults.setValue(dateTimeLabel.text, forKey: "ToDoTime")
            }
            self.navigationController?.popViewController(animated: true)
        }else
        {
            // Do Nothing
        }
        
        
    }
    
    // MARK: - Done
    
    @IBAction func done(_ sender: Any) {
        
    }
    
    // MARK: - viewDidLoad

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Add Tasks"
        let time = Date()
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateStyle = DateFormatter.Style.short
        currentDateFormatter.timeStyle = DateFormatter.Style.short
        let currentDate = currentDateFormatter.string(from: time)
        let currentDateD = currentDateFormatter.date(from: currentDate)!
        
        if ((desiedTimeValue) != nil) {
            dateTimeLabel.text = desiedTimeValue
            let storedDate = currentDateFormatter.date(from: desiedTimeValue)!
            timePV.setDate(storedDate, animated: true)
        }
        else{
            dateTimeLabel.text = currentDate
           timePV.setDate(currentDateD, animated: true)
        }

        titleTF.text = desiredNameValue
        detailsTF.text = desiredDetailValue
        self.title = newTitle
        
        titleTF.becomeFirstResponder()
        detailsTF.becomeFirstResponder()

        titleTF.resignFirstResponder()
        detailsTF.resignFirstResponder()
        detailsTF.delegate = self
        titleTF.delegate = self
        usernoti()
    }
func textFieldDidEndEditing(_ textField: UITextField) {
        
            save(self)
        
    }
}


// MARK: - UNUserNotificationCenter

func usernoti(){
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
        
    }
    
    let content = UNMutableNotificationContent()
    content.title = "Notification For Alarm"
    content.body = "Enter the Time"
    
    let date = Date().addingTimeInterval(10)
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
    center.add(request) { (error) in
    }

}



