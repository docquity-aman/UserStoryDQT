//
//  preViewController.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 18/04/23.
//

import UIKit
import AVKit

class PreViewController: UIViewController ,UIGestureRecognizerDelegate{
    
    
    var preViewControllerVM: PreViewControllerVM!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileLabelName: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var player: AVPlayer?
    var SPB : SegmentedProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
        configureData()
        
    }
    func configureView() {
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
        let segments: Int = preViewControllerVM.userDetails[preViewControllerVM.pageIndex].typedStories.count
        configureProgressBar(segments: segments)
        configureTapGestures()
        view.backgroundColor =  .black
        configureLongPress()
    }
    
    func configureData() {
        
        guard let firstStory = preViewControllerVM.typedStory?.first else{
            return
        }
        profileLabelName.text = preViewControllerVM?.profileLabel
        profileImageView.image = UIImage (named: (preViewControllerVM?.profileImage)!)
        updateStoryView(story: preViewControllerVM.typedStory?.first ?? firstStory)
        
        
        
    }
    
    func configureProgressBar(segments:Int) {
        
        SPB = SegmentedProgressBar(numberOfSegments: segments , duration: 20)
        if #available(iOS 11.0, *) {
            SPB.frame = CGRect(x: 18, y: UIApplication.shared.statusBarFrame.height + 5, width: view.frame.width - 35, height: 3)
        } else {
            // Fallback on earlier versions
            SPB.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 3)
        }
        
        SPB.delegate = self
        SPB.topColor = UIColor.white
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        SPB.padding = 2
        SPB.isPaused = true
        SPB.currentAnimationIndex = 0
        //        SPB.duration = getDuration(at: 0)
        view.addSubview(SPB)
        view.bringSubviewToFront(SPB)
    }
    
    func configureTapGestures() {
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGestureImage)
        
        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureVideo.numberOfTapsRequired = 1
        tapGestureVideo.numberOfTouchesRequired = 1
        videoView.addGestureRecognizer(tapGestureVideo)
        
        
    }
    
    func configureLongPress(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.videoView.addGestureRecognizer(lpgr)
        
    }
    //MARK: - UILongPressGestureRecognizer Action -
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        print("<<<>>> longPress detected")
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            //When lognpress is start or running
            guard let player = self.player else {
                return
            }
            player.pause()
            SPB.isPaused = true
        }
        else {
            //When lognpress is finish
            guard let player =  self.player else {
                return
            }
            player.play()
            SPB.isPaused = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.8) {
            self.view.transform = .identity
        }
        transitionAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.SPB.startAnimation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.SPB.currentAnimationIndex = 0
            self.SPB.cancel()
            self.SPB.isPaused = true
            self.resetPlayer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: videoView)
        let touchAreaWidth: CGFloat = 80
        
        if location.x <= touchAreaWidth {
            print("Left area touched")
            SPB.rewind()
        }
        
        else if location.x >= (self.videoView.frame.size.width - touchAreaWidth) {
            print("Right area touched")
            SPB.skip()
        } else {
            print("Ignore in-between touch.")
        }
    }
    
    
    
    
    
    
}

extension PreViewController {
    fileprivate func addPlayerToView(_ view: UIView) {
        player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    func playVideoWithFileName(_ fileName: String, ofType type:String) {
        print("playing",fileName)
        resetPlayer()
        addPlayerToView(videoView)
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else { return }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url:  videoURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    func playVideoWithURL(_ url : String){
        //"https://moctobpltc-i.akamaihd.net/hls/live/571329/eight/playlist.m3u8"
        resetPlayer()
        addPlayerToView(videoView)
        guard let videosURL = URL(string: url) else {
            fatalError()
        }
        let playerItem =  AVPlayerItem(url: videosURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
        
    }

    
    @objc func playerEndPlay() {
        print("Player ends playing video")
    }
    private func resetPlayer() {
        
        if player != nil {
            player?.pause()
            player?.replaceCurrentItem(with: nil)
            player = nil
        }
    }
}

extension PreViewController {
    
    func updateStoryView(story: TypedStroies) {
        print("<<<>>>",story.type," ",story.value)
        resetPlayer()
        if story.type == "image" {
            print("<<<>>>Updating Image")
            imageView.isHidden = false
            videoView.isHidden =  true
            
            imageView.image = UIImage(named: story.value)
            
        } else if story.type == "video" {
            print("<<<>>>Updating Video")
            imageView.isHidden =  true
            videoView.isHidden =  false
            playVideoWithFileName(story.value, ofType: "m3u8")
            
            
        }
        
        
    }
    
}


extension PreViewController : SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {
        print("<<>>index", index)
        if let typedStories: TypedStroies = preViewControllerVM.getTypedStories(index: index) {
            updateStoryView(story: typedStories)
        }
        
    }
    
    func segmentedProgressBarFinished() {
        if preViewControllerVM.pageIndex == (self.preViewControllerVM.userDetails.count - 1) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            let pageIndex = preViewControllerVM.pageIndex
            _ = ContentViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
        }
    }
    
    
}

extension PreViewController {
    func transitionAnimation() {
        
    }
}
//extension PreViewController: UIViewControllerAnimatedTransitioning{
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        <#code#>
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        <#code#>
//    }
//    
//    
//}
