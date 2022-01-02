//
//  Extension+UIViewController.swift
//  OCBC Mobile
//
//  Created by Paninti Duta Internusa on 02/01/22.
//

import Foundation
import AVFoundation
import UIKit

extension UIViewController {
    
    func imageWithImage(withImage image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
