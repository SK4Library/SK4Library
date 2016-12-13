//
//  SK4UIDeviceExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension UIDevice {

	/// iPadで動作中か？
	public class var isPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}

}

// eof
