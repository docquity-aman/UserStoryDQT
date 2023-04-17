//
//  StoryModel.swift
//  UserStoryDQT
//
//  Created by Aman Verma on 13/04/23.
//

import Foundation
class HomeViewModel {
    var storyModel:[StoryModel]? = []
    init() {
        storyModel?.append(StoryModel(name: "Aaaaaa", id: 1, imageView: "car1", stories: ["image1","image2"], typedStories: [TypedStroies.init(value: "video1", type: "video"),TypedStroies.init(value: "image3", type: "image")]))
        storyModel?.append(StoryModel(name: "Eeeeee", id: 5, imageView: "car2", stories: ["image"], typedStories: [TypedStroies.init(value: "image1", type: "image"),TypedStroies.init(value: "video1", type: "video"),TypedStroies.init(value: "image3", type: "image")]))
        
    }
    
    func getCellFromViewModel(indexPath: IndexPath) -> StoryModel? {
        return storyModel?[indexPath.item]
    }
   
    
}

class StoryModel {
    let name: String
    let id: Int
    let imageView: String
    var stories: [String] = []
    var typedStories: [TypedStroies] = []
    
    init(name: String, id: Int, imageView: String, stories:[String],typedStories:[TypedStroies]) {
        self.name = name
        self.id = id
        self.imageView = imageView
        self.stories =  stories
        self.typedStories = typedStories
    }
    
}

class TypedStroies {
    let value : String
    let type : String
    
    init(value: String, type: String) {
        self.value = value
        self.type = type
    }
}
