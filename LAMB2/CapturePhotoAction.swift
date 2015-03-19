//
//  CapturePhotoAction
//  LAMB2
//
//  Action that directly captures and saves and image
//  from a CameraSession.
//
//  It's generally preferable to use an ImageProccessorAction
//  with IPImageCapture instead of this class.
//
//  Created by Fletcher Lab Mac Mini on 2/20/15.
//  Copyright (c) 2015 Fletchlab. All rights reserved.
//

import Foundation

class CapturePhotoAction : AbstractAction, PhotoAlbumSaveDelegate {
    let album: PhotoAlbum
    let camera: CameraSession
    let id: String
    
    init(album: PhotoAlbum, camera: CameraSession) {
        self.album = album
        self.camera = camera
        self.id = album.albumName + " save action " + NSNumber(double: NSDate().timeIntervalSince1970).stringValue
    }
    
    func onSavePhotoComplete(success: Bool) {
        album.removeSaveDelegate(id)
        finish()
    }
    
    override func doExecution() {
        var img = camera.captureImage()
        if (img != nil) {
            album.addSaveDelegate(self, id: id)
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.album.savePhoto(img)
            }
        } else {
            NSLog("Failed to capture image. Has capture been enabled?")
            finish()
        }
        
    }
    
}