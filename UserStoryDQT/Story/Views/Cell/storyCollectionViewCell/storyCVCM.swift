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
    var isAnimating:Bool = false
    init(storyModel: StoryModel?) {
       
        self.storyModel = storyModel
        storyIndex = 0
        stories = getStories()
    
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
    
    func updateImageView(type: userStoryActionType ,currentIndex:Int)  -> String?{
        switch type {
            
        case .rightClick:
            print("storiesCount",getStories().count)
            print("indexCount",currentIndex)
            if currentIndex >= getStories().count-1 {
                return nil
            }
            let story = getStories()[currentIndex+1]
            self.storyIndex = currentIndex + 1
            return story
            
        case .leftClick:
            if currentIndex <= 0 {
                return nil
            }
            let story = getStories()[currentIndex-1]
            self.storyIndex = currentIndex - 1
            return story
        }
    }
    
    
    
    
}
