//
//  InternetStatusView.swift
//  ios-internet-listener
//
//  Created by Yoeun Samrith on 7/8/20.
//  Copyright © 2020 Yoeun Samrith. All rights reserved.
//

import UIKit

class InternetStatusView: UIView {

    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InternetStatusView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        label.text = "No Internet Connection"
    }
  
}


