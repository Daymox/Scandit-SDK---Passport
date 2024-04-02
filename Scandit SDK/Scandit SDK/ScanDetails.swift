//
//  ScanDetails.swift
//  Scandit SDK
//
//  Created by Mateo Garcia on 2/04/24.
//

import UIKit
import ScanditCaptureCore
import ScanditIdCapture

// Estructura para representar la fecha del JSON
struct JSONDate: Decodable {
	let day: Int
	let month: Int
	let year: Int
	
	var date: Date? {
		let calendar = Calendar(identifier: .gregorian)
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		return calendar.date(from: components)
	}
}

// Estructura para representar los datos del JSON
struct UserData: Decodable {
	let fullName: String
	let issuingCountry: String
	let documentType: String
	let documentNumber: String
	let dateOfExpiry: Date?
	let optional: String
	let dateOfBirth: Date?
	let sex: String
	let capturedMrz: String
	
	private enum CodingKeys: String, CodingKey {
		case fullName, issuingCountry, documentType, documentNumber, optional, sex, capturedMrz
		case dateOfBirth, dateOfExpiry
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		fullName = try container.decode(String.self, forKey: .fullName)
		issuingCountry = try container.decode(String.self, forKey: .issuingCountry)
		documentType = try container.decode(String.self, forKey: .documentType)
		documentNumber = try container.decode(String.self, forKey: .documentNumber)
		optional = try container.decode(String.self, forKey: .optional)
		sex = try container.decode(String.self, forKey: .sex)
		dateOfBirth = try container.decodeIfPresent(JSONDate.self, forKey: .dateOfBirth)?.date
		dateOfExpiry = try container.decodeIfPresent(JSONDate.self, forKey: .dateOfExpiry)?.date
		capturedMrz = try container.decode(String.self, forKey: .capturedMrz)
	}
}

class ScanDetails: UIViewController {
	
	var mrzResult: MrzResult?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let mrzResult = mrzResult {
			let data = mrzResult.jsonString.data(using: .utf8)!
			do {
				let documentInformation = try JSONDecoder().decode(UserData.self, from: data)
				// Asignar los valores a las etiquetas u otros elementos de la interfaz de usuario aquí
				fullNameLabel.text = documentInformation.fullName
				countryLabel.text = documentInformation.issuingCountry
				documentTypeLabel.text = documentInformation.documentType
				documentNumberLabel.text = documentInformation.documentNumber
				optionalLabel.text = documentInformation.optional
				sexLabel.text = documentInformation.sex
				mrzCode.text = documentInformation.capturedMrz
				if let dateOfBirth = documentInformation.dateOfBirth {
					birthDateLabel.text = formatDate(dateOfBirth)
				}
				if let dateOfExpiry = documentInformation.dateOfExpiry {
					expirationDateLabel.text = formatDate(dateOfExpiry)
				}
			} catch {
				print("Error decoding JSON data:", error)
			}
		}
	}
	
	// Función para formatear la fecha como String
	func formatDate(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		return dateFormatter.string(from: date)
	}
	
	@IBOutlet weak var fullNameLabel: UILabel!
	@IBOutlet weak var countryLabel: UILabel!
	@IBOutlet weak var documentTypeLabel: UILabel!
	@IBOutlet weak var documentNumberLabel: UILabel!
	@IBOutlet weak var expirationDateLabel: UILabel!
	@IBOutlet weak var optionalLabel: UILabel!
	@IBOutlet weak var birthDateLabel: UILabel!
	@IBOutlet weak var sexLabel: UILabel!
	@IBOutlet weak var mrzCode: UILabel!
}
