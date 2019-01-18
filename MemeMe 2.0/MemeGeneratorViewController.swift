//
//  ViewController.swift
//  MemeMe 2.0
//
//  Created by Giordany Orellana on 12/17/18.
//  Copyright © 2018 Giordany Orellana. All rights reserved.
//

import UIKit

class MemeGeneratorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: IBOUTLETS
    /////////////////
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    
    //MARK: OVERRIDES
    /////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(tf: topText, text: "TOP")
        setupTextField(tf: bottomText, text: "BOTTOM")
        
        shareButton.isEnabled = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //checks to make sure the camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Subscribe to the keyboard notification, to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK: KEYBOARD FUNCTIONS
    //////////////////////////
    
    @objc func subscribeToKeyboardNotifications() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        //shift view frame up for keyboard
        
        if bottomText.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        //reset view frame
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        //Gets the size of the keyboard
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    //MARK: IMAGE PICKER CONTROLLERS
    //////////////////////////
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Sets up the controller to select a picture from album
        
        guard let selectedImage = info[.originalImage] as? UIImage
            
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //TEXT FIELD DELEGATE FUNCS
    //////////////////////////
    
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = [
            
            //Sets the text style of Top and Bottom text fields
            
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -6.0]
        
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
        tf.adjustsFontSizeToFitWidth = true
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //Clears textfield for editing
        
        textField.clearsOnBeginEditing = true
        
        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Gets rid of the keybloard after pressing return
        
        topText.resignFirstResponder()
        bottomText.resignFirstResponder()
        return true
    }
    
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        
        //Sets the text style of Top and Bottom text fields
        
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -6.0]
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        
        hidePeskyToolBars(isShowing: true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: imageView.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hidePeskyToolBars(isShowing: false)
        
        return memedImage
    }
    
    func hidePeskyToolBars(isShowing: Bool) {
        topToolBar.isHidden = isShowing
        bottomToolBar.isHidden = isShowing
    }
    func save(image: UIImage) {
        
        //Save image struct
        
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: image)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    func imageController(sourceType type: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: IBACTIONS
    //////////////////////////
    
    @IBAction func pickAnImage(_ sender: Any) {
        
        //Allows to take a picture from the album
        
        imageController(sourceType: .savedPhotosAlbum)
        
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        //Allows to take a picture with the camera
        imageController(sourceType: .camera)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        
        //Allows for the sharing of the image
        
        navigationController?.setToolbarHidden(true, animated: false)
        
        let image = generateMemedImage()
        let item = [image]
        let avc = UIActivityViewController(activityItems: item, applicationActivities: nil)
        
        avc.completionWithItemsHandler = {(activity, completed, items, error) in
            
            if !completed {
                //User Cancelled
                return
            }
            //User Activity
            self.save(image: image)
            self.dismiss(animated: true, completion: nil)
        }
        
        present(avc, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any){
        
        // cancel button resets the screen
        dismiss(animated: true, completion: nil)
                
    }
}

