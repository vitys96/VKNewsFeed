

import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyBoard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyBoard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("No initial VC in toryboard!")
        }
        
        
    }
}
