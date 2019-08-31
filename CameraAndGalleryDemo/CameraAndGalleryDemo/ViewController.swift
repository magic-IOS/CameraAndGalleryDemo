//
//  ViewController.swift
//  CameraAndGalleryDemo
//
//  Created by magic-IOS on 31/08/19.
//  Copyright © 2019 magic-IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnCameraAction(_ sender: UIButton) {
        CameraAndGalleryPermisson.sharedInstance.openCamaraAndPhotoLibrary(self) { (image, strName, error) in
            print("==>> error ",String(describing: error?.localizedDescription))
            print("==>> strName ",String(describing: strName))
            print("==>> image ",String(describing: image))
        }
    }
    
}

