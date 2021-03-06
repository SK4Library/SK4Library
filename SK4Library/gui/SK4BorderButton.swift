//
//  SK4BorderButton.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/24.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 枠線付きのボタン
@IBDesignable
open class SK4BorderButton: UIButton {

	/// まとめてボタンを生成・設定
	public static func make(frame: CGRect = .zero, title: String = "") -> SK4BorderButton {
		let button = SK4BorderButton(type: .system)
		button.setupBorder()
		button.frame = frame
		button.setTitle(title, for: .normal)
		return button
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 枠線関係の設定など

	@IBInspectable open var borderWidth: CGFloat = 1.0 {
		didSet {
			layer.borderWidth = borderWidth
			setNeedsDisplay()
		}
	}

	@IBInspectable open var cornerRadius: CGFloat = 4.0 {
		didSet {
			layer.cornerRadius = cornerRadius
			setNeedsDisplay()
		}
	}

	override open var isEnabled: Bool {
		didSet {
			layer.borderColor = currentTitleColor.cgColor
		}
	}

	override open var isHighlighted: Bool {
		didSet {
			let col = currentTitleColor
			let key = "borderColor"

			if isHighlighted {
				layer.borderColor = col.withAlphaComponent(0.2).cgColor
				layer.removeAnimation(forKey: key)

			} else {
				layer.borderColor = col.cgColor
				let anim = CABasicAnimation(keyPath: key)
				anim.duration = 0.2
				anim.fromValue = col.withAlphaComponent(0.2).cgColor
				anim.toValue = col.cgColor
				layer.add(anim, forKey: key)
			}
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

	override open func tintColorDidChange() {
		super.tintColorDidChange()
		layer.borderColor = currentTitleColor.cgColor
	}

	open func setupBorder() {
		layer.borderWidth = borderWidth
		layer.cornerRadius = cornerRadius
		layer.borderColor = currentTitleColor.cgColor
		clipsToBounds = true
	}

}

// eof
