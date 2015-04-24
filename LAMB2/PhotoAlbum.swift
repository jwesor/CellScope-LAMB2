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

import AssetsLibrary

class PhotoAlbum: ImageFileWriter {
    
    var library: ALAssetsLibrary
    let albumName: String
    var albumCreated: Bool
    var delegates: [String: PhotoAlbumSaveDelegate]
    
    init(name: String, initAlbum: Bool = false) {
        delegates = Dictionary<String, PhotoAlbumSaveDelegate>()
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormat.timeStyle = NSDateFormatterStyle.ShortStyle
        self.albumName = "\(name) \(dateFormat.stringFromDate(NSDate()))"
        library = ALAssetsLibrary()
        albumCreated = initAlbum
        
        if (initAlbum) {
            library.addAssetsGroupAlbumWithName(albumName,
                resultBlock: { (group: ALAssetsGroup!) -> Void in
                }, failureBlock: { (error: NSError!) -> Void in
                    println("error adding album")
                }
            )
        }
    }
    
    func addSaveDelegate(delegate: PhotoAlbumSaveDelegate, id:String) {
        delegates[id] = delegate
    }
    
    func removeSaveDelegate(id: String) {
        delegates[id] = nil
    }
    
    func savePhoto(image: UIImage) {
        writeImage(image)
    }
    
    @objc func writeImage(image: UIImage) {
        if (!albumCreated) {
            library.addAssetsGroupAlbumWithName(albumName,
                resultBlock: { (group: ALAssetsGroup!) -> Void in
                    self.albumCreated = true
                    self.writeImage(image)
                }, failureBlock: { (error: NSError!) -> Void in
                    println("error adding album")
                    self.albumCreated = true
                    self.writeImage(image)
                }
            )
            return
        }
        var albumGroup:ALAssetsGroup? = nil
        library.enumerateGroupsWithTypes(ALAssetsGroupAll,
            usingBlock: { (group: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if (group == nil) {
                    self.writeImageToAlbum(image, albumGroup: albumGroup)
                }
                if group != nil && group.valueForProperty(ALAssetsGroupPropertyName).isEqualToString(self.albumName) {
                    albumGroup = group
                }
            }, failureBlock: { (error: NSError!) -> Void in
                println("Failed to enumerate albums.\nError: \(error.localizedDescription)")
                self.notifyCompletion(false)
            }
        )
    }
    
    func writeImageToAlbum(image: UIImage, albumGroup:ALAssetsGroup?) {
        let data = UIImagePNGRepresentation(image)
        library.writeImageDataToSavedPhotosAlbum(data, metadata: nil,
            completionBlock: { (assetURL: NSURL!, error: NSError!) -> Void in
                if (error == nil || error.code == 0) {
                    self.library.assetForURL(assetURL,
                        resultBlock: { (asset:ALAsset!) -> Void in
                            albumGroup?.addAsset(asset)
                            return
                        }, failureBlock: { (error:NSError!) -> Void in
                            println("Asset retrieve failed with error code \(error.code)\n\(error.localizedDescription)")
                        }
                    )
                    self.notifyCompletion(true)
                } else {
                    println("Saved image failed with error code \(error.code)\n\(error.localizedDescription)")
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