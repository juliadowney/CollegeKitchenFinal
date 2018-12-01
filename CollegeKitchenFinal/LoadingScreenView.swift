//
//  LoadingScreenView.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/30/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class LoadingScreenView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let pull = PullCalls()
    
    required init(inputFrame: CGRect) {
       
        super.init(frame: inputFrame)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.backgroundColor = UIColor.blue
        let waitingJoke = UILabel()
        print(self.frame)
        waitingJoke.frame = CGRect(x: self.frame.minX, y: activityIndicator.frame.minY - activityIndicator.frame.height, width: self.frame.width, height: self.frame.height - (activityIndicator.frame.minY - activityIndicator.frame.height))
        waitingJoke.text = getJoke()
        
        activityIndicator.backgroundColor = UIColor.white
        activityIndicator.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.frame.height - self.frame.height*2)
        activityIndicator.color = UIColor.black
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.addSubview(waitingJoke)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getJoke() -> String{
        
        var joke:Joke!
        DispatchQueue.global(qos: .userInitiated).async {

        self.pull.getFoodJoke(){returnJoke in
            joke = returnJoke
            
                DispatchQueue.main.async {
            
                    return joke.text
                }
                
            }
        }
            
          return "THIS ISN'T WORKING"
        
    }
    
    
   

}
