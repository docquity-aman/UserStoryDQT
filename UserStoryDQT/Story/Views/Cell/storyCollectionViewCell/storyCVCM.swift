//
//  storyCVCM.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 13/04/23.
//

import Foundation
class storyCVCM {
    let storyModel: StoryModel?
    var storyIndex:Int?
    var stories: [String] = []
    var typedStories: [TypedStroies ] = []
    var isAnimating:Bool = false
    init(storyModel: StoryModel?) {
       
        self.storyModel = storyModel
        storyIndex = 0
        stories = getStories()
        typedStories = getTypedStories()
    
    }
    func getImage() -> String {
        guard let storyModel = self.storyModel else {
            return ""
        }
        return storyModel.imageView
    }
    
    func getStories() -> [String] {
        guard let stories = self.storyModel?.stories else {
            return []
        }
        return stories
    }
    
    func getTypedStories() ->  [TypedStroies] {
        guard let stories = self.storyModel?.typedStories else {
            return []
        }
        return stories
    }
    
    func getStoryImageVideoView(type: userStoryActionType ,currentIndex:Int)  -> TypedStroies?{
        switch type {
            
        case .rightClick:
            print("storiesCount",getTypedStories().count)
            print("indexCount",currentIndex)
            if currentIndex >= getTypedStories().count - 1 {
                return nil
            }
//            let story = getStories()[currentIndex+1]
            let story = getTypedStories()[currentIndex + 1]
            
            self.storyIndex = currentIndex + 1
            return story
            
        case .leftClick:
            if currentIndex <= 0 {
                return nil
            }
            let story = getTypedStories()[currentIndex - 1]
            self.storyIndex = currentIndex - 1
            return story
        }
    }
    
    
    
    
}
