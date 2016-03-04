//
//  AuditViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/21.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class AuditViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    var itemArry  = NSArray()
    var imageArry  =  NSArray()
    var itemWith:CGFloat = 0
    var itemHeight:CGFloat = 0
    var cv : UICollectionView?
    var titleStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "审核列表"
        self.tabBarController?.tabBar.hidden = true
        
        itemArry  = ["考勤","报销","盖章"]
        imageArry  = ["p1","p3","p4"]
        itemWith = (CGRectGetWidth(UIScreen.mainScreen().bounds)-10-15)/4
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(itemWith,itemWith)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10)//设置边距
        layout.minimumLineSpacing = 5.0;//每个相邻layout的上下
        layout.minimumInteritemSpacing = 5.0;//每个相邻layout的左右
        
        cv = UICollectionView(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds)),collectionViewLayout:layout)
        cv?.registerClass(checkMeetingRoomCollectionCell.self, forCellWithReuseIdentifier:"cell")
        cv?.delegate = self
        cv?.dataSource = self
        cv?.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(cv!)
        
        
        addLeftItem()
    }
    func addLeftItem()
    {
        let btn1 = UIButton(frame: CGRectMake(0, 0,12, 20))
        btn1.setBackgroundImage(UIImage(named: "7"), forState: UIControlState.Normal)
        btn1.addTarget(self, action: Selector("letfItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem = item2
    }
    func letfItemAction(send:UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK: 实现UICollectionViewDataSource UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArry.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        collectionView.registerNib(UINib(nibName:"workCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let cell:workCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! workCollectionCell
        
        cell.title.text = itemArry[indexPath.row] as? String
        cell.image.image = UIImage(named: imageArry[indexPath.row] as! String)
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(20,0,5, 0)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //某个Cell被选择的事件处理
        jumpPage(indexPath.row)
    }
    func jumpPage(index: Int)
    {
        if(index == 0)
        {
            //考勤审核
            titleStr = (itemArry[index] as? String)!
            self.performSegueWithIdentifier("push1", sender: self)
        }else if(index == 1)
        {
            //报销
            titleStr = (itemArry[index] as? String)!
            self.performSegueWithIdentifier("pushBaoXiao", sender: self)
            
        }else if(index == 2)
        {
            //盖章
            titleStr = (itemArry[index] as? String)!
            self.performSegueWithIdentifier("pushYongZhang", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let  channel:AuditPendingOrHasbeenViewController = segue.destinationViewController as! AuditPendingOrHasbeenViewController
        channel.title = titleStr
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
