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
}

class taskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var taskListTV: UITableView!
    @IBOutlet weak var addTaskBtn: UIBarButtonItem!
    var taskTitle = [String]()
    var taskName = ""
    var rowValue : Int!
    
    // MARK: - taskinfo

    struct taskinfo {
        var name : String
        var details : String
        var time : String
    }

    var taskData = [taskinfo(name: "Ram",details: "Make a symbolic breakpoint",time :                               "10/25/20, 11:50 PM"),
                    taskinfo(name: "Ashok",details: "Make a symbolic breakpoint",time: "10/26/20, 11:51 PM"),
                    taskinfo(name: "Raj",details: "Make a symbolic breakpoint",time : "10/27/20, 11:52 PM"),
                    taskinfo(name: "Raja",details: "Make a symbolic breakpoint",time : "10/28/20, 11:53 PM"),
                    taskinfo(name: "Rajesh",details: "Make a symbolic breakpoint",time : "10/29/20, 11:54 PM")
    ]
    
    var tasksArray: [Any] = []
    
   public var completionHandler : ((String)->Void)?
    
    // MARK: - Add Task Btn

    @IBAction func plusTaskBtn(_ sender: Any) {
        
        let  vc = storyboard?.instantiateViewController(identifier: "addTaskIdentifier") as! addTaskViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.newTitle = "Add Tasks"
        let enteredTitle = addTaskViewController()
        vc.title = "New Tasks"
        vc.update = {
            DispatchQueue.main.async
            {

            }
        }
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        taskListTV.reloadData()
        self.title = "Tasks"
        UserDefaults.standard.removeObject(forKey: "indexKey")

        // Do any additional setup after loading the view.
        
        self.taskListTV.delegate = self
        self.taskListTV.dataSource = self
        
        if !UserDefaults().bool(forKey: "Setup"){
            UserDefaults().set(true, forKey: "Setup")
            UserDefaults().set(0, forKey: "count ")
        }
    }
    
    // MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        
        let toDoTitle = UserDefaults.standard.string(forKey: "ToDoTitle")
        let toDoDetails = UserDefaults.standard.string(forKey: "ToDoDetail")
        let toDoTime = UserDefaults.standard.string(forKey: "ToDoTime")
        let rowNumber = UserDefaults.standard.string(forKey: "indexKey")

        var tasksDict = [String:String]()
        tasksDict["Title:"] = toDoTitle
        tasksDict["Details:"] = toDoDetails
        tasksDict["Time:"] = toDoTime
        
        if (toDoTitle?.count != 0)&&(toDoTitle?.count != nil){
        //  Append value if not nil

            if(rowNumber?.count != 0)&&(rowNumber?.count != nil){
                //  Replace if row number not nil
                taskData.remove(at: Int(rowNumber!) ?? 0)
                taskData.append(taskinfo.init(name: toDoTitle!, details: toDoDetails!, time: toDoTime!))
            }else{
                //  Append new data
                taskData.append(taskinfo.init(name: toDoTitle!, details: toDoDetails!, time: toDoTime!))
            }
        } else{
         // Do Nothing
        }
        
        // Remove UserDefaults
        UserDefaults.standard.removeObject(forKey: "ToDoTitle")
        UserDefaults.standard.removeObject(forKey: "ToDoDetail")
        UserDefaults.standard.removeObject(forKey: "ToDoTime")
        UserDefaults.standard.removeObject(forKey: "indexKey")
        
        var oldTaskArray = UserDefaults.standard.array(forKey: "toDoArray")
        oldTaskArray?.removeAll()

        var newTaskArray = [[String:String]]()
        newTaskArray.insert(tasksDict, at: 0)
        let updatedTaskArray = newTaskArray + oldTaskArray!

        UserDefaults.standard.set(updatedTaskArray, forKey: "toDoArray")
        UserDefaults.standard.synchronize()
        
        tasksArray.append(contentsOf: updatedTaskArray)
        taskListTV.reloadData()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return taskData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! taskInfoTableViewCell
     
        let tast1 = taskData[indexPath.row]
        cell.taskTitleLabel?.text = tast1.name
        cell.taskDetailLabel?.text = tast1.details
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        taskListTV.deselectRow(at: indexPath, animated: true)
        
        let  vc = storyboard?.instantiateViewController(identifier: "addTaskIdentifier") as! addTaskViewController
        self.navigationController?.pushViewController(vc, animated: true)
        let tast2 = taskData[indexPath.row]
        vc.desiredNameValue = tast2.name
        vc.desiredDetailValue = tast2.details
        vc.desiedTimeValue = tast2.time
        vc.newTitle = "Edit Tasks"
        vc.indexString = String(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            taskListTV.beginUpdates()
            taskData.remove(at: indexPath.row)
            taskListTV.deleteRows(at: [indexPath], with: .none)
            taskListTV.endUpdates()
            }
    }
    
}


    
    

