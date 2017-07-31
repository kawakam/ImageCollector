//
//  CollectionView.swift
//  ImageGetter
//
//  Created by 川上智樹 on 2015/10/29.
//  Copyright © 2015年 yatuhasiumai. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(UINib(nibName: "ImageCellCollectionViewCell", bundle: nil), forCellReuseIdentifier: "")
        
        self.estimatedRowHeight = 83
        self.rowHeight = UITableViewAutomaticDimension
    }

    
}
