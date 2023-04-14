//
//  homeCVC.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 12/04/23.
//

import UIKit

class homeCVC: UICollectionViewCell {
    
    static let identifier = "homeCVC"
    var cellViewModel: homeCVCM?{
        didSet{
            configureData()
        }
    }
    private let myImageVIew: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureData()
//        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageVIew.frame = contentView.bounds
    }
    
   
    
    private func configureView(){
        contentView.addSubview(myImageVIew)
        
    }
    
    private func configureData() {
        guard let image = cellViewModel?.getImage() else{
            return
        }
        myImageVIew.image = UIImage(named: image)
    }
    
    public func configure(with name: String){
        myImageVIew.image = UIImage(named: name)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageVIew.image = nil
        
    }
    
}


class homeCVCM {
    let storyModel: StoryModel?
    init(storyModel: StoryModel?) {
       
        if let storyModel = storyModel {
            self.storyModel = storyModel
        } else {
            self.storyModel = nil
        }
    
    }
    func getImage() -> String {
        guard let storyModel = self.storyModel else {
            return ""
        }
        return storyModel.imageView
    }
}
