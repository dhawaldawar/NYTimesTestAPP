//
//  ImageDownloadAManager.swift
//  Test-NYTimes
//
//  Created by Dhawal ideavate on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDownloadDelegate : class{
    func didDownloadImage(image : UIImage, url : URL)
}

protocol ImageDownloadManager {
    var delegate: ImageDownloadDelegate! {set get}
    func downloadImageWithURL(_ url : URL)
}

class ImageDownloadManagerImplementation : NSObject, ImageDownloadManager{
    weak var delegate: ImageDownloadDelegate!
    private var session : URLSession!
    
    override init() {
        super.init()
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }
    
    func downloadImageWithURL(_ url : URL){
        session.dataTask(with: url) { [weak self](data, response, error) in
            if (data != nil){
                guard let image = UIImage(data: data!) else {
                    return
                }
                self?.delegate.didDownloadImage(image: image, url: url)
            }
        }.resume()
    }
}

extension ImageDownloadManagerImplementation : URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let image = UIImage(contentsOfFile: location.path) else {
            return
        }
        delegate.didDownloadImage(image: image, url: downloadTask.originalRequest!.url!)
    }
}



