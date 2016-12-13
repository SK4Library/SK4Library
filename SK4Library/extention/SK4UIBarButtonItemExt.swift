//
//  SK4UIBarButtonItemExt.swift
//  SK4Library
//
//  Created by See.Ku on 2016/12/01.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

	/// 可変幅のスペース
	public static let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

	/// タイトルだけのボタン　※主にBackボタン向け
	public convenience init(title: String) {
		self.init(title: title, style: .plain, target: nil, action: nil)
	}

}

// eof
