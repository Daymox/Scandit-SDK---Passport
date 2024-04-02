//
//  CaptureData.swift
//  Scandit SDK
//
//  Created by Mateo Garcia on 1/04/24.
//

import UIKit
import ScanditCaptureCore
import ScanditIdCapture

class CaptureData: UIViewController, IdCaptureListener {
	var context: DataCaptureContext!
	var camera: Camera!
	var idCapture: IdCapture!
	var captureId: IdCaptureSession!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		setupRecognition()
	}
	
	func setupRecognition() {
		context = DataCaptureContext(licenseKey: LicenseKey.key)
		
		camera = Camera.default
		
		context.setFrameSource(camera, completionHandler: nil)
		
		let recommendedCameraSettings = IdCapture.recommendedCameraSettings
		camera?.apply(recommendedCameraSettings)
		
		let idCaptureSettings = IdCaptureSettings()
		
		idCaptureSettings.supportedDocuments = [.passportMRZ]
		
		idCapture = IdCapture(context: context, settings: idCaptureSettings)
		
		idCapture.addListener(self)
		
		// Camera View
		let captureView = DataCaptureView(frame: UIScreen.main.bounds)
		captureView.context = context
		captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		//		UIApplication.shared.keyWindow?.addSubview(captureView)
		captureView.alpha = 1.0
		captureView.backgroundColor = UIColor.clear
		
		view.addSubview(captureView)
		
		camera?.switch(toDesiredState: .on)
	}
	
	func idCapture(_ idCapture: IdCapture, didCaptureIn session: IdCaptureSession, frameData: FrameData) {
		guard let captureId = session.newlyCapturedId else {
			return
		}
		
		if let mrzResult = captureId.mrzResult {
			camera?.switch(toDesiredState: .off)
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: "showDetailScan", sender: mrzResult)
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetailScan" {
			if let scanDetails = segue.destination as? ScanDetails,
			   let mrzResult = sender as? MrzResult {  // Cast sender to MrzResult
				scanDetails.mrzResult = mrzResult
			}
		}
	}
	
}
