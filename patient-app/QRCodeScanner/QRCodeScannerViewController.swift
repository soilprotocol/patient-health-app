//
//  QRCodeScannerViewController.swift
//  patient-app
//
//  Created by Elliott Brunet on 05.06.19.
//  Copyright © 2019 Elliott Brunet. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController {
    
    @IBOutlet var messageLabel:UILabel!
    
    private let dbHandler = DBHandler.sharedInstance
    var isRequestShowing = false
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var requestView: UIView!
    var requestAcceptButton: UIButton!
    var requestDenyButton: UIButton!
    var requestLabelTitle: UILabel!
    var requestTimestamp: UILabel!
    var requestLabelVon: UILabel!
    var requestLabelVonContent: UILabel!
    var requestLabelVerifiziert: UILabel!
    var requestLabelDateiname: UILabel!
    var requestLabelDateinameContent1: UILabel!
    var requestLabelDateinameContent2: UILabel!
    var requestLabelDateinameContent3: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self as? AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubviewToFront(messageLabel)
            
            //QR CODE SCANNING
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        setupRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        presentRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    func setupRequest() {
        requestView = UIView()
        let screenFrame = UIScreen.main.bounds
        let screenWidth = screenFrame.size.width
        let screenHeight = screenFrame.size.height
        requestView.backgroundColor = UIColor.white
        requestView.frame = CGRect(x: 20, y: screenHeight, width: screenWidth - 40, height: screenHeight - 60)
        self.view.insertSubview(requestView, at: 10)
        setupRequestContent()
    }
    
    func setupRequestContent() {
        setRequestTitle()
        setRequestTimestamp()
        setRequestVon()
        setRequestVonContent()
        setRequestVerifiziert()
        setRequestDateiname()
        setRequestDateiname1()
        setRequestDateiname2()
        setRequestDateiname3()
        setupAcceptButton()
        setupDenyButton()
    }
    
    func setRequestTitle() {
        requestLabelTitle = UILabel()
        requestLabelTitle.font =  UIFont(name: "Kailasa-Bold", size: 30)
        requestLabelTitle.text = "Daten Zugriffsanfrage"
        requestLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestLabelTitle, at: 11)
        setupTitleConstraints()
    }
    
    func setupTitleConstraints(){
        let margins = requestView.layoutMarginsGuide
        requestLabelTitle.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        requestLabelTitle.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
    }
    
    func setRequestTimestamp() {
        let timestamp = Date()
        requestTimestamp = UILabel()
        requestTimestamp.font =  UIFont(name: "Kailasa-Bold", size: 15)
        requestTimestamp.text = parseDate(date: timestamp)
        requestTimestamp.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestTimestamp, at: 11)
        setupTimestampConstraints()
    }
    
    func setupTimestampConstraints(){
        let margins = requestView.layoutMarginsGuide
        requestTimestamp.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 10).isActive = true
        requestTimestamp.topAnchor.constraint(equalTo: requestLabelTitle.bottomAnchor, constant: 15).isActive = true
    }
    
    func setRequestVon() {
        requestLabelVon = UILabel()
        requestLabelVon.font =  UIFont(name: "Kailasa-Bold", size: 15)
        requestLabelVon.text = "Von"
        requestLabelVon.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestLabelVon, at: 11)
        setupVonConstraints()
    }
    
    func setupVonConstraints() {
        let margins = requestView.layoutMarginsGuide
        requestLabelVon.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        requestLabelVon.topAnchor.constraint(equalTo: requestTimestamp.bottomAnchor, constant: 70).isActive = true
    }
    
    func setRequestVonContent() {
        requestLabelVonContent = UILabel()
        requestLabelVonContent.font =  UIFont(name: "Kailasa-Bold", size: 20)
        requestLabelVonContent.text = "Dr Marten"
        requestLabelVonContent.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestLabelVonContent, at: 11)
        setupVonContentConstraints()
    }
    
    func setupVonContentConstraints() {
        let margins = requestView.layoutMarginsGuide
        requestLabelVonContent.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        requestLabelVonContent.topAnchor.constraint(equalTo: requestLabelVon.topAnchor, constant: 30).isActive = true
    }
    
    func setRequestVerifiziert() {
        requestLabelVerifiziert = UILabel()
        requestLabelVerifiziert.font =  UIFont(name: "Kailasa-Bold", size: 20)
        requestLabelVerifiziert.text = "verifiziert ✅"
        requestLabelVerifiziert.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestLabelVerifiziert, at: 11)
        setupVerifiziertConstraints()
    }
    
    func setupVerifiziertConstraints() {
        let margins = requestView.layoutMarginsGuide
        requestLabelVerifiziert.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        requestLabelVerifiziert.topAnchor.constraint(equalTo: requestLabelVon.topAnchor, constant: 30).isActive = true
    }
    
    func setRequestDateiname() {
        requestLabelDateiname = UILabel()
        requestLabelDateiname.font =  UIFont(name: "Kailasa-Bold", size: 15)
        requestLabelDateiname.text = "Dateiname"
        requestLabelDateiname.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestLabelDateiname, at: 11)
        setupDateinameConstraints()
    }
    
    func setupDateinameConstraints() {
        let margins = requestView.layoutMarginsGuide
        requestLabelDateiname.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        requestLabelDateiname.topAnchor.constraint(equalTo: requestLabelVonContent.bottomAnchor, constant: 30).isActive = true
    }
    
    func setRequestDateiname1() {
        requestLabelDateinameContent1 = UILabel()
        requestLabelDateinameContent1.font =  UIFont(name: "Kailasa-Bold", size: 22)
        requestLabelDateinameContent1.text = "● MRT_Rechte-Schulter"
        requestLabelDateinameContent1.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestLabelDateinameContent1, at: 11)
        setupDateiname1Constraints()
    }
    
    func setupDateiname1Constraints() {
        let margins = requestView.layoutMarginsGuide
        requestLabelDateinameContent1.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        requestLabelDateinameContent1.topAnchor.constraint(equalTo: requestLabelDateiname.bottomAnchor, constant: 20).isActive = true
    }
    
    func setRequestDateiname2() {
        requestLabelDateinameContent2 = UILabel()
        requestLabelDateinameContent2.font =  UIFont(name: "Kailasa-Bold", size: 22)
        requestLabelDateinameContent2.text = "● Röntgen_Rechte-Schulter"
        requestLabelDateinameContent2.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestLabelDateinameContent2, at: 11)
        setupDateiname2Constraints()
    }
    
    func setupDateiname2Constraints() {
        let margins = requestView.layoutMarginsGuide
        requestLabelDateinameContent2.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        requestLabelDateinameContent2.topAnchor.constraint(equalTo: requestLabelDateinameContent1.bottomAnchor, constant: 15).isActive = true
    }
    
    func setRequestDateiname3() {
        requestLabelDateinameContent3 = UILabel()
        requestLabelDateinameContent3.font =  UIFont(name: "Kailasa-Bold", size: 22)
        requestLabelDateinameContent3.text = "● Befund_Rechte-Schulter"
        requestLabelDateinameContent3.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestLabelDateinameContent3, at: 11)
        setupDateiname3Constraints()
    }
    
    func setupDateiname3Constraints() {
        let margins = requestView.layoutMarginsGuide
        requestLabelDateinameContent3.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        requestLabelDateinameContent3.topAnchor.constraint(equalTo: requestLabelDateinameContent2.bottomAnchor, constant: 15).isActive = true
    }

    
    fileprivate func setupAcceptButton() {
        requestAcceptButton = UIButton(type: .system)
        requestAcceptButton.titleLabel?.font =  UIFont(name: "Kailasa-Bold", size: 25)
        requestAcceptButton.backgroundColor = UIColor.green
        requestAcceptButton.layer.cornerRadius = 10
        requestAcceptButton.setTitleColor(UIColor.white, for: .normal)
        requestAcceptButton?.setTitle("Akzeptieren", for: .normal)
        requestAcceptButton.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
        requestAcceptButton.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestAcceptButton, at: 11)
        setupAcceptButtonConstraints()
    }
    
    func setupAcceptButtonConstraints() {
        let margins = requestView.layoutMarginsGuide
        requestAcceptButton.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 10).isActive = true
        requestAcceptButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        requestAcceptButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        requestAcceptButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    fileprivate func setupDenyButton() {
        requestDenyButton = UIButton(type: .system)
        requestDenyButton.titleLabel?.font =  UIFont(name: "Kailasa-Bold", size: 23)
        requestDenyButton.layer.cornerRadius = 10
        requestDenyButton.backgroundColor = UIColor.red
        requestDenyButton.setTitleColor(UIColor.white, for: .normal)
        requestDenyButton?.setTitle("Verweigern", for: .normal)
        requestDenyButton.addTarget(self, action: #selector(denyRequest), for: .touchUpInside)
        requestDenyButton.translatesAutoresizingMaskIntoConstraints = false
        requestView.insertSubview(requestDenyButton, at: 11)
        setupDenyButtonConstraints()
    }
    
    func setupDenyButtonConstraints(){
        let margins = requestView.layoutMarginsGuide
        requestDenyButton.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: -10).isActive = true
        requestDenyButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        requestDenyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        requestDenyButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    func parseDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy | HH:mm:SS"
        return dateFormatter.string(from: date)
    }
    
    func setView(view: UIView) {
        let screenFrame = UIScreen.main.bounds
        let screenWidth = screenFrame.size.width
        let screenHeight = screenFrame.size.height
        UIView.transition(with: view, duration: 0.5, options: .curveEaseIn, animations: {
            self.requestView.frame = CGRect(x: 20, y: 30, width: screenWidth - 40, height: screenHeight - 60)
        })
    }
    
    @objc func acceptRequest() {
//        dismissView()
        dbHandler.createSharingEvent(text: "do it!")
        navigationController?.popViewController(animated: true)

    }
    
    @objc func denyRequest() {
//        dismissView()
        navigationController?.popViewController(animated: true)

    }
    

}


extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                
                if (!isRequestShowing) {
                    setView(view: requestView)
                    isRequestShowing = true
                }
            }
        }
    }
    
}
