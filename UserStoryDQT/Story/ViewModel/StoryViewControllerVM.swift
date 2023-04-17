//
//  StoryViewControllerVM.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 13/04/23.
//

import Foundation
import UIKit

protocol StoryViewControllerVMCellAction {
    func showCellDataAction(cell: storyCVCProtocol,indexPath: IndexPath)
    
}
protocol StoryViewControllerDelegate: AnyObject {
    func upadateUserStory(type:userStoryActionType, indexPath:IndexPath)
}

class StoryViewControllerVM {
    var  storyModel:StoryModel? {
        didSet{
            print("storyModel Value set",storyModel!)
            
        }
    }
    let userStories: [StoryModel]?
    var userIndex:Int = 0
    var startWithUserIndexPath:IndexPath? = nil
    weak var delegate:StoryViewControllerDelegate? = nil
    
    init(storyModel: StoryModel?, userStories: [StoryModel]?){
        self.userStories = userStories
        self.storyModel = storyModel
        print("<<<>>",storyModel?.id ," ",storyModel?.name," ",storyModel?.imageView," ",storyModel?.typedStories)
    }
 
    func getCellFromViewModel(indexPath: IndexPath) -> StoryModel? {
        storyModel = userStories?[indexPath.item]
        return userStories?[indexPath.item]
    }
    
}
extension StoryViewControllerVM: StoryViewControllerVMCellAction {
    func showCellDataAction(cell: storyCVCProtocol ,indexPath: IndexPath) {
        let viewModel:storyCVCM = storyCVCM.init(storyModel: getCellFromViewModel(indexPath: indexPath))
        cell.showCellDataWithCallback(viewModel: viewModel) { [weak self] userStoryCellActionCallBack in
            let index = userStoryCellActionCallBack.currentStoryIndex
            let storiesCount:Int? = userStoryCellActionCallBack.storiesCount
            switch userStoryCellActionCallBack.type {
            case .leftClick:
                print("callback left Click")
                 if let  count = storiesCount {
                    print("index and count ",index, count)
                    if index-1 < 0 {
                       
                        print("moving to back story")
                        self?.delegate?.upadateUserStory(type: .leftClick, indexPath: indexPath)

                    }
                }
               
                break
                
            case .rightClick: //NEXT Story
                print("call back right click")
                if let  count = storiesCount {
                    print("<<<>>>index and count ",index, count)
                    if index+1 >= count  {
                        print("<<<>>>index and count ",index+1, count)
                        print("moving to next story")
                        self?.delegate?.upadateUserStory(type: .rightClick, indexPath: indexPath)
                        
                    }
                }

                break
                
            }
            
        }
        
    }
  

    
}



