//
//  DatabaseHelper.swift
//  Reminder
//
//  Created by Simran on 22/03/24.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper {
    // singleton class & sharedInstance is a instance
    static var sharedInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    // below function create for save data
    func saveObject(object: [String:Any]){
        let remind = NSEntityDescription.insertNewObject(forEntityName: "Remind", into: context!) as! Remind
        remind.titleRemind = object["titleofRemind"] as? String
        remind.subtitleRemind = object["subtitleofRemind"] as? String
        remind.dateTime = object["date&Time"] as? Date
        remind.id = Int16(object["ids"] as? Int ?? 0)
        
        do{
            print("DATA",remind)
            try context?.save()
        }catch{
            print("Data not saved.")
        }
    }
    
    // this function for fetch data from database
    func fetchData() -> [Remind]{
        var remind = [Remind]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Remind")
        do{
            remind = try context?.fetch(fetchRequest) as! [Remind]
        }catch{
            print("Can not get data!")
        }
        return remind
    }
    
    // Delete function
    func deleteData(index: Int) -> [Remind]{
        var remind = fetchData()
        context?.delete(remind[index])
        remind.remove(at: index)
        do{
             try context?.save()
        }catch{
            print("Can not be delete data.")
        }
        return remind
    }
    
    // Edit Function
    func editObject(object: [String: Any], i: Int){
         var remind = fetchData()
        remind[i].titleRemind = object["titleofRemind"] as? String
        remind[i].subtitleRemind = object["subtitleofRemind"] as? String
        remind[i].dateTime = object["date&Time"] as? Date
        remind[i].id = Int16(object["ids"] as? Int ?? 0)
        do{
            try context?.save()
        }catch{
            print("can not edit data")
        }
    }
    
}
