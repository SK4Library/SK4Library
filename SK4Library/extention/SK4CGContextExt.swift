//
//  SK4CGContextExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/27.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension CGContext {

	public func setStrokeColor(_ color: UIColor) {
		setStrokeColor(color.cgColor)
	}

	public func setFillColor(_ color: UIColor) {
		setFillColor(color.cgColor)
	}

	public func fill(_ rect: CGRect, color: UIColor) {
		setFillColor(color.cgColor)
		fill(rect)
	}

	public func stroke(_ rect: CGRect, color: UIColor) {
		setStrokeColor(color.cgColor)
		stroke(rect)
	}
	
}

// eof
