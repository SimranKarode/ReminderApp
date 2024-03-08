//
//  AddReminderViewController.swift
//  Reminder
//
//  Created by Simran on 08/03/24.
//

import Foundation
import UIKit

class AddReminderViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var bodyField: UITextField!
    
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taskTextField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton))
    }
    
     @objc func saveButton(){
         if let titleText = taskTextField.text, !titleText.isEmpty,
             let bodyText = bodyField.text, !bodyText.isEmpty {

             let targetDate = datePicker.date

             completion?(titleText, bodyText, targetDate)
             
             let content = UNMutableNotificationContent()
             content.title = titleText
             content.sound = .default
             content.body = bodyText

             let NextDate = targetDate
             let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                       from: NextDate),
                                                         repeats: false)

             let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
             UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                 if error != nil {
                     print("something went wrong")
                 }
             })

         }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        return true
    }
}
