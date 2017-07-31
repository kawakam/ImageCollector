//
//  CustomCell.swift
//  ImageGetter
//
//  Created by 川上智樹 on 2015/11/04.
//  Copyright © 2015年 yatuhasiumai. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    let cellImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.awakeFromNib()
        cellImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        cellImageView.clipsToBounds = true
        cellImageView.contentMode = UIViewContentMode.scaleAspectFit
        cellImageView.backgroundColor = UIColor(red: 211 / 255, green: 249 / 255, blue: 255 / 255, alpha: 1.0)
        
        self.addSubview(cellImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 元からあるもののときのやつ
    //    override func awakeFromNib() {
    //        print("customcell init")
    //        super.awakeFromNib()
    //        cellImageView.frame = CGRectMake(0, 0, 60, 60)
    //        self.addSubview(cellImageView)
    //    }
    
}
