//
//  addTaskViewController.swift
//  toDoListSwift
//
//  Created by Ram Kumar on 28/02/20.
//  Copyright © 2020 Ram Kumar. All rights reserved.
//

import UIKit
import UserNotifications

class addTaskViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var timePV: UIDatePicker!
    @IBOutlet weak var detailsTF: UITextField!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var desiredNameValue: String!
    var desiredDetailValue: String!
    var desiredTimeValue: String!
    var indexString = Int()
    var taskInfoDict : [String:String] = [:]
    var taskArray = [[String:String]]()
    
    // MARK: - viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleTF.becomeFirstResponder()
        detailsTF.becomeFirstResponder()

        titleTF.resignFirstResponder()
        detailsTF.resignFirstResponder()
        detailsTF.delegate = self
        titleTF.delegate = self
        assignValues()
        fetchDataFromPlist()
    }
    
    // MARK: - dateChanged
    @IBAction func dateChanged(_ sender: Any)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: timePV.date)
        dateTimeLabel.text = strDate
    }
    
    // MARK: - Save
    @IBAction func save (_ sender: Any)
    {
        if((titleTF.text?.count != 0)&&(detailsTF.text?.count != 0))
        {
            if(self.navigationItem.title == "Edit Task")
            {
                taskArray.remove(at: indexString)
            }
            taskInfoDict["TaskTitle:"] = titleTF.text
            taskInfoDict["TaskDetail:"] = detailsTF.text
            taskInfoDict["TaskTime:"] = dateTimeLabel.text
            taskArray.append(taskInfoDict)
        }
        else
        {
            showAlert(title: "Enter Text", message: "Text Field is Empty")
        }
        saveDataToPlist(taskArray: taskArray)
        scheduleNotification()
    }
    
    // MARK: - assignValues
    func assignValues() {
        let time = Date()
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateStyle = DateFormatter.Style.short
        currentDateFormatter.timeStyle = DateFormatter.Style.short
        let currentDate = currentDateFormatter.string(from: time)
        let currentDateD = currentDateFormatter.date(from: currentDate)!
        if ((desiredTimeValue) != nil)
        {
            dateTimeLabel.text = desiredTimeValue
            let storedDate = currentDateFormatter.date(from: desiredTimeValue)!
            timePV.setDate(storedDate, animated: true)
            titleTF.text = desiredNameValue
            detailsTF.text = desiredDetailValue
        }
        else
        {
            dateTimeLabel.text = currentDate
            timePV.setDate(currentDateD, animated: true)
        }
    }
    
    // MARK: - saveDataToPlist
    func saveDataToPlist( taskArray: [[String:String]])
    {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("StoreTaskData.plist")
        do
        {
            try! PropertyListEncoder().encode(taskArray).write(to: path)
        }
    }

 //    MARK: - FetchDataFromPlist
    func fetchDataFromPlist()
    {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("StoreTaskData.plist")
        do
        {
            let data = try Data(contentsOf: path)
            taskArray = try! (PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) ) as! [[String : String]]
        }
        catch
        {
        }
    }

    // MARK: - showAlert
    func showAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

// MARK: - scheduleNotification
    func scheduleNotification()
    {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound])
        {
            (permissionGranted, error) in
            if(!permissionGranted)
            {
                print("Permission Denied")
            }
        }
        notificationCenter.getNotificationSettings { (settings) in
            
            DispatchQueue.main.async
            {
                let title = self.titleTF.text!
                let message = self.detailsTF.text!
                let date = self.timePV.date
                
                if(settings.authorizationStatus == .authorized)
                {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    
                    let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    notificationCenter.add(request) { (error) in
                        if(error != nil)
                        {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    let ac = UIAlertController(title: "Notification Scheduled", message: "At " + self.formattedDate(date: date), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler:
                    { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(ac, animated: true)
                }
                else
                {
                    let ac = UIAlertController(title: "Enable Notifications?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default)
                    { (_) in
                        guard let setttingsURL = URL(string: UIApplication.openSettingsURLString)
                        else
                        {
                            return
                        }
                        
                        if(UIApplication.shared.canOpenURL(setttingsURL))
                        {
                            UIApplication.shared.open(setttingsURL) { (_) in}
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                }
            }
        }

    }
    
    // MARK: - formattedDate
    func formattedDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
}

