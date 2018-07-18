//
//  Page.swift
//  InteractiveStory
//
//  Created by Justin on 7/18/18.
//  Copyright © 2018 Justin. All rights reserved.
//

import Foundation

class Page{
    let story:Story
    //touple is an anonomous struct
    typealias Choice = (title:String, page:Page)
    
    var firstChoice:Choice?
    var secondChoice:Choice?
    
    init(story:Story){
        self.story = story
    }
    
}

extension Page {
    //add a choice by specifying which story we want to go to w/o knowing the page
    func addChoiceWith(title: String, story: Story) -> Page {
        let page = Page(story:story)
        return addChoiceWith(title: title, page: page)
    }
    
    func addChoiceWith(title: String, page: Page) -> Page {
        switch (firstChoice, secondChoice){
        case (.some,.some): return self
        case (.none,.none),(.none,.some): firstChoice = (title,page)
        case (.some,.none): secondChoice = (title,page)
        }
        return page
    }
}




