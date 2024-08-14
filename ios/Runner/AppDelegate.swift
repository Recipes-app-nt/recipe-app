import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var flutterResult: FlutterResult?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let mediaChannel = FlutterMethodChannel(name: "media_picker", binaryMessenger: controller.binaryMessenger)
    
    mediaChannel.setMethodCallHandler { (call, result) in
      self.flutterResult = result
      if call.method == "pickMedia" {
        guard let args = call.arguments as? [String: String], let mediaType = args["type"] else {
          result(FlutterError(code: "ERROR", message: "Invalid arguments", details: nil))
          return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = mediaType == "image" ? ["public.image"] : ["public.movie"]
        picker.sourceType = .photoLibrary
        controller.present(picker, animated: true, completion: nil)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
      flutterResult?(url.path)
    } else if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
      flutterResult?(url.path)
    } else {
      flutterResult?(FlutterError(code: "ERROR", message: "Failed to pick media", details: nil))
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
    flutterResult?(FlutterError(code: "CANCELLED", message: "User cancelled media picking", details: nil))
  }
}
