//
//  SK4BorderView.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/28.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 枠線を描画するためだけのView
@IBDesignable
public class SK4BorderView: UIView {

	@IBInspectable public var borderWidth: CGFloat = 1.0 {
		didSet {
			layer.borderWidth = borderWidth
			setNeedsDisplay()
		}
	}

	@IBInspectable public var cornerRadius: CGFloat = 8.0 {
		didSet {
			layer.cornerRadius = cornerRadius
			setNeedsDisplay()
		}
	}

	@IBInspectable public var borderColor: UIColor = .black {
		didSet {
			layer.borderColor = borderColor.cgColor
			setNeedsDisplay()
		}
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		setupBorder()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupBorder()
	}

	public func setupBorder() {
		layer.borderWidth = borderWidth
		layer.cornerRadius = cornerRadius
		layer.borderColor = borderColor.cgColor
		clipsToBounds = true
	}

}

// eof
