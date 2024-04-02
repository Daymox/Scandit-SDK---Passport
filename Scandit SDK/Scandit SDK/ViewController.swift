//
//  ViewController.swift
//  Scandit SDK
//
//  Created by Mateo Garcia on 1/04/24.
//

import UIKit
import ScanditCaptureCore
import ScanditIdCapture

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
	}
	
	@IBAction func scanMRZ(_ sender: UIButton) {
		performSegue(withIdentifier: "showCaptureData", sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showCaptureData" {
			if let captureData = segue.destination as? CaptureData {
				captureData.setupRecognition()
			}
		}
	}
}

