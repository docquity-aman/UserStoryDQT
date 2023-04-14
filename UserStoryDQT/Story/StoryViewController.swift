//
//  StoryViewController.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 13/04/23.
//

import UIKit

class StoryViewController: UIViewController {
    func create(storyModel: StoryModel,stories: [StoryModel]?,indexPath:IndexPath) -> StoryViewController {
            self.viewModel = StoryViewControllerVM(storyModel: storyModel,userStories: stories)
            self.viewModel.startWithUserIndexPath = indexPath
            self.viewModel.delegate = self
            self.startWithUserIndex = indexPath
            return self
        }
    
    lazy var storyView = StoryView()
    
    @IBOutlet weak var containerView: UIView!
    var viewModel: StoryViewControllerVM!
    var startWithUserIndex:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .red
        containerView.addSubview(storyView)
        storyView.frame = containerView.bounds
        configureData()

        // Do any additional setup after loading the view.
    }
 
    func configureView() {
        storyView.backgroundColor = .black
    }
    
    func configureData() {
        self.storyView.collectionView.dataSource = self
        self.storyView.collectionView.delegate = self
        self.storyView.collectionView.register(storyCVC.self, forCellWithReuseIdentifier: storyCVC.identifier)
        print("Lol",viewModel.userStories?.count)
        
        
        
    }
    
    

}

extension StoryViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userStories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCVC.identifier, for: indexPath) as? storyCVC else {
            return UICollectionViewCell()
        }
        viewModel.showCellDataAction(cell: cell,indexPath: indexPath)
        cell.startAnimation()
        

        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if let startWithUserIndex = self.startWithUserIndex {
            print("startWithUserIndex",startWithUserIndex.item)
            scrollToNeededCell(indexPath: startWithUserIndex)
          self.startWithUserIndex = nil
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: storyCVC, forItemAt indexPath: IndexPath) {
        cell.isAnimating = false
        for i in cell.progressViewsArray {
            i.setProgress(0, animated: false)
        }
    }
}

extension StoryViewController:StoryViewControllerDelegate {
    func upadateUserStory(type: userStoryActionType, indexPath: IndexPath) {
        
        switch type {

        case .leftClick:

            if let userStoriesCount = viewModel.userStories?.count {
                if indexPath.item <= 0 {
                    return
                }
                var nextIndexPath = indexPath
                nextIndexPath.item =  indexPath.item - 1
                scrollToNeededCell(indexPath: nextIndexPath)

            }
            return
            
        case .rightClick:
            if let userStoriesCount = viewModel.userStories?.count {
                if indexPath.item >= userStoriesCount - 1 {
                    return
                }
                var nextIndexPath = indexPath
                nextIndexPath.item =  indexPath.item + 1
                debugPrint("<<<>>>will call next story")
                scrollToNeededCell(indexPath: nextIndexPath)
               
            }
            return
            
        }
    }
    
    func scrollToNeededCell(indexPath: IndexPath){
        self.storyView.collectionView.isPagingEnabled = false
       
        self.storyView.collectionView.scrollToItem(
            at: indexPath ,
            at: .centeredHorizontally,
            animated: true
        )
        self.storyView.collectionView.isPagingEnabled = true
        
    }
  
}





