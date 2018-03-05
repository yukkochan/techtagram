//
//  ViewController.swift
//  Techtagram
//
//  Created by Yukiko Kida on 2018/02/16.
//  Copyright © 2018年 Yukiko. All rights reserved.
//

import UIKit
import  Accounts

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    private var myTextField: UITextField!
    
    var imageNameArray: [String] = ["pom"]
    var imageIndex: Int = 0
    var imageView: UIImageView!
 
    
    @IBOutlet var cameraImageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    
    
    var originalImage: UIImage!
    var filter: CIFilter!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tWidth: CGFloat = 200
        let tHeight: CGFloat = 30
        let posX: CGFloat = (self.view.bounds.width - tWidth)/2
        let posY: CGFloat = 300
        
        
        myTextField = UITextField(frame: CGRect(x: posX, y: posY, width: tWidth, height: tHeight))
        myTextField.text = "Hello"
        myTextField.delegate = self
        myTextField.borderStyle = .roundedRect
        myTextField.clearButtonMode = .whileEditing
        self.view.addSubview(myTextField)
        
       
    }
    

        
        
        
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self.view)
        
        if imageIndex != 0 {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            
            let image: UIImage = UIImage(named: imageNameArray[imageIndex - 1])!
            imageView.image = image
            
//            imageView.center = CGPoint(x: location.x, y: location.y)
//            print(imageView.center.y)
//            let y = imageView.center.y
//            if y < 420  {
//                self.view.addSubview(imageView)
            if (30...320 ~= location.x  && 220...510 ~= location.y )  {
                self.view.addSubview(imageView)
                imageView.center = CGPoint(x: location.x, y: location.y)
            } else {
                
            }
            
            
        }
    }
    
    @IBAction func selectedstamp() {
        imageIndex = 1
    }
    
    @IBAction func useCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        } else {
            print("error")
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        originalImage = cameraImageView.image
        dismiss(animated: true, completion: nil)
    }
    
//    func drawText(image: UIImage) -> UIImage {
//        let text = "photo by Yukiko"
//        let textFontAttributes = [
//            NSAttributedStringKey.font: UIFont(name: "Arial", size: 25)!,
//            NSAttributedStringKey.foregroundColor: UIColor.white
//        ]
//
//        UIGraphicsBeginImageContext(image.size)
//        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
//
//        let margin: CGFloat = 5.0
//        let textRect = CGRect(x: margin, y: margin, width: image.size.width - margin, height: image.size.height - margin)
//
//        text.draw(in: textRect, withAttributes: textFontAttributes)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//
//    }
//
    
//    @IBAction func onTappedTextButton() {
//        if cameraImageView.image != nil {
//            cameraImageView.image = drawText(image: cameraImageView.image!)
//
//        } else {
//            print("画像がありません")
//        }
//    }
//
    
    
    
    @IBAction func applyFilter() {
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
//
//        filter.setValue(1.0, forKey: "inputSaturation")
//        filter.setValue(0.5, forKey: "inputBrightness")
//        filter.setValue(2.5, forKey: "inputContrast")
//
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
    }
    
    
    @IBAction func save() {
//        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
        let rect:CGRect = CGRect(x: 0, y:200, width: 376, height: 620)
        UIGraphicsBeginImageContext(rect.size)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let capture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        フォトライブラリに保存
        UIImageWriteToSavedPhotosAlbum(capture!, nil, nil, nil)
        
    }
    @IBAction func openAlbum() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated:  true, completion:  nil)
        }
        
    }
    @IBAction func share() {
        
        let shareText = "写真加工できた！"
        
        let shareImage = cameraImageView.image!
        
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludeActivityTypes = [UIActivityType.postToWeibo,  .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludeActivityTypes
        
        present(activityViewController, animated:  true, completion:  nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing: \(textField.text!)")

        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing: \(textField.text!)")

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn \(textField.text!)")
        label.text = textField.text
      
        
        // 改行ボタンが押されたらKeyboardを閉じる処理.
        textField.resignFirstResponder()
        textField.text = ""
        myTextField.removeFromSuperview()
        
        return true
    }
   

}

