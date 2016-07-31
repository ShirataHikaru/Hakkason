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
import SCLAlertView


class DrawingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCBrowserViewControllerDelegate,MCSessionDelegate, ModalViewControllerDelegate {

    
    let ad = UIApplication.sharedApplication().delegate as! AppDelegate
    let modalView = WaitmessageViewController()
    var SaveButton: UIBarButtonItem!
    
    // Sliderを作成
    let WidthSlider = UISlider(frame: CGRectMake(0,0, 200, 30))
    var SliderDisplay: Bool = false

    let serviceType = "LCOC-Chat"
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!

    @IBAction func alldeletepush(sender: AnyObject) {
         let alert = SCLAlertView()
        alert.addButton("Yes"){
            self.dismissViewControllerAnimated(true, completion: nil)
             self.drawingView.clear()
        }
                        alert.addButton("no") {
            print("Second button tapped")
        }
        alert.showSuccess("本当によろしいですか？", subTitle: "")
        //let alert:UIAlertController = UIAlertController(title: "全部削除しますがよろしいですか？",message: "",preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",style: UIAlertActionStyle.Cancel,
                                                       handler: {
                                                        (action:UIAlertAction!) -> Void in
                                                        print("Cancel")
        })
      /*  let defaultAction:UIAlertAction = UIAlertAction(title:"OK",style: UIAlertActionStyle.Default,handler: {
            (action:UIAlertAction!) -> Void in
            self.drawingView.clear()
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)*/
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //描画画面をアウトレット接続してあります。
    @IBOutlet weak var drawingView: ACEDrawingView!
    var SerchButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        SerchButton = UIBarButtonItem(title:"検索",style: .Plain,target:self,action: "OnClickSerchButton:")
        self.navigationItem.leftBarButtonItem = SerchButton
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "p0096_l.jpg")?.drawInRect(self.view.bounds)
        
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
//        self.session.delegate = self
        self.browser = MCBrowserViewController(serviceType:serviceType,
                                               session:self.session)
//        self.browser.delegate = self;
        self.session.delegate = self
        self.browser = MCBrowserViewController(serviceType:serviceType,
                                               session:self.session)
        self.browser.delegate = self;

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
        
        WidthSlider.layer.position = CGPointMake(self.view.frame.midX, 500)
        WidthSlider.backgroundColor = UIColor.whiteColor()
        WidthSlider.layer.cornerRadius = 10.0
        WidthSlider.layer.shadowOpacity = 0.5
        WidthSlider.layer.masksToBounds = false
        
        // 最小値と最大値を設定
        WidthSlider.minimumValue = 1.0
        WidthSlider.maximumValue = 10.0
        
        WidthSlider.addTarget(self, action: "onChangeWidthValueSlider:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.modalView.delegate = self

        
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        
////        let vc = WaitmessageViewController()
////        vc.dismissViewControllerAnimated(true, completion: nil)
//    }
    

    
    
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
        self.WidthSlider.layer.position = CGPoint(x: self.view.frame.size.width * 0.5, y:self.view.frame.size.height * 0.85 )
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
    
    @IBAction func send(sender: UIBarButtonItem) {
        let sendimg =  self.drawingView.image
        let transimg = UIImagePNGRepresentation(sendimg!)
//             let nextVc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as!
        var error : NSError?
        do {
            try self.session.sendData(transimg!,
                                      toPeers: self.session.connectedPeers,
                                      withMode: MCSessionSendDataMode.Unreliable)
            let alert = SCLAlertView()
            let alertView = SCLAlertView()
            alertView.showSuccess("送信待機中", subTitle: "",duration: 2.0)
            alert.showWait("受信待機中", subTitle: "")            //let alert:UIAlertController =  UIAlertController(title: "受診待機中",message: "",preferredStyle: UIAlertControllerStyle.Alert)
            presentViewController(alert, animated: true, completion: nil)
           
       
//            self.presentViewController(nextVc, animated: true, completion: nil)
            
            //performSegueWithIdentifier("waitSegue", sender: self)
        } catch {
            // do something.
        }
        
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }


    }
    func updateimg(recimg:NSData){
    print("でーたをうけとりました。")
        self.dismissViewControllerAnimated(true, completion: nil)
        let chatchimage : UIImage! = UIImage(data:recimg)
        let imgView = UIImageView(image:chatchimage)
        let image = SpringImageView(image: chatchimage)
        image.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100)
        image.layer.position = CGPoint(x: self.view.frame.width * 0.5, y: self.view.frame.height * 0.5)
        image.contentMode = .ScaleToFill
        self.view.addSubview(image)
        self.view.bringSubviewToFront(image)
        image.animation = "fadeInDown"
        image.duration = 1.5
        image.animate()
        
        let delay = 1.5 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            image.removeFromSuperview()
           
        self.drawingView.drawMode = ACEDrawingMode.Scale
        self.drawingView.loadImage(chatchimage)
            })
//        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
       // ad.modalVC = WaitmessageViewController()
        //ad.modalVC.dismissViewControllerAnimated(true, completion: nil)
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
           
            

            //self.modalDidfinished()
            //self.modalView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
//        self.modalView.dismissViewContorollerAnimated(true, completion: nil)

    }

    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession!,
                 didStartReceivingResourceWithName resourceName: String!,
                                                   fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!)  {
        navigationController?.navigationBar.topItem?.title = peerID.displayName
        
        
        // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession!,
                 didFinishReceivingResourceWithName resourceName: String!,
                                                    fromPeer peerID: MCPeerID!,
                                                             atURL localURL: NSURL!, withError error: NSError!)  {
        // Called when a file has finished transferring from another peer
        navigationController?.navigationBar.topItem?.title = peerID.displayName
        

    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
                 withName streamName: String!, fromPeer peerID: MCPeerID!)  {
        // Called when a peer establishes a stream with us
        navigationController?.navigationBar.topItem?.title = peerID.displayName
        

    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!,
                 didChangeState state: MCSessionState)  {
        // Called when a connected peer changes state (for example, goes offline)
        navigationController?.navigationBar.topItem?.title = peerID.displayName
        

        
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
    func modalDidfinished() {
        self.modalView.dismissViewControllerAnimated(true, completion: nil)
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
