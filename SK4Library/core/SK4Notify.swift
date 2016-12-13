//
//  SK4Notify.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/26.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

// /////////////////////////////////////////////////////////////
// MARK: - SK4Notify (protocol)

/// 通知関係の処理を行うプロトコル
public protocol SK4Notify {

	// /////////////////////////////////////////////////////////////
	// MARK: - 引数無しのパターン

	/// 通知を受信したときの処理を登録　※メインキューで受信
	func recieveNotify(observer: AnyObject, block: @escaping (() -> Void))

	/// 通知を受信したときの処理を登録　※グローバルキューで受信
	func recieveNotifyInGlobal(observer: AnyObject, block: @escaping (() -> Void))

	/// 通知を送信
	func postNotify()


	// /////////////////////////////////////////////////////////////
	// MARK: - 引数ありのパターン

	/// 通知を受信したときの処理を登録（引数付き）　※メインキューで受信
	func recieveNotify<T>(observer: AnyObject, block: @escaping ((T) -> Void))

	/// 通知を受信したときの処理を登録（引数付き）　※グローバルキューで受信
	func recieveNotifyInGlobal<T>(observer: AnyObject, block: @escaping ((T) -> Void))
	
	/// 通知を送信
	func postNotify<T>(param: T)


	// /////////////////////////////////////////////////////////////
	// MARK: - 共通

	/// 通知を受信したときの処理を削除
	func removeNotify(observer: AnyObject)

	/// 通知を比較
	func compareNotify(_ notify: SK4Notify) -> Bool
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4Notify (extension)

/// 通知関係の実装
extension SK4Notify where Self: Equatable {

	// /////////////////////////////////////////////////////////////
	// MARK: - 引数無しのパターン

	public func recieveNotify(observer: AnyObject, block: @escaping (() -> Void)) {
		SK4NotifyHub.add(notify: self, observer: observer, block: block, mainQueue: true)
	}

	public func recieveNotifyInGlobal(observer: AnyObject, block: @escaping (() -> Void)) {
		SK4NotifyHub.add(notify: self, observer: observer, block: block, mainQueue: false)
	}

	public func postNotify() {
		SK4NotifyHub.post(notify: self, param: ())
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 引数ありのパターン

	public func recieveNotify<T>(observer: AnyObject, block: @escaping ((T) -> Void)) {
		SK4NotifyHub.add(notify: self, observer: observer, block: block, mainQueue: true)
	}

	public func recieveNotifyInGlobal<T>(observer: AnyObject, block: @escaping ((T) -> Void)) {
		SK4NotifyHub.add(notify: self, observer: observer, block: block, mainQueue: false)
	}

	public func postNotify<T>(param: T) {
		SK4NotifyHub.post(notify: self, param: param)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 共通

	public func removeNotify(observer: AnyObject) {
		SK4NotifyHub.remove(notify: self, observer: observer)
	}

	public func compareNotify(_ notify: SK4Notify) -> Bool {
		if let notify = notify as? Self, notify == self {
			return true
		} else {
			return false
		}
	}

}


// /////////////////////////////////////////////////////////////
// MARK: - SK4NotifyHub

/// 通知の管理をするための下請け構造体
struct SK4NotifyHub {

	/// 受信者の情報をまとめた構造体
	struct Info {
		weak var observer: AnyObject?
		let notify: SK4Notify
		let block: Any
		let mainQueue: Bool
	}

	/// 受信者の情報
	static var infoArray = [Info]()

	/// 同期処理で使用するオブジェクト
	static let queueObj = DispatchQueue(label: "SK4Library.SK4NotifyHub")

	/// 受信者の情報を登録　※重複して登録が可能
	static func add(notify: SK4Notify, observer: AnyObject, block: Any, mainQueue: Bool) {
		let info = SK4NotifyHub.Info(observer: observer, notify: notify, block: block, mainQueue: mainQueue)

		queueObj.sync {
			infoArray = infoArray.filter { $0.observer != nil }
			infoArray.append(info)
		}
	}

	/// 通知を送信
	static func post<T>(notify: SK4Notify, param: T) {
		queueObj.sync {
			infoArray = infoArray.filter { $0.observer != nil }

			for info in infoArray {
				if info.notify.compareNotify(notify) {
					exec(info: info, param: param)
				}
			}
		}
	}

	/// 受信者の情報を削除
	static func remove(notify: SK4Notify, observer: AnyObject) {
		queueObj.sync {
			infoArray = infoArray.filter { info in
				if info.observer == nil {
					return false
				}

				if info.notify.compareNotify(notify) && info.observer === observer {
					return false
				}

				return true
			}
		}
	}

	/// 通知を実行
	static func exec<T>(info: Info, param: T) {
		if let block = info.block as? ((T) -> Void) {
			if DispatchQueue.isMainQueue == info.mainQueue {
				block(param)
			} else {
				let queue = info.mainQueue ? DispatchQueue.main : DispatchQueue.global()
				queue.async {
					block(param)
				}
			}
		}
	}
	
}

// eof
