//
//  taskListViewController.swift
//  toDoListSwift
//
//  Created by Ram Kumar on 28/02/20.
//  Copyright © 2020 Ram Kumar. All rights reserved.
//

import UIKit

// MARK: - taskInfoTableViewCell

class taskInfoTableViewCell : UITableViewCell
{
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDetailLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskTimeLabel: UILabel!
}

class taskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var taskListTV: UITableView!
    @IBOutlet weak var addTaskBtn: UIBarButtonItem!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var taskInfoLabel: UILabel!
    @IBOutlet weak var plusTaskBTN: UIButton!
    var taskArray = [[String:String]]()
    var timeArray : [String] = []
    var taskTimeArray : [String] = []
    var taskTimeValueArray : [String] = []
    var taskImageName : String = ""
    var taskLabelName : String = ""

    // MARK: - AddTaskBtn
    @IBAction func addTaskBtn(_ sender: UIBarButtonItem) {
        let  vc = storyboard?.instantiateViewController(identifier: "addTaskIdentifier") as! addTaskViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.title = "Add Task"
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
        self.taskListTV.delegate = self
        self.taskListTV.dataSource = self
        self.messageLabel.text = "Hello, \(String(describing: UserDefaults.standard.string(forKey: "UserFirstName")!))"
        taskListTV.reloadData()
    }
    
    // MARK: - plusTasksBTN
    @IBAction func plusTaskBTN(_ sender: Any) {
        let  vc = storyboard?.instantiateViewController(identifier: "addTaskIdentifier") as! addTaskViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.title = "Add Task"
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        FetchDataFromPlist()
        setTimeValue()
        if(self.taskArray.count != 0)
        {
            self.plusTaskBTN.isHidden = true
            self.taskListTV.isHidden = false
        }
    }
    
    // MARK: - FetchDataFromPlist
    func FetchDataFromPlist()
    {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("StoreTaskData.plist")
        var data = Data()
        do
        {
            data = try Data(contentsOf: path)
            taskArray = try! (PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]])!
            taskInfoLabel.text = "You have \(taskArray.count) tasks"
        }
        catch
        {
        }
    }
    
    // MARK: - setTimeValue
    func setTimeValue()
    {
        // Remove Duplicate values
        taskTimeArray.removeAll()
        taskTimeValueArray.removeAll()
        
        for index in 0..<taskArray.count
        {
            taskTimeArray.append(taskArray[index]["TaskTime:"]!)
            let timeValue = findTimeDifference(time: taskTimeArray[index])
            taskTimeValueArray.append(timeValue)
            taskListTV.reloadData()
        }
    }
    
    // MARK: - displayTimeLabel
    func displayTimeLabel(index : IndexPath)
    {
        if(taskTimeValueArray[index.row] == "Today")
        {
            taskImageName = "Aquamarine"
            taskLabelName = "Today"
        }
        else if(self.taskTimeValueArray[index.row] == "Tomorrow")
        {
            taskImageName = "Water"
            taskLabelName = "Tomorrow"
        }
        else if(self.taskTimeValueArray[index.row] == "Yesterday")
        {
            taskImageName = "Hot Pink"
            taskLabelName = "Yesterday"
        }
        else if(self.taskTimeValueArray[index.row] == "Oldest")
        {
            taskImageName = "Red Orange"
            taskLabelName = "Oldest"
        }
        else if(self.taskTimeValueArray[index.row] == "Later")
        {
            taskImageName = "Pale Canary"
            taskLabelName = "Later"
        }
    }

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(taskArray.count == 0)
        {
            self.taskListTV.isHidden = true
            return 0
        }
        else {
            self.taskListTV.isHidden = false
            return taskArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! taskInfoTableViewCell
        DispatchQueue.main.async
        { [self] in
            cell.taskTitleLabel?.text = taskArray[indexPath.row]["TaskTitle:"]
            cell.taskDetailLabel?.text = taskArray[indexPath.row]["TaskDetail:"]
            displayTimeLabel(index: indexPath)
            cell.taskImageView.image = UIImage(named: taskImageName)
            cell.taskImageView.clipsToBounds = true
            cell.taskImageView.layer.cornerRadius = 10
            cell.taskImageView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
            let degrees : Double = -90; //the value in degrees
            cell.taskTimeLabel.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180))
            cell.taskTimeLabel.text = taskLabelName
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        taskListTV.deselectRow(at: indexPath, animated: true)
        let  vc = storyboard?.instantiateViewController(identifier: "addTaskIdentifier") as! addTaskViewController
        self.navigationController?.pushViewController(vc, animated: true)
        vc.desiredNameValue = taskArray[indexPath.row]["TaskTitle:"]
        vc.desiredTimeValue =  taskArray[indexPath.row]["TaskTime:"]
        vc.desiredDetailValue = taskArray[indexPath.row]["TaskDetail:"]
        vc.title = "Edit Task"
        vc.indexString = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if(editingStyle == UITableViewCell.EditingStyle.delete)
        {
            taskListTV.beginUpdates()
            taskArray.remove(at: indexPath.row)
            taskListTV.deleteRows(at: [indexPath], with: .none)
            deleteValueFromPList(indexValue: indexPath.row)
            taskListTV.endUpdates()
        }
    }
            
    // MARK: - findTimeDifference
    func findTimeDifference(time : String) -> String
    {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
        let inputDate = dateFormatter.date(from: time)
        if calendar.isDateInToday(inputDate!) {
            return "Today"
        }
        else if calendar.isDateInYesterday(inputDate!) {
            return "Yesterday"
        }
        else if calendar.isDateInTomorrow(inputDate!) {
            return "Tomorrow"
        }
        else
        {
            let startOfNow = calendar.startOfDay(for: inputDate!)
            let startOfTimeStamp = calendar.startOfDay(for: Date())
            let components = calendar.dateComponents([.day], from: startOfTimeStamp, to: startOfNow)
            let day = components.day!
            if day < 1 {
                return "Oldest"
            }
            else {
                return "Later"
            }
        }
    }
    
    // MARK: - deleteValueFromPList
    func deleteValueFromPList(indexValue : Int)
    {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("StoreTaskData.plist")
        try! PropertyListEncoder().encode(taskArray).write(to: path)
        taskInfoLabel.text = "You have \(taskArray.count) tasks"
        if(taskArray.count == 0)
        {
            plusTaskBTN.isHidden = false
            self.taskListTV.isHidden = true
        }
    }
}


    
    

