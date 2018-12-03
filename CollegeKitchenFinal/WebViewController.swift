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
        print(urlString)
        if let url = URL(string: urlString){
            let myURLRequest = URLRequest(url: url)
            webView = WKWebView(frame: view.frame)
            webView.load(myURLRequest)
            view.addSubview(webView)
             self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backtoGetRecipes))
        }else{
            navigationController?.popViewController(animated: true)
        }
        // Do any additional setup after loading the view.
    }

    @objc func backtoGetRecipes(){
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
