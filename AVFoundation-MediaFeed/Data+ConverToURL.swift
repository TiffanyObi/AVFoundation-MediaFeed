//
//  Data+ConverToURL.swift
//  AVFoundation-MediaFeed
//
//  Created by Tiffany Obi on 4/15/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

extension Data {
    //use case example
    //mediaObject.videoData.convertToURL()
    //optional because it might fail
    //creates a temporary URL

    public func convertToURL() -> URL?{
        //create a temporary URL
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
        
        do{
            try self.write(to: tempURL, options: [.atomic])
        }catch {
            print("failed to write (save) video data to temporary with error: \(error)")
        }
        return nil
}
}
