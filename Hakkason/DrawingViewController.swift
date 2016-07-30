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
        
        let image = UIImage(named: "ScreenShot")
        drawingView.drawMode = ACEDrawingMode.OriginalSize

        drawingView.loadImage(image)
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func DrawUndo(sender: UIBarButtonItem) {
        self.drawingView.canUndo()
        self.drawingView.undoLatestStep()
    }
    
    @IBAction func DrawWidth(sender: UIBarButtonItem) {
        // Sliderを作成する.
        let WidthSlider = UISlider(frame: CGRectMake(0, 0, 200, 30))
        WidthSlider.layer.position = CGPointMake(self.view.frame.midX, 500)
        WidthSlider.backgroundColor = UIColor.whiteColor()
        WidthSlider.layer.cornerRadius = 10.0
        WidthSlider.layer.shadowOpacity = 0.5
        WidthSlider.layer.masksToBounds = false
        
        // 最小値と最大値を設定する.
        WidthSlider.minimumValue = 1.0
        WidthSlider.maximumValue = 10.0
        
        WidthSlider.addTarget(self, action: "onChangeWidthValueSlider:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(WidthSlider)
    }
    
    /*
     Sliderの値が変わった時に呼ばれるメソッド
     */
    internal func onChangeWidthValueSlider(sender : UISlider){
        drawingView.lineWidth = CGFloat(sender.value)
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
