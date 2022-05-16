//
//  ViewController.swift
//  toDoListSwift
//
//  Created by Ram Kumar on 28/02/20.
//  Copyright © 2020 Ram Kumar. All rights reserved.
//

import UIKit


class SignUpVC: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var firstNametf: UITextField!
    @IBOutlet weak var lastNametf: UITextField!
    @IBOutlet weak var emailIDTF: UITextField!
    
    @IBOutlet weak var selectbtn: UIButton!
    @IBOutlet weak var countryPV: UIPickerView!
    @IBOutlet weak var countrytf: UITextField!
    @IBOutlet weak var agetf: UITextField!
    
    let countryArray = ["India","Nepal","Pakistan","Bhutan","Korea","China","Japan"]
        
    // MARK: - viewDidLoad
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.countryPV.delegate = self
        self.countryPV.dataSource = self
        
        firstNametf.delegate = self
        lastNametf.delegate = self
        emailIDTF.delegate = self
        countrytf.delegate = self
        agetf.delegate = self
        
        firstNametf.becomeFirstResponder()
        lastNametf.becomeFirstResponder()
        emailIDTF.becomeFirstResponder()
        
        firstNametf.resignFirstResponder()
        lastNametf.resignFirstResponder()
        emailIDTF.resignFirstResponder()
        
        //set navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        validateLogIn()
    }
    
    // MARK: - submit
    @IBAction func submitBtm(_ sender: Any)
    {
       startValidating()
    }
    
    // MARK: -  isValidEmail
    var isValidEmail: Bool
    {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: emailIDTF.text)
    }

    // MARK: -  startValidating
    func startValidating()
    {
        if(firstNametf.text?.count != 0) && (lastNametf.text?.count != 0) && (emailIDTF.text?.count != 0) && (countrytf.text?.count != 0) && (agetf.text?.count != 0) && isValidEmail
        {
            let defaults = UserDefaults.standard
            defaults.setValue(firstNametf.text, forKey: "UserFirstName")
            defaults.setValue(lastNametf.text, forKey: "UserLastName")
            defaults.setValue(emailIDTF.text, forKey: "UserEmailID")
            defaults.setValue(countrytf.text, forKey: "UserCountry")
            defaults.setValue(agetf.text, forKey: "UserAge")
            defaults.setValue("ToDo", forKey: "ToDo")
            performSegue(withIdentifier: "submitIdentifier", sender: nil)
        }
          else
          {
              if !isValidEmail
              {
                  showAlert(title: "", message: "Not a valid Email")
                  return
              }
              else
              {
                  showAlert(title: "", message: "Missing some Fields")
              }
          }
    }
    
    // MARK: -  validateLogIn
    func validateLogIn()
    {
        let userFirstName = UserDefaults.standard.string(forKey: "UserFirstName")
        let userLastName = UserDefaults.standard.string(forKey: "UserLastName")
        let userEmail = UserDefaults.standard.string(forKey: "UserEmailID")
        let userCountry = UserDefaults.standard.string(forKey: "UserCountry")
        let userAge : Int
        userAge = UserDefaults.standard.integer(forKey: "UserAge")
        
        if(userFirstName?.count != nil) && (userLastName?.count != nil) && (userEmail?.count != nil) && (userCountry?.count != nil) && (userAge.description.count != 0)
        {
            performSegue(withIdentifier: "submitIdentifier", sender: nil)
        }
        else
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

    // MARK: - pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return countryArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return countryArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        countrytf.text = countryArray[row]
    }
}



