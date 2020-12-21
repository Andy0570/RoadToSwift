/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import CoreData

public class CoreDataManager {
  public static let shared = CoreDataManager()
  
  private let diskManager = DiskCacheManager()
  private let container: NSPersistentContainer
  
  private init() {
    let persistentContainer = NSPersistentContainer(name: "Wendercast")
    let storeURL = diskManager.databaseURL
    let storeDescription = NSPersistentStoreDescription(url: storeURL)
    persistentContainer.persistentStoreDescriptions = [storeDescription]
    
    persistentContainer.loadPersistentStores { description, error in
      if let error = error {
        preconditionFailure("Unable to configure persistent container: \(error)")
      }
    }
    
    container = persistentContainer
  }
  
  func fetchPodcastItems() -> [PodcastItem] {
    let managedObjectContext = container.viewContext
    let fetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: "publishedDate", ascending: false)
    ]
    
    do {
      let results: [Podcast] = try managedObjectContext.fetch(fetchRequest)
      let finalResults = results.map { podcast in
        podcast.toPodcastItem()
      }
      
      return finalResults
    } catch {
      print("Podcast fetch error: \(error)")
      return []
    }
  }
  
  public func savePodcastItems(_ podcastItems: [PodcastItem]) {
    var newPodcasts: [Podcast] = []
    for podcastItem in podcastItems {
      
      let podcastFetchResult = fetchPodcast(byLinkIdentifier: podcastItem.link)
      
      if podcastFetchResult == nil {
        let podcast = Podcast(context: container.viewContext)
        podcast.title = podcastItem.title
        podcast.link = podcastItem.link
        podcast.publishedDate = podcastItem.publishedDate
        podcast.streamingURL = podcastItem.streamingURL
        podcast.isFavorite = podcastItem.isFavorite
        podcast.detail = podcastItem.detail
        
        newPodcasts.append(podcast)
      }
    }
    
    saveContext()
  }
  
  func fetchPodcast(byLinkIdentifier linkIdentifier: String) -> Podcast? {
    let fetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
    let predicate = NSPredicate(format: "link == %@", linkIdentifier)
    fetchRequest.predicate = predicate
    fetchRequest.fetchLimit = 1
    
    let result = try? container.viewContext.fetch(fetchRequest)
    return result?.first
  }
  
  func updatePodcaseFavoriteSetting(_ podcastLink: String, isFavorite: Bool) {
    guard let podcast = fetchPodcast(byLinkIdentifier: podcastLink) else {
      return
    }
    
    podcast.isFavorite = isFavorite
    
    saveContext()
  }
  
  func saveContext() {
    do {
      try container.viewContext.save()
    } catch {
      preconditionFailure("Unable to save context: \(error)")
    }
  }
}
