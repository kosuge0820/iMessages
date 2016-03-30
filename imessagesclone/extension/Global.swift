//
//  Global.swift
//  Teams
//
//  Created by Ryosuke Fukuda on 9/27/15.
//  Copyright © 2015 Ryo. All rights reserved.
//

import UIKit
import Parse

extension UIImage
{
    public func createPFFile() -> PFFile!
    {
        let ratio = self.size.width / self.size.height
        let resizedImage = resizeImage(self, toWidth: ImageSize.height * ratio, andHeight: ImageSize.height)
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)!
        return PFFile(name: "image.jpg", data: imageData)
    }
    
    private struct ImageSize {
        static let height: CGFloat = 480.0
    }
    
    private func resizeImage(originalImage: UIImage, toWidth width: CGFloat, andHeight height: CGFloat) -> UIImage
    {
        let newSize = CGSizeMake(width, height)
        let newRectangle = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(newSize)
        originalImage.drawInRect(newRectangle)
        
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}