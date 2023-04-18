//
//  PreViewControllerVM.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 18/04/23.
//

import Foundation

class PreViewControllerVM {
    var pageIndex:Int
    var userDetails :[StoryModel]
    
    var profileLabel: String?
    var typedStory:[TypedStroies]?
    var profileImage: String?
    
    init(pageIndex: Int, userDetails: [StoryModel], profileLabel: String? = nil, typedStory: [TypedStroies]? = nil, profileImage: String? = nil) {
        print(userDetails.count)
        self.pageIndex = pageIndex
        self.userDetails = userDetails
        self.profileLabel = profileLabel
        self.typedStory = typedStory
        self.profileImage = profileImage
        self.typedStory = userDetails[pageIndex].typedStories
        self.profileImage = userDetails[pageIndex].imageView
        self.profileLabel = userDetails[pageIndex].name
    }
    
    func getTypedStories(index:Int?) -> TypedStroies? {
        guard let index = index, index<=typedStory!.count-1 else {return nil}
//        self.pageIndex = index
        print("<<<>>>index",index)
        guard let typedStory = typedStory?[index] else {
            return nil
        }
            return typedStory
    }
}
