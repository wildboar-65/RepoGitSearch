import UIKit

extension UIColor {

    static let background = UIColor.loadFromBundle(named: "background")
    static let uiNavBarColor = UIColor.loadFromBundle(named: "uiNavBarColor")
    static let lightTextColor = UIColor.loadFromBundle(named: "lightTextColor")
    
    static func loadFromBundle(bundle: Bundle = Bundle(for: AppDelegate.self),named: String) -> UIColor {
        return UIColor(named: named, in: Bundle(for: AppDelegate.self), compatibleWith: nil)!
    }
}
