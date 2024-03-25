//
//  ViewController.swift
//  Reminder
//
//  Created by Simran on 06/03/24.
//

import UIKit
import UserNotifications


protocol DataPass {
    func data(index: Int,title: String, subT:String, datess: Date, idss: Int)
}

class ViewController: UIViewController {


    // Main Page View
    @IBOutlet weak var tableView: UITableView!
    var delegate:DataPass!
    var remindData = [Remind]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        tableView.dataSource = self
        tableView.delegate = self
        self.remindData = DatabaseHelper.sharedInstance.fetchData()
        tableView.reloadData()
    }

    // This is add reminder code
    @IBAction func setReminder(_ sender: Any) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddReminderViewController else {
            return
        }

        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = ReminderModel(title: title, subtitle: body, date: date, identifier: "00\(title)")
                self.remindData = DatabaseHelper.sharedInstance.fetchData()
                self.tableView.reloadData()
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body

                let targetDate = date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:00"
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.timeStyle = .short
                let timeString = dateFormatter.string(from: targetDate)
                
//                // Here you would set up your reminder functionality using the selected time
                
                print("Reminder set for \(timeString)")
                
                // For demonstration, you can present an alert
                
                let alertController = UIAlertController(title: "Reminder", message: "Reminder set for \(timeString)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        self.tableView.reloadData()
    }
    
    
    // This is for notification
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder Test"
        content.sound = .default
        content.body = "This is test body"

        let targetDate = Date().addingTimeInterval(5)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                  from: targetDate),
                                                    repeats: false)

        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }else{
                print("Your notification set successfully!")
            }
        })
        }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddReminderViewController else {
            return
        }
        vc.title = "Update Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.optionalTitle = remindData[indexPath.row].titleRemind
        vc.optionalSubtitle = remindData[indexPath.row].subtitleRemind
        vc.dateOptional = remindData[indexPath.row].dateTime
        vc.id = Int(remindData[indexPath.row].id)
        vc.i = indexPath.row
        vc.isEdit = true
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.remindData = DatabaseHelper.sharedInstance.fetchData()
                self.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("array from database:\(remindData.count)")
       return remindData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderViewCell
        cell.textLabel?.text = remindData[indexPath.row].titleRemind
        let date = remindData[indexPath.row].dateTime

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY"
        cell.detailTextLabel?.text = formatter.string(from: date!)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            remindData = DatabaseHelper.sharedInstance.deleteData(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }else{
            
        }
    }
    

}
