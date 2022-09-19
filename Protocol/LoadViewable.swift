import UIKit

protocol LoadViewable where Self: UIView  {
    static func loadView() -> Self?
}

extension LoadViewable {
    static func loadView() -> Self? {
        let bundle = Bundle(for: Self.self)
        
        guard let view = bundle.loadNibNamed("\(Self.self)", owner: self, options: nil)?.first as? Self else {
            return nil
        }
        
        return view
    }
}
