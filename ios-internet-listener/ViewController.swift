//
import UIKit
//
class ViewController: UIViewController {

    var reachability: SwiftReachability = SwiftReachability(hostname: "www.apple.com")

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(NetworkReachabilityChangedNotification), object: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        NotificationCenter.default.addObserver(self, selector: #selector(networkReachabilityChanged), name: NSNotification.Name.init(NetworkReachabilityChangedNotification), object: nil)
       let startResult = reachability.startNotifier()
        if !startResult {
        }
    }
    
    @objc func networkReachabilityChanged() {
        updateUI()
    }
    
    func updateUI() {
        print("---- \(reachability.currentReachabilityStatus.description)")
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            InternetConnectionManager.shared.addViewInternet(view: self.view)
            
        default:
            InternetConnectionManager.shared.removeViewInternet(view: self.view)
        }
    }

}
