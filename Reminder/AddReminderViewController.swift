//
//  AddReminderViewController.swift
//  Reminder
//
//  Created by Simran on 08/03/24.
//

import Foundation
import UIKit

class AddReminderViewController: UIViewController, UITextFieldDelegate, DataPass{
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var bodyField: UITextField!
    var i = Int()
    var optionalTitle:String?
    var optionalSubtitle:String?
    var dateOptional:Date?
    var id:Int?
    var isEdit: Bool = false
    public var completion: ((String, String, Date) -> Void)?
    var delegate:DataPass!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taskTextField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton))
        taskTextField.text = optionalTitle
        bodyField.text = optionalSubtitle
        datePicker.date = dateOptional ?? Date()
        
    }
    
     @objc func saveButton(){
         if let titleText = taskTextField.text, !titleText.isEmpty,
             let bodyText = bodyField.text, !bodyText.isEmpty {

             let targetDate = datePicker.date
             completion?(titleText, bodyText, targetDate)
             
             
             // This is a set notification part, when set a reminder
             self.delegate = self
             let content = UNMutableNotificationContent()
             content.title = "Reminder Test" + "" + titleText
             content.sound = .default
             content.body = bodyText

             let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate),repeats: false)

             let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
             UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                 if error != nil {
                     print("something went wrong")
                 }else{
                     print("Your notification set successfully!")
                 }
             })
             
             // This is a database part : save data in the database
             let dict = ["titleofRemind":titleText, "subtitleofRemind":bodyText, "date&Time":targetDate, "ids":"00\(titleText)"] as [String : Any]
             if isEdit == true{
                 DatabaseHelper.sharedInstance.editObject(object: dict, i: i)
                 navigationController?.popViewController(animated: true)
             }else{
                 DatabaseHelper.sharedInstance.saveObject(object: dict)
                 
             }
             print(dict)
             
         }
         
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        return true
    }
    
    func data(index: Int, title: String, subT: String, datess: Date, idss: Int) {
        
        taskTextField.text = optionalTitle
        bodyField.text = optionalSubtitle
        datePicker.date = dateOptional ?? Date()
        i = index
    }
    
}
