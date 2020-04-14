//
//  MediaFeedViewController.swift
//  AVFoundation-MediaFeed
//
//  Created by Tiffany Obi on 4/13/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import AVFoundation //video playback is done using CALayer
//is we want to rounf a view we can only do it using CALayer
import AVKit

class MediaFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var videoButton: UIBarButtonItem!
  
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    
    private lazy var imagePickerController:UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    private var mediaObjects = [MediaObject](){
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            videoButton.isEnabled = false
        }
    }
    
    private func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate =  self
    }

    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem) {
        
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    private func playRandomVideo(in view: UIView){
        // we want all non-nil media objects from the mediaObjects array
        //compactMap - because it return all non-nil values
        
        let videoURLs = mediaObjects.compactMap {$0.videoURL}
        
        if let videoURL = videoURLs.randomElement(){
            let player = AVPlayer(url: videoURL)
            
         //create sublayer (CALayer)
            let playerLayer = AVPlayerLayer(player: player)
            //set its frame
            playerLayer.frame = view.bounds //take up entire view coming in (headerView)
            //set video aspect ratio
            playerLayer.videoGravity = .resizeAspect
            
            //remove all sublayers from headerView
            view.layer.sublayers?.removeAll()
            
            //add the playerLayer to the incoming views layer
            view.layer.addSublayer(playerLayer)
            
            //playVideo
            player.play()
            
        }
    }
    

}

// MARK:- UICollectionView DataSource Methods
extension MediaFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell else {
            fatalError("could not downcast to MediaCell")
        }
        let mediaObject = mediaObjects[indexPath.row]
        cell.configureCell(for: mediaObject)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
            fatalError("could not dequeue a HeaderView")
        }
        playRandomVideo(in: headerView)
        return headerView
    }
}

//MARK:- UICollection Delegate Methods
extension MediaFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth:CGFloat = maxSize.width
        let itemHeight:CGFloat = maxSize.height * 0.40
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaObject = mediaObjects[indexPath.row]
        guard let mediaURL = mediaObject.videoURL else {return}
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: mediaURL)
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            //play video automatically
            player.play()
        }
    }
}

extension MediaFeedViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //InfoKey.originalImage
        //InfoKey.mediaType
        //InfoKey.mediaURL
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        
        switch mediaType {
        case "public.image":
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                let imageData = originalImage.jpegData(compressionQuality: 1.0) {
                    let mediaObject = MediaObject(imageData: imageData, videoURL: nil, caption: nil)
                    mediaObjects.append(mediaObject)
            }
        case "public.movie":
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print("mediaURL : \(mediaURL)")
                let mediaObject = MediaObject(imageData: nil, videoURL: mediaURL, caption: nil)
                mediaObjects.append(mediaObject)
            }
        default:
            print("unsupported media type")
        }
        
        print("mediaType: \(mediaType)") //public.movie , public.image
        picker.dismiss(animated: true, completion: nil)
    }
}
