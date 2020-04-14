//
//  MediaCell.swift
//  AVFoundation-MediaFeed
//
//  Created by Tiffany Obi on 4/13/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    public func configureCell(for mediaObject: MediaObject){
        if let imageData = mediaObject.imageData {
            mediaImageView.image = UIImage(data: imageData)
        }
        
        if let videoURL = mediaObject.videoURL {
            let image = videoURL.videoPreciewThumbnail() ?? UIImage(systemName: "heart")
            mediaImageView.image = image
        }
    }
    
    // TODOcreate media preview thumbnail
    
    
    
}
