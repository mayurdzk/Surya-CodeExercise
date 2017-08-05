//
//  ModelManager.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//
import RealmSwift

struct ModelManager {
    
    //Reviewer's Notes: While using the property isDataStoreAvailable in this way means every function defined within ModelManager will have to check the property before beginning operations, using a different approach--such as using a failable initialiser to have this check done just once--has its own pitfalls: 1) the data store may become inaccessible between initialisaion of the struct and accessing a method. 2) The checks will still occur, except they will be passed on to the calling side instead.
    
    /// Use this property to determine whether the underlying data store is available or not
    private var isDataStoreAvailable: Bool {
        return (try? Realm()) != nil
    }
    
    /// Call this method with an array of items to have them stored to the disk. Any existing items (matched by their emailID) will be over-written.
    /// This method returns a Bool indicating whether the write was successfull or not.
    ///
    /// WARNING: save(items:) is not thread safe. Objects to be saved with this method must be created and saved on the same thread.
    @discardableResult func save(items: [Item]) -> Bool {
        guard isDataStoreAvailable else {
            crashDebug(with: "The Data Store is unavailable")
            return false
        }
        let realm = try! Realm()
        
        realm.beginWrite()
        for item in items {
            realm.add(item, update: true)
        }
        if let _ = try? realm.commitWrite() {
            return true
        } else {
            crashDebug(with: "Couldn't write items to disk")
            return false
        }
    }
    
    /// Call this method with a completion handler; your completion handler will be called with all itemViewModels, on the main thread.
    func itemsAsViewModels(_ completionHandler: @escaping ([ItemViewModel])->Void) {
        guard isDataStoreAvailable else {
            crashDebug(with: "The Data Store is unavailable")
            completionHandler([])
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let realm = try! Realm()
            let allItemsInDataStore = realm.objects(Item.self)
            
            var itemViewModels = [ItemViewModel]()
            for item in allItemsInDataStore {
                itemViewModels.append(ItemViewModel(from: item))
            }
            
            DispatchQueue.main.async {
                completionHandler(itemViewModels)
            }
        }
    }
}
