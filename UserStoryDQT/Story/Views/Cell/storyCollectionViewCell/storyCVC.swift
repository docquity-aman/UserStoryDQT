//
//  storyCVC.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 13/04/23.
//

import UIKit

protocol storyCVCProtocol {
    func showCellData(_ viewModel: storyCVCM)
    func showCellDataWithCallback(viewModel: storyCVCM,
                                    userStoryCellCallBack: @escaping ((userStoryCellActionCallBack) -> Void))
}

public struct userStoryCellActionCallBack {
    var type: userStoryActionType
    var currentStoryIndex: Int
    var storiesCount: Int
//    var timer: Timer
    
}
enum userStoryActionType {
   case rightClick
   case leftClick
}


class storyCVC: UICollectionViewCell {
    static let identifier = "storyCVC"
    private var userStoryCellCallBack: ((userStoryCellActionCallBack) -> Void)!
    var cellViewModel:storyCVCM?{
           didSet{
               configureData()
               addProgressBars()
               print("<<<>>>cell setup")
           }
       }
    

    lazy var stackProgressView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 20
        sv.backgroundColor = .black
        sv.translatesAutoresizingMaskIntoConstraints = false
       
        return sv
    }()
    
    lazy var headerView: UIView = {
        let v = UIView()
        return v
    }()
    
    let bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    let bodyImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    var progressViewsArray: [UIProgressView] = []
    
    let imageLabelStackView : UIStackView = UIStackView()
    var nameLabel:UILabel = UILabel()
    var imageView: UIImageView = UIImageView()
    var currentIndex:Int = 0// index of the currently animating progress view

    private var timer: Timer?
    var isAnimating:Bool = false {
        didSet { stop()
            
        }
    }
    
    // Override the init(frame:) method to set up the cell's views and constraints.
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentIndex = cellViewModel?.storyIndex ?? 0
        addSubview(bodyView)
        bodyView.addSubview(bodyImageView)
        bodyView.addSubview(headerView)
        bodyView.addSubview(stackProgressView)
        configureImageLabelStackView()
        configureTapGesture()
        installConstraints()
        addProgressBars()
        

    }
   
    override func prepareForReuse() {
        print("call Garbage collector")
        timer?.invalidate()
        super.prepareForReuse()
        for i in stackProgressView.arrangedSubviews {
            print(i)
            i.removeFromSuperview()
            timer?.invalidate()
        }
        
        progressViewsArray = []
        
        if isAnimating {

                 isAnimating = false
             }
             else {
                 isAnimating = true
             }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Cell stop")
        stop()
    }
    
}
extension storyCVC {
    
    func configureImageLabelStackView() {
        
        imageLabelStackView.axis = .horizontal
        imageLabelStackView.alignment = .fill
        imageLabelStackView.layoutMargins = UIEdgeInsets(top: 0, left: 30.0, bottom: 0, right: 10.0)
        imageLabelStackView.isLayoutMarginsRelativeArrangement = true
        imageLabelStackView.distribution = .fill
        imageLabelStackView.spacing = 20
        imageLabelStackView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
       
        nameLabel.text = "Your label text"
        nameLabel.font = UIFont.systemFont(ofSize: 18.0)
        
        imageLabelStackView.addArrangedSubview(imageView)
        imageLabelStackView.addArrangedSubview(nameLabel)
        
        headerView.addSubview(imageLabelStackView)
        
        imageLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
    
        
    }
    
    func configureTapGesture(){
        bodyImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        bodyImageView.addGestureRecognizer(tapGesture)
       

    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: bodyImageView)
        let touchAreaWidth: CGFloat = 80
        
