//
//  WHNullViewController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/7/5.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHNullViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeBackgroundColor
        let imageView = UIImageView(image: #imageLiteral(resourceName: "construccion"))
        imageView.center = self.view.center
        view.addSubview(imageView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Volver", style: .done, target: self, action: #selector(volver))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   @objc private func volver(){
        self.dismiss(animated: true, completion: nil)
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
