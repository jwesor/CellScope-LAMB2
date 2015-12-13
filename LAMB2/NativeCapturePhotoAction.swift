//
//  NativeCapturePhotoAction
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 12/12/15.
//  Copyright © 2015 Fletchlab. All rights reserved.
//

import Foundation
import AVFoundation

class NativeCapturePhotoAction: AbstractAction {
    
    let camera: NativeCameraSession
    let album: PhotoAlbum
    
    init(camera: NativeCameraSession, album: PhotoAlbum) {
        self.camera = camera
        self.album = album
        super.init()
    }
    
    override func doExecution() {
        let videoConnection = camera.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        print("acquired video connection!")
        if videoConnection == nil {
            print("failed...")
            finish()
        } else {
            camera.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection!, completionHandler: onCaptureCompleted)
        }
    }
    
    func onCaptureCompleted(buffer: CMSampleBuffer!, error: NSError!) {
        print("image capture complete!")
        if error == nil {
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            let uiImage = UIImage(data: data)
            if let image = uiImage {
                album.savePhoto(image)
            } else {
                print("no image buffer data found")
            }
//            let imageBuffer = CMSampleBufferGetImageBuffer(buffer)
//            let ciImage = CIImage(CVImageBuffer: imageBuffer!)
//            let context = CIContext()
//            let cgRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(imageBuffer!), height: CVPixelBufferGetHeight(imageBuffer!))
//            let cgImage = context.createCGImage(ciImage, fromRect: cgRect)
//            let uiImage = UIImage(CGImage: cgImage)
        } else {
            print("error: \(error.localizedDescription)")
        }
        finish()
    }
}