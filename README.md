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
        
3) Open document picker for add document. 

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

Stay connected with us for get custom classes for the ios Development.

Thanks
