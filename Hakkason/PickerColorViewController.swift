//
//  PickerColorViewController.swift
//  Hakkason
//
//  Created by 下村一将 on 2016/07/30.
//  Copyright © 2016年 白田光. All rights reserved.
//

import UIKit

class PickerColorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let ad = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSize:CGFloat = self.view.frame.size.width/3-7
        // 正方形で返すためにwidth,heightを同じにする
        return CGSizeMake(cellSize, cellSize)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        
        if indexPath.row == 0 {
            cell.pickedColorView.backgroundColor = colorWithHexString("000000")
        }else if indexPath.row == 1 {
            cell.pickedColorView.backgroundColor = colorWithHexString("FFFFFF")
        }else if indexPath.row == 2 {
            cell.pickedColorView.backgroundColor = colorWithHexString("a5d1f4")
        }else if indexPath.row == 3 {
            cell.pickedColorView.backgroundColor = colorWithHexString("e4ad6d")
        }else if indexPath.row == 4 {
            cell.pickedColorView.backgroundColor = colorWithHexString("d685b0")
        }else if indexPath.row == 5 {
            cell.pickedColorView.backgroundColor = colorWithHexString("dbe159")
        }else if indexPath.row == 6 {
            cell.pickedColorView.backgroundColor = colorWithHexString("7fc2ef")
        }else if indexPath.row == 7 {
            cell.pickedColorView.backgroundColor = colorWithHexString("c4a6ca")
        }else if indexPath.row == 8 {
            cell.pickedColorView.backgroundColor = colorWithHexString("eabf4c")
        }else if indexPath.row == 9 {
            cell.pickedColorView.backgroundColor = colorWithHexString("f9e697")
        }else if indexPath.row == 10 {
            cell.pickedColorView.backgroundColor = colorWithHexString("b3d3ac")
        }else if indexPath.row == 11 {
            cell.pickedColorView.backgroundColor = colorWithHexString("eac7cd")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            ad.pickedColor = colorWithHexString("000000")
        }else if indexPath.row == 1 {
            ad.pickedColor = colorWithHexString("FFFFFF")
        }else if indexPath.row == 2 {
            ad.pickedColor = colorWithHexString("a5d1f4")
        }else if indexPath.row == 3 {
            ad.pickedColor = colorWithHexString("e4ad6d")
        }else if indexPath.row == 4 {
            ad.pickedColor = colorWithHexString("d685b0")
        }else if indexPath.row == 5 {
            ad.pickedColor = colorWithHexString("dbe159")
        }else if indexPath.row == 6 {
            ad.pickedColor = colorWithHexString("7fc2ef")
        }else if indexPath.row == 7 {
            ad.pickedColor = colorWithHexString("c4a6ca")
        }else if indexPath.row == 8 {
            ad.pickedColor = colorWithHexString("eabf4c")
        }else if indexPath.row == 9 {
            ad.pickedColor = colorWithHexString("f9e697")
        }else if indexPath.row == 10 {
            ad.pickedColor = colorWithHexString("b3d3ac")
        }else if indexPath.row == 11 {
            ad.pickedColor = colorWithHexString("eac7cd")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    @IBAction func cancelPushed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func colorWithHexString (hex:String) -> UIColor {
        
        let cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if ((cString as String).characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringWithRange(NSRange(location: 0, length: 2))
        let gString = (cString as NSString).substringWithRange(NSRange(location: 2, length: 2))
        let bString = (cString as NSString).substringWithRange(NSRange(location: 4, length: 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(
            red: CGFloat(Float(r) / 255.0),
            green: CGFloat(Float(g) / 255.0),
            blue: CGFloat(Float(b) / 255.0),
            alpha: CGFloat(Float(1.0))
        )
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


class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var pickedColorView: UIView!
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
}