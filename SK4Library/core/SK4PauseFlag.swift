//
//  SK4PauseFlag.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/28.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 一時停止付きのFlag管理クラス
public class SK4PauseFlag {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ

	/// 許可／無効のフラグ
	public var isEnable = false

	/// 一時停止／再開のフラグ
	public var isPause = false

	/// 許可／無効と一時停止／再開を合わせた状態
	public var flag: Bool {
		if isEnable == true && isPause == false {
			return true
		} else {
			return false
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 初期化・設定

	/// 無効／再開の状態で初期化
	public init() {
	}

	/// 状態を指定して初期化
	public convenience init(enable: Bool, pause: Bool = false) {
		self.init()
		setup(enable: enable, pause: pause)
	}

	/// まとめて状態を設定
	public func setup(enable: Bool, pause: Bool = false) {
		self.isEnable = enable
		self.isPause = pause
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - フラグ操作

	/// メインのフラグを許可にする
	public func enable() {
		isEnable = true
	}

	/// メインのフラグを無効にする
	public func disable() {
		isEnable = false
	}

	/// 一時停止
	public func pause() {
		isPause = true
	}

	/// 再開
	public func resume() {
		isPause = false
	}

}

// eof
