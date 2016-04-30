//
//  FullImageViewController
//  Thrive Pregnancy
//
//  Created by Andrew on 5/12/15.
//  Copyright © 2015 Andrew. All rights reserved.
//

import UIKit
import Foundation



class FullImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!;
    @IBOutlet var scrollView: UIScrollView!;
    
    var image: UIImage?;
    
    func goBack(){
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad(){
        
        if (image != nil){
            imageView.image = image;
            scrollView.contentSize = imageView.image!.size;
        } else {
            print("image is nil in viewDidLoad of FullImageViewController")
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "goBack");
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(tapRecognizer);
        
        scrollView.minimumZoomScale = 1.0
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }
    
    
}
