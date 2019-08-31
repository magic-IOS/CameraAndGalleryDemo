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
        CamaraPhotosAndFileManager.sharedInstance.openCamaraAndPhotoLibrary(self, { (image, strImageName, error) in
            
            guard let imgProfile = image,let imageName = strImageName else{
                return
            }
            
            print(" imgProfile ",String(describing: imgProfile))
            print(" imageName ",String(describing: imageName))
            
        }) {(data, url, error) in
            guard let data = data,let url = url else{return}
            print(" data ",String(describing: data))
            print(" url ",String(describing: url))
        }
    }
    
}

