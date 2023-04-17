//
//  storyCVC.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 13/04/23.
//

import UIKit
import AVKit

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
    let bodyVideoView: UIView = {
        let videoView  =  UIView()
        videoView.backgroundColor = .black
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
    }()
    var progressViewsArray: [UIProgressView] = []
    var player: AVPlayer!
    
    let imageLabelStackView : UIStackView = UIStackView()
    var nameLabel:UILabel = UILabel()
    var imageView: UIImageView = UIImageView()
    var currentIndex:Int = 0// index of the currently animating progress view

    internal var timer: Timer?
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
        bodyView.addSubview(bodyVideoView)
        addPlayerToView(self.bodyVideoView)
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
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let videoTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        imageTapGesture.numberOfTapsRequired = 1
        videoTapGesture.numberOfTapsRequired = 1
        bodyImageView.addGestureRecognizer(imageTapGesture)
        bodyVideoView.addGestureRecognizer(videoTapGesture)
       

    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: bodyImageView)
        let touchAreaWidth: CGFloat = 80
        
        if location.x <= touchAreaWidth {
            print("Left area touched")
            if let story = cellViewModel?.getStoryImageVideoView(type: .leftClick, currentIndex: (cellViewModel?.storyIndex)!) {
                print("update story view started")
                updateStoryView(story: story)
            }
            let callBack = userStoryCellActionCallBack.init(type: .leftClick,currentStoryIndex: cellViewModel?.storyIndex ?? 0, storiesCount: cellViewModel?.typedStories.count ?? 0)
            userStoryCellCallBack(callBack)
            
            
        } else if location.x >= (self.bodyImageView.frame.size.width - touchAreaWidth) {
            print("Right area touched")
            let callBack = userStoryCellActionCallBack.init(type: .rightClick,currentStoryIndex: cellViewModel?.storyIndex ?? 0, storiesCount: cellViewModel?.typedStories.count ?? 0)
            userStoryCellCallBack(callBack)
            
            if  let story = cellViewModel?.getStoryImageVideoView(type: .rightClick, currentIndex: (cellViewModel?.storyIndex)!){
                print("update story view started")
                updateStoryView(story: story)
                
            }
        } else {
            print("Ignore in-between touch.")
        }
        
        
    }
    
    func updateStoryView(story: TypedStroies) {
        print("<<<>>>",story.type," ",story.value)
        if story.type == "image" {
            print("<<<>>>Updating Image")
            bodyImageView.isHidden = false
            bodyVideoView.isHidden =  true
            bodyImageView.image = UIImage(named: story.value)

        } else if story.type == "video" {
            print("<<<>>>Updating Video")
            bodyImageView.isHidden =  true
            bodyVideoView.isHidden =  false
            playVideoWithFileName(story.value, ofType: "mp4")

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
            bodyVideoView.leadingAnchor.constraint(equalTo:bodyView.leadingAnchor,constant: 0),
            bodyVideoView.topAnchor.constraint(equalTo: bodyView.topAnchor,constant: 10),
            bodyVideoView.trailingAnchor.constraint(equalTo:bodyView.trailingAnchor,constant: 10),
            bodyVideoView.bottomAnchor.constraint(equalTo:bodyView.bottomAnchor,constant: 10),
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
        guard let stories =  cellViewModel?.storyModel?.typedStories else{
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
        bodyVideoView.isHidden = true
        if let story:TypedStroies = cellViewModel?.storyModel?.typedStories.first{
            updateStoryView(story: story)
        }

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
    //update video View
    
    fileprivate func addPlayerToView(_ view: UIView) {
           player = AVPlayer()
           let playerLayer = AVPlayerLayer(player: player)
           playerLayer.frame = self.bounds
           playerLayer.videoGravity = .resizeAspectFill
           view.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
       }
    func playVideoWithFileName(_ fileName: String, ofType type:String) {
        print("playing",fileName)
          guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else { return }
          let videoURL = URL(fileURLWithPath: filePath)
          let playerItem = AVPlayerItem(url: videoURL)
          player?.replaceCurrentItem(with: playerItem)
          player?.play()
      }
    @objc func playerEndPlay() {
          print("Player ends playing video")
      }
}



