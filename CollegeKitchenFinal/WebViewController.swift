//
//  WebViewController.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 12/2/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var recipe: Recipe!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let goodTitle = recipe.title.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.google.co.uk/search?query=\(goodTitle)"
        if let url = URL(string: urlString){
            let myURLRequest = URLRequest(url: url)
            webView = WKWebView(frame: view.frame)
            webView.load(myURLRequest)
            view.addSubview(webView)
             self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backtoGetRecipes))
        }else{
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func backtoGetRecipes(){
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
