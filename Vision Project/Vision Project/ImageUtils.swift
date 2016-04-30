//
//  ImageUtils.swift
//  Thrive Pregnancy
//
//  Created by Andrew on 13/12/15.
//  Copyright © 2015 Andrew. All rights reserved.
//

import UIKit

class ImageUtils: NSObject {
    
    static func cropToSquare(originalImage: UIImage) -> UIImage
    {
        
        let originalWidth  = originalImage.size.width
        let originalHeight = originalImage.size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0
        
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - originalHeight) / 2.0
            y = 0.0
            
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
        
        let cropSquare = CGRectMake(x, y, edge, edge)
        let imageRef = CGImageCreateWithImageInRect(originalImage.CGImage, cropSquare);
        
        return UIImage(CGImage: imageRef!, scale: 0, orientation: originalImage.imageOrientation)
    }
    
    
    
    static func fixOrientation(originalImage: UIImage) -> UIImage
    {
        
        if originalImage.imageOrientation == UIImageOrientation.Up {
            return originalImage
        }
        
        var transform = CGAffineTransformIdentity
        
        switch originalImage.imageOrientation {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.width, originalImage.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
            
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
            
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, originalImage.size.height);
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2));
            
        case .Up, .UpMirrored:
            break
        }
        
        
        switch originalImage.imageOrientation {
            
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1);
            
        default:
            break;
        }
        
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGBitmapContextCreate(
            nil,
            Int(originalImage.size.width),
            Int(originalImage.size.height),
            CGImageGetBitsPerComponent(originalImage.CGImage),
            0,
            CGImageGetColorSpace(originalImage.CGImage),
            UInt32(CGImageGetBitmapInfo(originalImage.CGImage).rawValue)
        )
        
        CGContextConcatCTM(ctx, transform);
        
        switch originalImage.imageOrientation {
            
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, originalImage.size.height,originalImage.size.width), originalImage.CGImage);
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, originalImage.size.width,originalImage.size.height), originalImage.CGImage);
            break;
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx)
        
        let img = UIImage(CGImage: cgimg!)
        
        //CGContextRelease(ctx);
        //CGImageRelease(cgimg);
        
        return img;
        
    }
    
}
