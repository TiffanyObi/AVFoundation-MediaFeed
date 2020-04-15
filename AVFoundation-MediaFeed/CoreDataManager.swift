//
//  CoreDataManager.swift
//  AVFoundation-MediaFeed
//
//  Created by Tiffany Obi on 4/14/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    private init(){}
    //this is refactoring the project to CoreData for persistence
    static let shared = CoreDataManager()
    
    private var mediaObjects = [CDMediaObject]()
    
    //get instance of the NSManagedObjectContext from AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //NSManagedObjectContext does saving, fetfching n NSManagedObjects
    
    //CRUD - create
    
    
    // we'll be converting a UIImage to Data
    func create(_ imageData:Data, videoURL: URL?)-> CDMediaObject {
        let mediaObject = CDMediaObject(entity: CDMediaObject.entity(), insertInto: context)
        mediaObject.createdDate = Date() //current Date
        mediaObject.id = UUID().uuidString //unique string
        mediaObject.imageData = Data()
        
        if let videoURL = videoURL { //if this exsists then we know we are comin from a video object
            //we need to convert the url to data
            do {
                mediaObject.videoData = try Data(contentsOf: videoURL)
            } catch {
                print("failed to convert URL to Data with error: \(error)")
            }
        }
        
        //save the newly created MediaObject instance to the NCManagedObject.
        
        do {
            try context.save()
        } catch {
            print("failed to save newly created mediaObject with error: \(error)")
        }
        
        return mediaObject
    }
    
    // read
    func fetchMediaObjects() {
        
        do {
            mediaObjects = try context.fetch(CDMediaObject.fetchRequest()) //fetch all the created objects from the CdMediaObjects entity
        } catch {
            print("failed to fetch media objects with error: \(error)")
        }
    }
    
    //update
    
    
    //delete
}
