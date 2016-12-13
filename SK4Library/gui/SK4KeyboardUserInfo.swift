//
//  SK4KeyboardUserInfo.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/14.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// キーボードの開閉に関する情報をまとめて取得するための構造体
public struct SK4KeyboardUserInfo {
	public var frameBegin: CGRect!
	public var frameEnd: CGRect!
	public var duration: Double!
	public var curve: UIViewAnimationCurve!
	public var isLocal: Bool!

	/// キーボードの開閉に関する情報をまとめて取得
	public init(notify: NSNotification) {
		if let dic = notify.userInfo {
			if let val = dic[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
				frameBegin = val.cgRectValue
			}

			if let val = dic[UIKeyboardFrameEndUserInfoKey] as? NSValue {
				frameEnd = val.cgRectValue
			}

			if let num = dic[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
				duration = num.doubleValue
			}

			if let num = dic[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
				curve = UIViewAnimationCurve(rawValue: num.intValue)
			}

			if let num = dic[UIKeyboardIsLocalUserInfoKey] as? NSNumber {
				isLocal = num.boolValue
			}
		}
	}
	
}

// eof
