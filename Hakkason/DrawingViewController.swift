//
//  DrawingViewController.swift
//  Hakkason
//
//  Created by 下村一将 on 2016/07/30.
//  Copyright © 2016年 白田光. All rights reserved.
//

import UIKit
import ACEDrawingView

class DrawingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let ad = UIApplication.sharedApplication().delegate as! AppDelegate
    var SaveButton: UIBarButtonItem!
    
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
        
//        let image = UIImage(named: "ScreenShot")
//        drawingView.drawMode = ACEDrawingMode.OriginalSize
//
//        drawingView.loadImage(image)
        

        // Do any additional setup after loading the view.
    }
    
    internal func onClickSaveButton(sender: UIButton){
       
        //
        let Image: UIImage = self.drawingView.image
        
        //アルバムに追加
        UIImageWriteToSavedPhotosAlbum(Image, self, nil, nil)
        
        let alert: UIAlertController = UIAlertController(title: "保存が完了しました！", message: "", preferredStyle:  UIAlertControllerStyle.Alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })

            
            alert.addAction(defaultAction)
            
            // ④ Alertを表示
            presentViewController(alert, animated: true, completion: nil)
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
    
    
    @IBAction func imagePick(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            let ipc:UIImagePickerController = UIImagePickerController()
            ipc.delegate = self
            ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(ipc, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info [UIImagePickerControllerOriginalImage] != nil {
            drawingView.drawMode = ACEDrawingMode.Scale
            drawingView.loadImage(info[UIImagePickerControllerOriginalImage] as? UIImage)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
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
