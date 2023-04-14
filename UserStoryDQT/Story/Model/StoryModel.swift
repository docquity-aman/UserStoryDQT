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
        storyModel?.append(StoryModel(name: "Aaaaaa", id: 1, imageView: "car1", stories: ["image1","image2"]))
        storyModel?.append(StoryModel(name: "Bbbbbb", id: 2, imageView: "car3", stories: ["image1","image2","image3"]))
        storyModel?.append(StoryModel(name: "Cccccc", id: 3, imageView: "car2", stories: ["image1"]))
        storyModel?.append(StoryModel(name: "Dddddd", id: 4, imageView: "car1", stories: ["image3","image4"]))
        storyModel?.append(StoryModel(name: "Eeeeee", id: 5, imageView: "car2", stories: ["image"]))
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
//    var multiStories
    
    init(name: String, id: Int, imageView: String, stories:[String]) {
        self.name = name
        self.id = id
        self.imageView = imageView
        self.stories =  stories
    }
    
}
