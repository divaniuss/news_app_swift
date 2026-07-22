//
//  CoreDataManager.swift
//  NewsAppp
//
//  Created by ios developer on 22.07.2026.
//

import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
        
    lazy var persistentContainer: NSPersistentContainer = {
        let conteiner = NSPersistentContainer(name: "NewsDataModel")
        conteiner.loadPersistentStores { description, error in
            if let error = error {
                fatalError("не удалось загрузить бд")
            }
        }
        return conteiner
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveArticle(title: String?, url: String?, urlToImage: String?){
        if isSaved(url: url ?? "") {return}
        
        let favorite = FavoriteArticle(context: context)
        favorite.title = title
        favorite.url = url
        favorite.urlToImage = urlToImage
        
        do {
            try context.save()
            print("saved")
        }catch{
            print("saved error - \(error)")
        }
    }
    
    func isSaved(url: String) -> Bool{
        let request: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        
        do{
            let count = try context.count(for: request)
            return count > 0
        }catch{
            return false
        }
    }
    
    func deleteArticle (url: String){
        let request: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        
        do{
            let articles = try context.fetch(request)
            for object in articles{
                context.delete(object)
            }
            try context.save()
            print("deleted")
        }catch {
            print("delete error - \(error)")
        }
    }
}
