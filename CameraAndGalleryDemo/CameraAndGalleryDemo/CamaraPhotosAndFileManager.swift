

import UIKit
import AssetsLibrary
import Photos
import PhotosUI

class CamaraPhotosAndFileManager: NSObject{
    
    static let sharedInstance = CamaraPhotosAndFileManager()
    
    public typealias imageComplition = ( _ image : UIImage?,_ strName : String?,_ error : Error?) -> Void
    var complation = {( _ image : UIImage?,_ strName : String?,_ error : Error?) -> Void in  }
    
    public typealias fileComplition = ( _ file : Data?,_ fileUrl : URL?,_ error : Error?) -> Void
    var complationFile = {( _ file : Data?,_ fileUrl : URL?,_ error : Error?) -> Void in  }
    
    
    
    override init() {
        super.init()
    }
    
    func openCamaraAndPhotoLibrary(_ viewController : UIViewController,isEdit : Bool = true,_ imageComplition : @escaping imageComplition,_ fileComplition : @escaping fileComplition){
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            UIAlertAction in
            CameraAndGalleryPermisson.sharedInstance.openCamara(viewController, isEdit: isEdit, imageComplition)
            
            fileComplition(nil,nil,nil)
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: .default) {
            UIAlertAction in
            CameraAndGalleryPermisson.sharedInstance.openPhotoLibrary(viewController, isEdit: isEdit, imageComplition)
            fileComplition(nil,nil,nil)
        }
        let fileAction = UIAlertAction(title: "Document", style: .default) {
            UIAlertAction in
            imageComplition(nil,nil,nil)
            self.openFileForiCloud(viewController, fileComplition)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(fileAction)
        alert.addAction(cancelAction)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openFileForiCloud(_ viewController : UIViewController,isEdit : Bool = true,_ fileComplition : @escaping fileComplition){
        let types = ["public.item"]
        let picker = UIDocumentPickerViewController(documentTypes: types as [String], in: .open)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        viewController.present(picker, animated: true, completion: nil)
        self.complationFile = fileComplition
    }
    
}

extension CamaraPhotosAndFileManager : UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard
            controller.documentPickerMode == .open,
            let url = urls.first,
            url.startAccessingSecurityScopedResource()
        else {
            return
        }
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        do {
            
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                self.complationFile(data,url,nil)
            }
        }
        catch {
            DispatchQueue.main.async {
                self.complationFile(nil,nil,error)
            }
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL){
        
        guard
            controller.documentPickerMode == .open,
            url.startAccessingSecurityScopedResource()
        else {
            return
        }
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        do {
            
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                self.complationFile(data,url,nil)
            }
        }
        catch {
            DispatchQueue.main.async {
                self.complationFile(nil,nil,error)
            }
        }
    }
}

