//
//  ViewController.swift
//  Reminder
//
//  Created by Simran on 06/03/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    // Main Page View
    @IBOutlet weak var tableView: UITableView!
    
    
    // Create Array
    var reminderArray = [ReminderModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    @IBAction func setReminder(_ sender: Any) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddReminderViewController else {
            return
        }

        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = ReminderModel(title: title, date: date, identifier: "id_\(title)")
                self.reminderArray.append(new)
                self.tableView.reloadData()

                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body

                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                          from: targetDate),
                                                            repeats: false)

                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TestAction(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { [self] success, error in
            if success {
               scheduleLocalNotification()
            }else if let error = error{
                print("error occured")
            }
            
        })
    }
    
    
    
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder Test"
        content.sound = .default
        content.body = "This is test body "

        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                  from: targetDate),
                                                    repeats: false)

        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
        }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print("Total of array:\(reminderArray.count)")
       return reminderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderViewCell
        cell.textLabel?.text = reminderArray[indexPath.row].title
        let date = reminderArray[indexPath.row].date

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY"
        cell.detailTextLabel?.text = formatter.string(from: date)

        cell.textLabel?.font = UIFont(name: "Arial", size: 25)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 22)
        return cell
        
    }
    
    
}
