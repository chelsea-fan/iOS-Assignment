//
//  ImageUtility.swift
//  iOS Assignment
//
//  Created by Swarandeep on 12/05/24.
//

import Foundation
import UIKit

class ImageClass {
    
    private let cacheDirectory: String
    private let imageCache = NSCache<AnyObject, UIImage>()
    static let shared = ImageClass()
    
    private init() {
        // Create cache directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        cacheDirectory = documentsDirectory.appendingPathComponent("ImageCache").path
        
        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: cacheDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating cache directory: \(error)")
            }
        }
    }
    
    func fetchImage(url: String, id: String, completion: @escaping (UIImage) -> ()) -> URLSessionDataTask?  {
        if let url = URL(string: url) {
            let task = fetchImage(url: url, id: id, completion: completion)
            return task
        }
        return nil
    }
    
    func fetchImage(url: URL, id: String, completion: @escaping (UIImage) -> ()) -> URLSessionDataTask? {
        // first check whether image is present in memory cache
        if let imageFromMemoryCache = imageCache.object(forKey: id as AnyObject) {
            DispatchQueue.main.async {
                completion(imageFromMemoryCache)
            }
            return nil
        }
        
        // if image is not present in memory cache, check for disk cache
        if let imageFromDiskCache = loadImageFromDiskCache(forKey: id) {
            imageCache.setObject(imageFromDiskCache, forKey: id as AnyObject)
            DispatchQueue.main.async {
                completion(imageFromDiskCache)
            }
            return nil
        }
        
        // if image is not present in both the caches, load image by API calling
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, urlResponse, error in
            guard let self = self else { return }
            if let error = error {
                print("Error with fetching \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: id as AnyObject)
                self.saveImageToDiskCache(image: image, forKey: id)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        task.resume()
        return task
    }
    
    func loadImageFromDiskCache(forKey key: String) -> UIImage? {
        let filePath = cacheDirectory + "/" + key
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let data = FileManager.default.contents(atPath: filePath) {
                return UIImage(data: data)
            }
        }
        return nil
    }
    
    func saveImageToDiskCache(image: UIImage, forKey key: String) {
        let filePath = cacheDirectory + "/" + key
        if let data = image.jpegData(compressionQuality: 1.0) {
            FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        }
    }
}