        if location.x <= touchAreaWidth {
            print("Left area touched")
            if let story = cellViewModel?.updateImageView(type: .leftClick, currentIndex: (cellViewModel?.storyIndex)!) {
                bodyImageView.image = UIImage(named: story)
            }
            let callBack = userStoryCellActionCallBack.init(type: .leftClick,currentStoryIndex: cellViewModel?.storyIndex ?? 0, storiesCount: cellViewModel?.stories.count ?? 0)
            userStoryCellCallBack(callBack)
            
            
        } else if location.x >= (self.bodyImageView.frame.size.width - touchAreaWidth) {
            print("Right area touched")
            let callBack = userStoryCellActionCallBack.init(type: .rightClick,currentStoryIndex: cellViewModel?.storyIndex ?? 0, storiesCount: cellViewModel?.stories.count ?? 0)
            userStoryCellCallBack(callBack)
            
            if  let story = cellViewModel?.updateImageView(type: .rightClick, currentIndex: (cellViewModel?.storyIndex)!){
                bodyImageView.image = UIImage(named: story)
                
            }
        } else {
            print("Ignore in-between touch.")
        }
        
        
    }

    func installConstraints(){
        NSLayoutConstraint.activate([
            bodyImageView.leadingAnchor.constraint(equalTo:bodyView.leadingAnchor,constant: 0),
            bodyImageView.topAnchor.constraint(equalTo: bodyView.topAnchor,constant: 10),
            bodyImageView.trailingAnchor.constraint(equalTo:bodyView.trailingAnchor,constant: 10),
            bodyImageView.bottomAnchor.constraint(equalTo:bodyView.bottomAnchor,constant: 10),
        ])
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bodyView.topAnchor.constraint(equalTo: topAnchor),
            bodyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            stackProgressView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor),
            stackProgressView.topAnchor.constraint(equalTo:bodyView.topAnchor ,constant: 40),
            stackProgressView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor),
         
        ])
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor),
            headerView.topAnchor.constraint(equalTo:stackProgressView.bottomAnchor ),
            headerView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor),
         
        ])
        NSLayoutConstraint.activate([
            imageLabelStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            imageLabelStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant:0),
            imageLabelStackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30),
            imageLabelStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            headerView.heightAnchor.constraint(equalToConstant: 80.0)
        ])
    }
    
    func addProgressBars() {
        stackProgressView.layoutMargins = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        stackProgressView.isLayoutMarginsRelativeArrangement = true
        guard let stories =  cellViewModel?.storyModel?.stories else{
            return
        }
        for i in stories {
            print(i)
            let view = UIProgressView()
            view.progressViewStyle = .bar
            view.progressTintColor = .blue
            view.trackTintColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 5).isActive = true
            progressViewsArray.append(view)
            progressViewsArray.forEach { stackProgressView.addArrangedSubview($0) }
            layoutIfNeeded()
            
        
        }
         
    }
    
}

extension storyCVC {
    func configureData() {
      
        nameLabel.text = cellViewModel?.storyModel?.name
        imageView.image = UIImage (named: (cellViewModel?.storyModel!.imageView)!)
        bodyImageView.image = UIImage(named:(cellViewModel?.storyModel!.stories.first)!)
        
    }
}
extension storyCVC :storyCVCProtocol {
    func showCellData(_ viewModel: storyCVCM) {
        cellViewModel = viewModel
        configureData()
        
    }
    
    
    func showCellDataWithCallback(viewModel: storyCVCM,
                                    userStoryCellCallBack: @escaping ((userStoryCellActionCallBack) -> Void)) {
        self.userStoryCellCallBack = userStoryCellCallBack
        cellViewModel = viewModel
        configureData()
    }
    
}




extension storyCVC {
    @objc func updateProgressView() {
        print("After 10 sec",currentIndex,progressViewsArray.count)
        guard currentIndex+1 < progressViewsArray.count  else {
            stop()
            return
            
        }
        print("after value",currentIndex,progressViewsArray.count)
        
        cellViewModel?.storyIndex! += 1
        self.currentIndex = (cellViewModel?.storyIndex)!
        play()
    }
}
//progressbar
extension storyCVC {
    
    func startAnimation() {
        if !self.isAnimating {
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
            play()
        }
       
    }
    func pause() {
        timer?.invalidate()
        
    }
    func reset() {
        stop()
        progressViewsArray[currentIndex].setProgress(0, animated: false)
        play()
        
    }
    
    func play() {
        print("called for currentInex",currentIndex)
        let currentProgressView = progressViewsArray[currentIndex]
            UIView.animate(withDuration: 10, delay: 0,options: .curveLinear) {
                currentProgressView.setProgress(1.0, animated: true)
            }
            
        
    }
    
    func next() {
        
    }
    
    func stop() {
        print("Stop")
        timer?.invalidate()
        timer = nil
    }
}
