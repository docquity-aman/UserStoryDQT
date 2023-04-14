//
//  StoryHeaderView.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 13/04/23.
//

//import UIKit
//
//class StoryHeaderView: UIView {
//
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//}


import UIKit



class DCStoryHeaderView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.backgroundColor = .blue
        return stackView
    }()
    
    private let progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.backgroundColor = .black
        progressBar.tintColor = .gray
        progressBar.progress = 0.5 // set the progress value as per your requirements
        return progressBar
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
            
        ])
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

