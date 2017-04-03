import UIKit

extension UIColor {
    func darkenedCopy(_ amount: CGFloat) -> UIColor {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)

        getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))

        hsba.b -= amount

        return UIColor.init(hue: hsba.h, saturation: hsba.s, brightness: hsba.b, alpha: hsba.a)
    }
}

class BorderedButton: UIButton {
    // TODO: One central place for all color definitions?
    // TODO: Set custom highlighted text color (title color?)
    let borderColor: CGColor = UIColor(white: 0.12, alpha: 1.0).cgColor
    let borderWidth: CGFloat = 0.25
    // TODO: Use system constant for fade duration
    let fadeDuration: CFTimeInterval = 0.2
    var normalBackgroundColor: CGColor? = nil
    var highlightedBackgroundColor: CGColor? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if let backgroundColor = layer.backgroundColor {
            self.normalBackgroundColor = backgroundColor
            self.highlightedBackgroundColor = UIColor(cgColor: backgroundColor).darkenedCopy(0.08).cgColor
        }

        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                layer.backgroundColor = highlightedBackgroundColor
            } else {
                layer.backgroundColor = normalBackgroundColor

                let fade = CABasicAnimation(keyPath: "backgroundColor")
                fade.fromValue = highlightedBackgroundColor
                fade.toValue = normalBackgroundColor
                fade.timingFunction = CAMediaTimingFunction(name: "easeOut")
                fade.duration = fadeDuration
                layer.add(fade, forKey: "")
            }
        }
    }
}
