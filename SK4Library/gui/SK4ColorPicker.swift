//
//  SK4ColorPicker.swift
//  SK4Library
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 簡単なカラーピッカー
@IBDesignable
public class SK4ColorPicker: UIControl {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// 水平方向の分割数
	@IBInspectable public var divX: Int = 12 {
		didSet {
			setNeedsDisplay()
		}
	}

	/// 垂直方向の分割数
	@IBInspectable public var divY: Int = 8 {
		didSet {
			setNeedsDisplay()
		}
	}

	/// 各色を描画するときの余白
	@IBInspectable public var margin: CGFloat = 2 {
		didSet {
			setNeedsDisplay()
		}
	}

	/// 選択した色
	public var color = UIColor.white {
		didSet {
			setNeedsDisplay()
		}
	}

	/// 初期化
	override public init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = UIColor.lightGray
	}

	/// 初期化
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	// /////////////////////////////////////////////////////////////

	override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let pos = touch.location(in: self)

		patternExec { re, col in
			if re.contains(pos) {
				color = col
				sendActions(for: .valueChanged)
				return true
			} else {
				return false
			}
		}
	}

	override public func draw(_ rect: CGRect) {
		guard let ic = UIGraphicsGetCurrentContext() else { return }

		ic.setLineWidth(3.0)
		ic.setStrokeColor(UIColor.white.cgColor)

		let dif = 0.5 / CGFloat(divY + 1)

		patternExec { re, col in
			ic.fill(re, color: col)
			if sk4NearlyEqual(color, col, dif: dif) {
				ic.stroke(re)
			}
			return false
		}
	}

	override public func layoutSubviews() {
		super.layoutSubviews()

		setNeedsDisplay()
	}

	// /////////////////////////////////////////////////////////////

	/// CGFloatとIntの混在した線形補間
	func interpolation(_ y0: CGFloat, _ y1: CGFloat, _ x0: Int, _ x1: Int, _ x: Int) -> CGFloat {
		return sk4Interpolation(y0: y0, y1: y1, x0: CGFloat(x0), x1: CGFloat(x1), x: CGFloat(x))
	}

	/// パターンを表示＆ヒットテスト
	func patternExec(exec: ((CGRect, UIColor) -> Bool)) {
		let divX = self.divX
		let divY = self.divY + 1

		let wx = (bounds.width - margin) / CGFloat(divX)
		let wy = (bounds.height - margin) / CGFloat(divY-1)

		var hue: CGFloat = 0
		var sat: CGFloat = 0
		var bra: CGFloat = 0
		var re = CGRect(x: 0, y: 0, width: wx-margin, height: wy-margin)

		// 垂直方向にループ　※最終行は先頭と同じなので描画しない
		for y in 0..<divY-1 {
			if y <= divY/2 {
				sat = interpolation(0, 1, 0, divY/2, y)
				bra = 1
			} else {
				sat = 1
				bra = interpolation(1, 0, divY/2, divY-1, y)
			}

			// 水平方向にループ
			for x in 0..<divX {
				if y == 0 {
					hue = 0
					sat = 0
					bra = interpolation(1, 0, 0, divX-1, x)
				} else {
					hue = interpolation(0, 1, 0, divX, x)
				}

				re.origin.x = CGFloat(x) * wx + margin
				re.origin.y = CGFloat(y) * wy + margin

				let col = UIColor(hue: hue, saturation: sat, brightness: bra, alpha: 1)
				if exec(re, col) {
					return
				}
			}
		}
	}

}

// eof
