//
//  MediaObjectModel.swift
//  AVFoundation-MediaFeed
//
//  Created by Tiffany Obi on 4/13/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

//mediaObject instance can either be a video or image

struct MediaObject {
    let imageData: Data?
    let videoURL: URL?
    let caption:String?
    let id = UUID().uuidString
    let createdOn = Date()
}
