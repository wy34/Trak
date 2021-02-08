//
//  CoreDataManager.swift
//  TrackingApp
//
//  Created by William Yeung on 12/18/20.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ActivitySession")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()

    // MARK: - CRUD
    func createActivity(withSnapshot snapshot: UIImage, duration: Int16, pausedDuration: Int16, distance: Double, pausedDistance: Double, coordinates: [Int: [[Double]]], andNote note: String = "") -> ActivitySession {
        let activitySession = ActivitySession(context: persistentContainer.viewContext)
        activitySession.routeSnapshot = snapshot.jpegData(compressionQuality: 0.5)
        activitySession.activityType = ActivityType.undefined.rawValue
        activitySession.coordinatesDictionary = coordinates
        activitySession.pausedDistance = pausedDistance
        activitySession.pausedDuration = pausedDuration
        activitySession.id = UUID().uuidString
        activitySession.duration = duration
        activitySession.distance = distance
        activitySession.activityNote = note
        activitySession.date = Date()
        return activitySession
    }
    
    func save() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchActivities() -> [ActivitySession] {
        let fetchRequest: NSFetchRequest<ActivitySession> = ActivitySession.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteActivity(activity: NSManagedObject) {
        persistentContainer.viewContext.delete(activity)
        save()
    }
    
    func deleteAllActivities() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: ActivitySession.fetchRequest())
        
        do {
            try persistentContainer.viewContext.execute(batchDeleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}
