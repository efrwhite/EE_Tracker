import UIKit

@IBDesignable final class GradientFile: UIView {
    @IBInspectable var startColor: UIColor = UIColor.white {
        didSet {
            updateGradientColors()
        }
    }

    @IBInspectable var endColor: UIColor = UIColor.white {
        didSet {
            updateGradientColors()
        }
    }
    // Example hex color values
    let startHexColor = "#abc5ae"
    let endHexColor = "#abc5ae"

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    private func setupGradient() {
        updateGradientColors()
    }

    private func updateGradientColors() {
        guard let gradientLayer = self.layer as? CAGradientLayer else {
            return
        }

        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}

extension UIColor {
    convenience init?(hexString: String) {
        var formattedHexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if formattedHexString.hasPrefix("#") {
            formattedHexString.remove(at: formattedHexString.startIndex)
        }

        if formattedHexString.count != 6 {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: formattedHexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

