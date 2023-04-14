//
//  DCHeaderView.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 13/04/23.
//

import UIKit

class DCHeaderView: UIView {

 
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    // MARK: - ---------Private Methods----------
    func commonInit() {
        let viewName = "DCHeaderView"
        Bundle.main.loadNibNamed(viewName, owner: self)
   
        self.layoutSubviews()
        self.layoutIfNeeded()
//        configureView()
    }
}
