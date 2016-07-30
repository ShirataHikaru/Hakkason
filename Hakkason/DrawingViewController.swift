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
    var SaveButton: UIBarButtonItem!
    
    // Sliderを作成
    let WidthSlider = UISlider(frame: CGRectMake(0, 0, 200, 30))
    var SliderDisplay: Bool = false
    
    //描画画面をアウトレット接続してあります。
    @IBOutlet weak var drawingView: ACEDrawingView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Saveボタンの作成
        SaveButton = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: "onClickSaveButton:")
        
        // ナビゲーションバーの右に設置
        self.navigationItem.rightBarButtonItem = SaveButton
        
        //線の太さの変更はこのように行います。
        drawingView.lineWidth = 2.0
        
        WidthSlider.layer.position = CGPointMake(self.view.frame.midX, 500)
        WidthSlider.backgroundColor = UIColor.whiteColor()
        WidthSlider.layer.cornerRadius = 10.0
        WidthSlider.layer.shadowOpacity = 0.5
        WidthSlider.layer.masksToBounds = false
        
        // 最小値と最大値を設定
        WidthSlider.minimumValue = 1.0
        WidthSlider.maximumValue = 10.0
        
        WidthSlider.addTarget(self, action: "onChangeWidthValueSlider:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    internal func onClickSaveButton(sender: UIButton){
        
        // 描いた画面をUIImageで取得
        let Image: UIImage? = self.drawingView.image
        
        if Image != nil {
        // アルバムに追加
        UIImageWriteToSavedPhotosAlbum(Image!, self, nil, nil)
        
        let alert: UIAlertController = UIAlertController(title: "保存が完了しました！", message: "", preferredStyle:  UIAlertControllerStyle.Alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            // ボタンが押された時の処理
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        presentViewController(alert, animated: true, completion: nil)
        }else{
            
        }
    }
    
    @IBAction func DrawUndo(sender: UIBarButtonItem) {
        self.drawingView.canUndo()
        self.drawingView.undoLatestStep()
    }
    
    @IBAction func DrawWidth(sender: UIBarButtonItem) {
        if SliderDisplay == false{
            self.view.addSubview(self.WidthSlider)
            SliderDisplay = true
        }else if SliderDisplay == true{
            WidthSlider.removeFromSuperview()
            SliderDisplay = false
        }
    }
    
    //Sliderの値が変わった時に呼ばれるメソッド
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
