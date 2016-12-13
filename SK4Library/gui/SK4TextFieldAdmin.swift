//
//  SK4TextFieldAdmin.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UITextFieldの管理クラス
open class SK4TextFieldAdmin: SK4TargetAction, UITextFieldDelegate {

	/// 文字列の最大長
	public var maxLength = 0

	/// 初期化　※Closureは[weak self]推奨
	public convenience init(textField: UITextField, maxLength: Int, exec: ControlBlock? = nil) {
		self.init()

		setup(textField: textField, maxLength: maxLength, exec: exec)
	}

	/// 設定　※Closureは[weak self]推奨
	open func setup(textField: UITextField, maxLength: Int, exec: ControlBlock? = nil) {
		super.setup(control: textField, event: .editingChanged, exec: exec)

		self.maxLength = maxLength
		textField.delegate = self
	}

	/// 処理を実行
	override open func onAction(_ sender: UIControl) {
		guard let textField = sender as? UITextField else { return }

		// 日本語の変換中は何もしない
		if textField.markedTextRange != nil {
			return
		}

		// 必要であれば、文字列の長さを制限する
		if maxLength > 0 {
			if let len = textField.text?.characters.count, len > maxLength {
				let keep = textField.selectedTextRange
				textField.text = textField.text?.substring(to: maxLength)
				textField.selectedTextRange = keep
			}
		}

		// 変更を通知
		exec?(sender)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UITextFieldDelegate

	/// テキストが変更された
	open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return true
	}

	/// リターンキーが押された
	open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	/// テキストの編集開始
	open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return true
	}

	/// テキストの編集終了
	open func textFieldDidEndEditing(_ textField: UITextField) {
	}

}

// eof
