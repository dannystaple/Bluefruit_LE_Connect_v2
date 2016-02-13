//
//  DfuFilesPickerDialogViewController.swift
//  Bluefruit Connect
//
//  Created by Antonio García on 11/02/16.
//  Copyright © 2016 Adafruit. All rights reserved.
//

import UIKit

protocol DfuFilesPickerDialogViewControllerDelegate {
    func onFilesPickerCancel()
    func onFilesPickerStartUpdate(hexUrl: NSURL?, iniUrl: NSURL?)
}

class DfuFilesPickerDialogViewController: UIViewController {

    // UI
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var leftButtonView: UIView!
    @IBOutlet weak var rightButtonView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var hexFileUrlLabel: UILabel!
    @IBOutlet weak var iniFileUrlLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    // Data
    var delegate: DfuFilesPickerDialogViewControllerDelegate?
    
    private var isPickingHexFile = false
    private var hexFileUrl: NSURL?
    private var iniFileUrl: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI
        dialogView.layer.cornerRadius = 4;
        dialogView.layer.masksToBounds = true;
        //cancelButton.transform = CGAffineTransformMakeTranslation(-1, 0);
        
        leftButtonView.layer.borderColor = UIColor.lightGrayColor().CGColor
        leftButtonView.layer.borderWidth = 1
        
        rightButtonView.layer.borderColor = UIColor.lightGrayColor().CGColor
        rightButtonView.layer.borderWidth = 1
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fade-in background
        backgroundView.alpha = 0
        UIView.animateWithDuration(0.5, animations: { [unowned self] () -> Void in
            self.backgroundView.alpha = 1
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateFileNames() {
        hexFileUrlLabel.text = hexFileUrl != nil ? hexFileUrl!.lastPathComponent: "<No file selected>"
        iniFileUrlLabel.text = iniFileUrl != nil ? iniFileUrl!.lastPathComponent: "<No file selected>"
    }
    
    // MARK: - Actions
    @IBAction func onClickPickFile(sender: UIButton) {
        isPickingHexFile = sender.tag == 0
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data", "public.content"], inMode: .Import)
        importMenu.delegate = self
        presentViewController(importMenu, animated: true, completion: nil)
    }
    
    @IBAction func onClickStartUpdate(sender: AnyObject) {
        dismissViewControllerAnimated(true) { [unowned self] () -> Void in
            self.delegate?.onFilesPickerStartUpdate(self.hexFileUrl, iniUrl: self.iniFileUrl)
        }
    }
    
    @IBAction func onClickCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true) { [unowned self] () -> Void in
            self.delegate?.onFilesPickerCancel()
        }
    }
}

// MARK: - UIDocumentMenuDelegate
extension DfuFilesPickerDialogViewController: UIDocumentMenuDelegate {
   
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        presentViewController(documentPicker, animated: true, completion: nil)
    }
}

// MARK: - UIDocumentPickerDelegate
extension DfuFilesPickerDialogViewController: UIDocumentPickerDelegate {
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        DLog("picked: \(url.absoluteString)")
        
        if (isPickingHexFile) {
            hexFileUrl = url;
        }
        else {
            iniFileUrl = url;
        }
        
        updateFileNames()
    }
}
