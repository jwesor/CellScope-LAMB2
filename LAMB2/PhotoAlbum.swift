//
//  PhotoAlbum.swift
//  LAMB2
//
//  Class that handles saving photos to albums.
//  Note that the AssetsLibrary framework is currently bugged,
//  and so we cannot programmatically create an album with the
//  same name as an album that has previously been deleted.
//  As a workaround, the current date/time will be automatically
//  added to any new album created.
//
//  Created by Fletcher Lab Mac Mini on 2/20/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation
import AssetsLibrary


class PhotoAlbum {
    
    let library: ALAssetsLibrary
    let albumName: NSString
    var delegates: [String: PhotoAlbumSaveDelegate]
    
    init(name: String) {
        delegates = Dictionary<String, PhotoAlbumSaveDelegate>()
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormat.timeStyle = NSDateFormatterStyle.ShortStyle
        self.albumName = name + " " + dateFormat.stringFromDate(NSDate())
        library = ALAssetsLibrary()
        
        library.addAssetsGroupAlbumWithName(albumName,
            resultBlock: { (group: ALAssetsGroup!) -> Void in
                NSLog("added album: %@", group != nil)
            }, failureBlock: { (error: NSError!) -> Void in
                NSLog("error adding album")
            }
        )
    }
    
    func addSaveDelegate(delegate: PhotoAlbumSaveDelegate, id:String) {
        delegates[id] = delegate
    }
    
    func removeSaveDelegate(id: String) {
        delegates[id] = nil
    }
    
    func savePhoto(image: UIImage) {
        var albumGroup:ALAssetsGroup? = nil
        library.enumerateGroupsWithTypes(ALAssetsGroupAll,
            usingBlock: { (group: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if (group == nil) {
                    self.writeImageToAlbum(image, albumGroup: albumGroup)
                }
                if group != nil && group.valueForProperty(ALAssetsGroupPropertyName).isEqualToString(self.albumName) {
                    NSLog("found album %@", self.albumName)
                    albumGroup = group
                }
            }, failureBlock: { (error: NSError!) -> Void in
                NSLog("Failed to enumerate albums.\nError: %@", error.localizedDescription)
                self.notifyCompletion(false)
            }
        )
    }
    
    func writeImageToAlbum(image: UIImage, albumGroup:ALAssetsGroup?) {
        let data = UIImagePNGRepresentation(image)
        library.writeImageDataToSavedPhotosAlbum(data, metadata: nil,
            completionBlock: { (assetURL: NSURL!, error: NSError!) -> Void in
                if (error == nil || error.code == 0) {
                    NSLog("Saved image complete: %@", assetURL)
                    self.library.assetForURL(assetURL,
                        resultBlock: { (asset:ALAsset!) -> Void in
                            albumGroup?.addAsset(asset)
                            NSLog("Added to album: %@", albumGroup != nil)
                        }, failureBlock: { (error:NSError!) -> Void in
                            NSLog("Asset retrieve failed with error code %i\n%@", error.code, error.localizedDescription)
                        }
                    )
                    self.notifyCompletion(true)
                } else {
                    NSLog("Saved image failed with error code %i\n%@", error.code, error.localizedDescription)
                    self.notifyCompletion(false)
                }
            }
        )
    }
    
    func notifyCompletion(success: Bool) {
        for (id, delegate) in delegates {
            delegate.onSavePhotoComplete(success)
        }
    }
}

protocol PhotoAlbumSaveDelegate {
    func onSavePhotoComplete(success: Bool);
}