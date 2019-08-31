# CameraAndGalleryDemo

1) add usage description key with in your plist. 
   Note : Make sure description is proper as per apple guide line.
   
    <key>NSPhotoLibraryUsageDescription</key>
    <string>$(PRODUCT_NAME) will use your gallery</string>
    <key>NSCameraUsageDescription</key>
    <string>$(PRODUCT_NAME) will use your camera</string>
    
    
    
2) Add below code to open camera and gallery.

   CameraAndGalleryPermisson.sharedInstance.openCamaraAndPhotoLibrary(self) { (image, strName, error) in
            print("==>> error ",String(describing: error?.localizedDescription))
            print("==>> strName ",String(describing: strName))
            print("==>> image ",String(describing: image))
        }
        
        
Stay connected with us for get custom classes for the ios Development.

Thanks
