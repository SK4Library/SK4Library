//
//  SK4TextViewAdmin.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UITextViewの管理クラス
open class SK4TextViewAdmin: NSObject, UITextViewDelegate {

	/// 文字列の最大長
	public var maxLength: Int = 0

	/// 初期化
	public convenience init(textView: UITextView, maxLength: Int) {
		self.init()

		setup(textView: textView, maxLength: maxLength)
	}

	/// 設定
	open func setup(textView: UITextView, maxLength: Int) {
		self.maxLength = maxLength

		textView.delegate = self
	}

	open func textViewDidChange(_ textView: UITextView) {

		// 日本語の変換中は何もしない
		if textView.markedTextRange != nil {
			return
		}

		// 必要であれば、文字列の長さを制限する
		if maxLength > 0 {
			if let len = textView.text?.characters.count, len > maxLength {
				let keep = textView.selectedTextRange
				textView.text = textView.text?.substring(to: maxLength)
				textView.selectedTextRange = keep
			}
		}
	}

}

// eof
