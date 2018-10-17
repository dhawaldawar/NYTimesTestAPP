//
//  ArticleListCellView.swift
//  Test-NYTimes
//
//  Created by Dhawal ideavate on 17/10/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleListCellView : class{
    var indexPath : IndexPath!{set get}
    
    func displayTitle(_ title : String)
    func displayPublishedBy(_ publishedBy : String)
    func displayDate(_ date : String)
    func displayImage(_ img : UIImage)
}

class ArticleListCellViewImplementation: UITableViewCell,ArticleListCellView {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblPublishedBy : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var imgThumbnail : UIImageView!
    var indexPath : IndexPath!
    
    func displayTitle(_ title : String){
        lblTitle.text = title
    }
    
    func displayPublishedBy(_ publishedBy : String){
        lblPublishedBy.text = publishedBy
    }
    
    func displayDate(_ date : String){
        lblDate.text = date
    }
    
    func displayImage(_ img : UIImage){
        imgThumbnail.image = img
    }
}
