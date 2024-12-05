import UIKit

final class FPSLabel: UILabel {

	private var displayLink: CADisplayLink?
	private var lastTimestamp: CFTimeInterval = 0
	private var frameCount: Int = 0

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	private func setup() {
		self.textColor = .white
		self.backgroundColor = .black.withAlphaComponent(0.5)
		self.font = UIFont.systemFont(ofSize: 14)

		displayLink = CADisplayLink(target: self, selector: #selector(update))
		displayLink?.add(to: .main, forMode: .default)
	}

	@objc private func update() {
		frameCount += 1

		let currentTimestamp = CACurrentMediaTime()

		if currentTimestamp - lastTimestamp >= 0.1 {
			self.text = "\(frameCount * 10) FPS"
			frameCount = 0
			lastTimestamp = currentTimestamp
		}
	}
}
