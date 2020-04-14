//
//  URL + Extensions.swift
//  AVFoundation-MediaFeed
//
//  Created by Tiffany Obi on 4/13/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import AVFoundation

extension URL {
    public func videoPreciewThumbnail()->UIImage? {
        //create an AVAsset instance
        //ex.mediaObjects.videoURL
        let asset = AVAsset(url: self) // self is the URL instance
        
        //the AVAssetImageGenerator is an AVFoundation class that converts a goven media url to an image
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        //we want to ,maintain the aspect ratio of the video
        assetGenerator.appliesPreferredTrackTransform = true
        //create a timestamp of needed second in the video
        //we will useCMTime to generate the given time stamp
        //CMTime is part of CoreMedia
        
        let timeStamp  = CMTime(seconds: 1, preferredTimescale: 60)
        
        var image:UIImage?
        
        do {
            let cgImage = try assetGenerator.copyCGImage(at: timeStamp, actualTime: nil)
            image = UIImage(cgImage: cgImage)
            
            //lower level api doesnt know about UIKit, AVKit
            //change the color of the UIViewBorder
            //someView.layer.borderColor = UIColor.green/cgColor
        } catch {
            print("failed to generate image")
        }
        return image
    }
}
