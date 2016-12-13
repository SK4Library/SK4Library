//
//  SK4KeyboardObserver.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/29.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

// /////////////////////////////////////////////////////////////
// MARK: - SK4KeyboardObserver (protocol)

/// キーボードの開閉に対応するプロトコル
public protocol SK4KeyboardObserver: class {

	/// キーボードの開閉を監視する
	func registerKeyboardObserver()

	/// キーボード開閉の監視を終了
	func removeKeyboardObserver()

	/// キーボードが開かれるときの処理
	func onKeyboardWillShow(_ notify: NSNotification)

	/// キーボードが閉じられるときの処理
	func onKeyboardWillHide(_ notify: NSNotification)
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4KeyboardObserver (extension)

/// キーボードの開閉に対応するデフォルトの実装
extension SK4KeyboardObserver {

	public func registerKeyboardObserver() {
		SK4KeyboardObserverProxy.admin.registerKeyboardObserver(self)
	}

	public func removeKeyboardObserver() {
		SK4KeyboardObserverProxy.admin.removeKeyboardObserver(self)
	}

}


// /////////////////////////////////////////////////////////////
// MARK: - SK4KeyboardObserverProxy

/// キーボードの開閉を監視してくれる代理クラス
private class SK4KeyboardObserverProxy: NSObject {

	static let admin = SK4KeyboardObserverProxy()

	var observerArray = [SK4KeyboardObserver]()

	override init() {
		super.init()

		startKeyboardObserver()
	}

	/// 監視を開始
	func startKeyboardObserver() {
		let nc = NotificationCenter.default
		nc.addObserver(self, selector: #selector(SK4KeyboardObserverProxy.onKeyboardWillShow(notify:)), name: .UIKeyboardWillShow, object: nil)
		nc.addObserver(self, selector: #selector(SK4KeyboardObserverProxy.onKeyboardWillHide(notify:)), name: .UIKeyboardWillHide, object: nil)
	}

/*
	/// 監視を修了　※使用しない
	func stopKeyboardObserver() {
		let nc = NotificationCenter.default
		nc.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		nc.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}
*/

	// /////////////////////////////////////////////////////////////

	func onKeyboardWillShow(notify: NSNotification) {
		for ob in observerArray {
			ob.onKeyboardWillShow(notify)
		}
	}

	func onKeyboardWillHide(notify: NSNotification) {
		for ob in observerArray {
			ob.onKeyboardWillHide(notify)
		}
	}

	// /////////////////////////////////////////////////////////////

	/// オブザーバーを登録
	func registerKeyboardObserver(_ observer: SK4KeyboardObserver) {
		removeKeyboardObserver(observer)

		observerArray.append(observer)
	}

	/// オブザーバーを削除
	func removeKeyboardObserver(_ observer: SK4KeyboardObserver) {
		observerArray = observerArray.filter { $0 !== observer }
	}

}

// eof
