

import UIKit

class InternetConnectionManager {
    
    static let shared = InternetConnectionManager()
    struct ConstBase {
        static let tagViewInternet = 987987
        static let tagLabelInternet = 789789
    }
    
    func addViewInternet(view: UIView) {
        
        let coordinateY = view.frame.size.height
        let viewMainInternet = view.viewWithTag(ConstBase.tagViewInternet) ?? {
            let internetStatusLabel = UILabel(frame: CGRect(x: 0,
                                                            y: -10,
                                                            width: UIScreen.width,
                                                            height: 50))
            let viewTemp = UIView(frame: CGRect(x: 0,
                                                y: coordinateY,
                                                width: UIScreen.width,
                                                height: UIDevice.isiPhoneX ? 50:30))
            
            internetStatusLabel.textAlignment = .center
            internetStatusLabel.font = UIFont.systemFont(ofSize: 13)
            internetStatusLabel.textColor = UIColor.white
            internetStatusLabel.tag = ConstBase.tagLabelInternet
            internetStatusLabel.backgroundColor = .clear
            internetStatusLabel.alpha = 0.9
            viewTemp.tag = ConstBase.tagViewInternet
            viewTemp.addSubview(internetStatusLabel)
            view.addSubview(viewTemp)
            return viewTemp
            
            }()
        
        viewMainInternet.backgroundColor = .red
        
        if let internetStatusLabel = viewMainInternet.viewWithTag(ConstBase.tagLabelInternet) as? UILabel {
            internetStatusLabel.textColor = .white
            internetStatusLabel.set(text:"No Internet Connection", leftIcon : UIImage(named: "ic-failed"))
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            viewMainInternet.frame.origin.y = coordinateY - viewMainInternet.frame.size.height
        })
        
        ThreadHelper.delay(dalay: 0.3) {
            UIView.animate(withDuration: 0.4, animations: {
                viewMainInternet.frame.origin.y = coordinateY - viewMainInternet.frame.size.height
            })
        }
    }
    
    func removeViewInternet(view: UIView) {
        
        if Thread.isMainThread {
            
            removeView(view: view)
        } else {
            
            ThreadHelper.runUI {
                self.removeView(view: view)
            }
        }
        
    }
    
    private func removeView(view: UIView) {
        
        if let viewMainInternet = view.viewWithTag(ConstBase.tagViewInternet) {
            
            
            let coordinateY = view.frame.size.height
            if let internetStatusLabel = viewMainInternet.viewWithTag(ConstBase.tagLabelInternet) as? UILabel {
                internetStatusLabel.text = "Connected"
                internetStatusLabel.textColor = .black
            }
            
            viewMainInternet.backgroundColor = .green
            UIView.animate(withDuration: 0.4,
                           delay: 1,
                           animations: {
                            viewMainInternet.frame.origin.y = coordinateY + (UIDevice.isiPhoneX ? 50 : 30)
            })
            
        }
    }
}


class ThreadHelper {
    
    static func delay(dalay: Double,handler: @escaping (() -> ())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + dalay) {
            handler()
        }
    }
    
    static func runUI(updateUI: @escaping (()->Void)) {
        DispatchQueue.main.async {
            updateUI()
        }
    }
    
    static func runBackground(doBackground: @escaping (()->Void), updateUI: (()->Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            doBackground()
            DispatchQueue.main.async {
                updateUI?()
            }
        }
    }
}


extension UILabel {

    func set(text:String, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {

        let leftAttachment = NSTextAttachment()
        leftAttachment.image = leftIcon
        let size: CGFloat = 16
        leftAttachment.bounds = CGRect(x: 0, y: -2.5, width: size, height: size)
        if leftIcon != nil {
            leftAttachment.bounds = CGRect(x: 0, y: -2.5, width: size, height: size)
        }
        let leftAttachmentStr = NSAttributedString(attachment: leftAttachment)

        let myString = NSMutableAttributedString(string: "")

        let rightAttachment = NSTextAttachment()
        rightAttachment.image = rightIcon
        rightAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        let rightAttachmentStr = NSAttributedString(attachment: rightAttachment)


        if semanticContentAttribute == .forceRightToLeft {
            if rightIcon != nil {
                myString.append(rightAttachmentStr)
                myString.append(NSAttributedString(string: " "))
            }
            myString.append(NSAttributedString(string: text))
            if leftIcon != nil {
                myString.append(NSAttributedString(string: " "))
                myString.append(leftAttachmentStr)
            }
        } else {
            if leftIcon != nil {
                myString.append(leftAttachmentStr)
                myString.append(NSAttributedString(string: " "))
            }
            myString.append(NSAttributedString(string: text))
            if rightIcon != nil {
                myString.append(NSAttributedString(string: " "))
                myString.append(rightAttachmentStr)
            }
        }
        attributedText = myString
    }
}
