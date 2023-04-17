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
    var shouldChangeUserStory: Bool = false
    //    var timer: Timer
    
}
enum userStoryActionType {
    case rightClick
    case leftClick
}


class storyCVC: UICollectionViewCell, UIGestureRecognizerDelegate {
    static let identifier = "storyCVC"
    private var userStoryCellCallBack: ((userStoryCellActionCallBack) -> Void)!
    var cellViewModel:storyCVCM?{
        didSet{
            configureData()
            configureProgressView()
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
    var player: AVPlayer!
    let imageLabelStackView : UIStackView = UIStackView()
    var nameLabel:UILabel = UILabel()
    var imageView: UIImageView = UIImageView()
    var currentIndex:Int = 0// index of the currently animating progress view
    internal var timer: Timer?
    var isAnimating:Bool = false {
        didSet {
            SPB.startAnimation()
            SPB.isPaused = false
        }
    }
    var SPB: SegmentedProgressBar!
    
    // Override the init(frame:) method to set up the cell's views and constraints.
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        isAnimating = ((cellViewModel?.isAnimating) != nil)
    }
    
    override func prepareForReuse() {
        print("call Garbage collector")
        if isAnimating {
            
            isAnimating = false
            self.SPB.cancel()
            self.SPB.isPaused = true
            resetPlayer()
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
    }
    
}
extension storyCVC {
    func configureView() {
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
        configureProgressView()
        configureLongPress()
    }
    
    func configureProgressView() {
        stackProgressView.layoutMargins = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        stackProgressView.backgroundColor = .yellow
        guard let segmentCount = cellViewModel?.storyModel?.typedStories.count  else{
            return
        }
        SPB = SegmentedProgressBar(numberOfSegments: segmentCount, duration: 10)
        
        SPB.delegate = self
        SPB.topColor = UIColor.white
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        SPB.padding = 5
        SPB.isPaused = true
        if #available(iOS 11.0, *) {
            SPB.frame = CGRect(x: 18, y:0, width: self.frame.width - 40, height: 5)
        } else {
            // Fallback on earlier versions
            SPB.frame = CGRect(x: 18, y: 15, width: self.frame.width - 35, height: 3)
        }
        stackProgressView.addSubview(SPB)
        stackProgressView.bringSubviewToFront(SPB)
        
    }
    
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
    func configureLongPress(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.bodyVideoView.addGestureRecognizer(lpgr)

    }
    //MARK: - UILongPressGestureRecognizer Action -
        @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
            print("<<<>>> longPress detected")
            if gestureReconizer.state != UIGestureRecognizer.State.ended {
                //When lognpress is start or running
                player.pause()
            }
            else {
                //When lognpress is finish
                player.play()
            }
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
                SPB.rewind()
        }
        
        else if location.x >= (self.bodyImageView.frame.size.width - touchAreaWidth) {
            print("Right area touched")
         
            SPB.skip()
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
    
    func changeUserStory(currentIndex: Int){
       return
        
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
        resetPlayer()
        addPlayerToView(bodyVideoView)
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else { return }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: videoURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    @objc func playerEndPlay() {
        print("Player ends playing video")
    }
    private func resetPlayer() {
        if player != nil {
            player.pause()
            player.replaceCurrentItem(with: nil)
            player = nil
        }
    }

}


extension storyCVC : SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {
        print("change Story",index)
        if let story =  cellViewModel?.getTypedStories(index: index){
            resetPlayer()
            print("update story")
            currentIndex = index
            updateStoryView(story: story)
            
        }
        
        return
    }
    
    func segmentedProgressBarFinished() {
        print("<<<Finished")
        let callBack = userStoryCellActionCallBack.init(type: .rightClick,currentStoryIndex: cellViewModel?.storyIndex ?? 0, storiesCount: cellViewModel?.typedStories.count ?? 0)
        userStoryCellCallBack(callBack)
        return
    }
    
    
}

