//
//  DrawingViewController.swift
//  Hakkason
//
//  Created by 下村一将 on 2016/07/30.
//  Copyright © 2016年 白田光. All rights reserved.
//

import UIKit
import ACEDrawingView

class DrawingViewController: UIViewController {
    
    let ad = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //描画画面をアウトレット接続してあります。
    @IBOutlet weak var drawingView: ACEDrawingView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //線の太さの変更はこのように行います。
        drawingView.lineWidth = 2.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        drawingView.lineColor = ad.pickedColor
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
