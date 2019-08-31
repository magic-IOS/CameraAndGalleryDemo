
import UIKit
import AssetsLibrary
import Photos
import PhotosUI

class CameraAndGalleryPermisson: NSObject{
    static let sharedInstance = CameraAndGalleryPermisson()
    
    public typealias imageComplition = ( _ image : UIImage?,_ strName : String?,_ error : Error?) -> Void
    var complation = {( _ image : UIImage?,_ strName : String?,_ error : Error?) -> Void in  }
    
    override init() {
        super.init()
    }
    
    func openCamaraAndPhotoLibrary(_ viewController : UIViewController,isEdit : Bool = true,_ imageComplition : @escaping imageComplition){
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            UIAlertAction in
            self.openCamara(viewController, isEdit: isEdit, imageComplition)
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: .default) {
            UIAlertAction in
            self.openPhotoLibrary(viewController, isEdit: isEdit, imageComplition)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamara(_ vc : UIViewController,isEdit : Bool,_ imageComplition : @escaping imageComplition){
        
        
        CameraAndGalleryPermisson.sharedInstance.checkPermissionForCamera(authorizedRequested: {
            let picker = UIImagePickerController()
            picker.delegate = self
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.allowsEditing = isEdit
                picker.isEditing = isEdit
                vc.present(picker, animated: true, completion: nil)
                self.complation = imageComplition
            }
            else {
                
                    vc.showAlert(string: "You don't have camera")
                
               //vc.showAlertWithTitle(title: "Warning", string: "You don't have camera")
            }
        }) {
            
            vc.showAlertWithOkAndCancelHandler(string: "Please allow access to camera permission.", strOk: "Settings", strCancel: "Cancel", handler: { (isSettings) in
                if isSettings{
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: { (_ ) in
                        
                    })
                }
            })
        }
    }
    
    func openPhotoLibrary(_ vc : UIViewController,isEdit : Bool,_ imageComplition : @escaping imageComplition){
        self.checkPhotoLibraryPermission(authorizedRequested: {
            if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                picker.allowsEditing = isEdit
                picker.isEditing = isEdit
                
                vc.present(picker, animated: true, completion: nil)
                self.complation = imageComplition
            }else{
                //no photoLibrary
                vc.showAlert(string: "You don't have photoLibrary")
                
            }
        }) {
            //deniedRequested
            vc.showAlertWithOkAndCancelHandler(string: "Please allow access to Photo Library permission.", strOk: "Settings", strCancel: "Cancel", handler: { (isSettings) in
                if isSettings{
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: { (_ ) in
                        
                    })
                }
            })
        }
        
    }
    
    private func checkPermissionForCamera(authorizedRequested : @escaping () -> Swift.Void,deniedRequested : @escaping () -> Swift.Void) -> Void {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            authorizedRequested()
        }
        else if AVCaptureDevice.authorizationStatus(for: .video) ==  .denied || AVCaptureDevice.authorizationStatus(for: .video) ==  .restricted {
            //restricted
            deniedRequested()
            
        }else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    authorizedRequested()
                } else {
                    deniedRequested()
                }
            })
        }
    }
    
    private func checkPhotoLibraryPermission(authorizedRequested : @escaping () -> Swift.Void,deniedRequested : @escaping () -> Swift.Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            authorizedRequested()
            break
        case .denied, .restricted :
            //handle denied status
            deniedRequested()
            break
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    // as above
                    authorizedRequested()
                    break
                case .denied, .restricted:
                    deniedRequested()
                    break
                case .notDetermined:
                    // won't happen but still
                    break
                 default:
                    break;
                }
            }
            break
         default:
            break;
        }
    }
    
    
    
}

extension CameraAndGalleryPermisson : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker .dismiss(animated: true, completion: nil)
        var image : UIImage?
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = img
        }else if let originalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image = originalImg
        }else{
            image = nil
        }
        var strImageName = ""
        if (info[.imageURL] as? NSURL) != nil {
            let imageUrl          = info[.imageURL] as! NSURL
            let imageName :String! = imageUrl.pathExtension
            strImageName = "\(Int(Date().timeIntervalSince1970))."
            strImageName = strImageName.appending(imageName)
        }else{
            strImageName = "\(Int(Date().timeIntervalSince1970)).png"
        }
        guard image != nil else {
            self.complation(nil,nil,"enable to get image" as? Error)
            return
        }
        self.complation(image,strImageName,nil)
        
    }
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
        
        self.complation(nil,nil,nil)
    }
}

extension UIViewController {
    func showAlertWithOkAndCancelHandler(string: String,strOk:String,strCancel : String,handler: @escaping (_ isOkBtnPressed : Bool)->Void)
    {
        let alert = UIAlertController(title: "", message: string, preferredStyle: .alert)
        
        let alertOkayAction = UIAlertAction(title: strOk, style: .default) { (alert) in
            handler(true)
        }
        let alertCancelAction = UIAlertAction(title: strCancel, style: .default) { (alert) in
            handler(false)
        }
        alert.addAction(alertCancelAction)
        alert.addAction(alertOkayAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func showAlert(string:String) -> Void {
        let alert : UIAlertController = UIAlertController(title: "", message: string, preferredStyle: .alert)
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
        }
        alert.addAction(alertCancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
