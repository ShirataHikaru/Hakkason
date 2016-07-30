//
//  DrawingViewController.swift
//  Hakkason
//
//  Created by 下村一将 on 2016/07/30.
//  Copyright © 2016年 白田光. All rights reserved.
//

import UIKit
import ACEDrawingView
import MultipeerConnectivity


class DrawingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let ad = UIApplication.sharedApplication().delegate as! AppDelegate

    var SaveButton: UIBarButtonItem!
    
    let serviceType = "LCOC-Chat"
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!

    //描画画面をアウトレット接続してあります。
    @IBOutlet weak var drawingView: ACEDrawingView!
    var SerchButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        SerchButton = UIBarButtonItem(title:"検索",style: .Plain,target:self,action: "OnClickSerchButton:")
        self.navigationItem.leftBarButtonItem = SerchButton
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
//        self.session.delegate = self
        self.browser = MCBrowserViewController(serviceType:serviceType,
                                               session:self.session)
//        self.browser.delegate = self;
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
                                               discoveryInfo:nil, session:self.session)
        self.assistant.start()
         navigationItem.backBarButtonItem?.accessibilityElementsHidden = true
        

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
    @IBAction func send(sender: UIBarButtonItem) {
        let sendimg =  self.drawingView.image
        let transimg = UIImagePNGRepresentation(sendimg!)
        var error : NSError?
        do {
            try self.session.sendData(transimg!,
                                      toPeers: self.session.connectedPeers,
                                      withMode: MCSessionSendDataMode.Unreliable)
        } catch {
            // do something.
        }
        
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }


    }
    func updateimg(recimg:NSData){
        let chatchimage : UIImage! = UIImage(data:recimg)
        let imgView = UIImageView(image:chatchimage)
        self.drawingView.drawMode = ACEDrawingMode.Scale
        self.drawingView.loadImage(chatchimage)
    }
    internal func OnClickSerchButton(sender:UIButton){
         self.presentViewController(self.browser, animated: true, completion: nil)
    }
   
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController!)  {
        // Called when the browser view controller is dismissed (ie the Done
        // button was tapped)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController!)  {
        // Called when the browser view controller is cancelled
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!,
                 fromPeer peerID: MCPeerID!)  {
        // Called when a peer sends an NSData to us
        
        // This needs to run on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            
            
            
            self.updateimg(data!)
        }
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession!,
                 didStartReceivingResourceWithName resourceName: String!,
                                                   fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!)  {
        
        // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession!,
                 didFinishReceivingResourceWithName resourceName: String!,
                                                    fromPeer peerID: MCPeerID!,
                                                             atURL localURL: NSURL!, withError error: NSError!)  {
        // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
                 withName streamName: String!, fromPeer peerID: MCPeerID!)  {
        // Called when a peer establishes a stream with us
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!,
                 didChangeState state: MCSessionState)  {
        // Called when a connected peer changes state (for example, goes offline)
        
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
