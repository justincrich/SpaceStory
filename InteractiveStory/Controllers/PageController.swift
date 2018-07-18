//
//  PageController.swift
//  InteractiveStory
//
//  Created by Justin on 7/18/18.
//  Copyright © 2018 Justin. All rights reserved.
//

import UIKit
import Foundation

extension NSAttributedString{
    var entireStringRange: NSRange{
        return NSMakeRange(0, self.length)
    }
}

extension Page {
    func story(attributed:Bool)-> NSAttributedString{
        if(attributed){
            return story.attributedText
        }else{
            return NSAttributedString(string: story.text)
        }
    }
}

extension Story{
    var attributedText: NSAttributedString{
        let attributedString = NSMutableAttributedString(string:text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: attributedString.entireStringRange)
        return attributedString
    }
}


class PageController: UIViewController {
    
    //used as optional bc otherwise we'd have to set this up on init w dummy data
    var page: Page?
    
    // MARK: - User Interface Properties
    lazy var artworkView: UIImageView = {
       let imageView =  UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.page?.story.artwork
        return imageView;
    }()
    lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()
    lazy var firstChoiceButton: UIButton = {
        let button = UIButton(type:.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = self.page?.firstChoice?.title ?? "Play Again"
        
        let selector = self.page?.firstChoice != nil ? #selector(PageController.loadFirstChoice) : #selector(PageController.playAgain)
        
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        return button
    }()
    lazy var secondChoiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(self.page?.secondChoice?.title, for: .normal)
        button.addTarget(self, action: #selector(PageController.loadSecondChoice), for: .touchUpInside)
        
        return button
    }()
    
    //init storyboard will use
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        //if we didn't use storyboards we could just throw a critical error
        //can't do because we're still using main.storyboard for first view
        //alternitively we could init page with a dummy item
    }
    
    init(page:Page){
        self.page = page
        super.init(nibName:nil,bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let page = page {

            storyLabel.attributedText = page.story(attributed:true)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(artworkView)
        view.addSubview(storyLabel)
        view.addSubview(firstChoiceButton)
        view.addSubview(secondChoiceButton)
        
        NSLayoutConstraint.activate([
            artworkView.topAnchor.constraint(equalTo: view.topAnchor),
            artworkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            artworkView.leftAnchor.constraint(equalTo: view.leftAnchor),
            artworkView.rightAnchor.constraint(equalTo: view.rightAnchor),
            storyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            storyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            storyLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -48.0),
            firstChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80.0),
            secondChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32.0),
        ])
        

    }
    
    @objc func loadFirstChoice() {
        if let page = page, let firstChoice = page.firstChoice {
            let nextPage = firstChoice.page
            let pageController = PageController(page: nextPage)
            
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    
    @objc func loadSecondChoice() {
        if let page = page, let secondChoice = page.secondChoice {
            let nextPage = secondChoice.page
            let pageController = PageController(page: nextPage)
            
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    
    @objc func playAgain(){
        navigationController?.popToRootViewController(animated: true)
    }
    

}
