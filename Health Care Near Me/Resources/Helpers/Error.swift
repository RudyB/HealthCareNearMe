//
//  Error.swift
//  OfficeHours
//
//  Created by Rudy Bermudez on 3/4/17.
//  Copyright © 2017 GUMAD. All rights reserved.
//

import Foundation


func createError(domain: String, code: Int, message: String, comment: String = "") -> NSError {
	let userInfo: [String : Any] = [ NSLocalizedDescriptionKey :  NSLocalizedString(message, comment: comment)]
	return NSError(domain: domain, code: code, userInfo: userInfo)
}
