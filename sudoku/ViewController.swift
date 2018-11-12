//
//  ViewController.swift
//  sudoku
//
//  Created by Jeff Wang on 2018/11/3.
//  Copyright © 2018年 Jeff Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var sudokuData:[Int] = [0,0,0,3,0,7,0,9,2,
                            7,0,3,0,1,0,0,0,0,
                            8,0,2,0,0,9,4,7,0,
                            4,0,0,0,9,8,0,6,0,
                            0,0,1,0,5,0,0,4,8,
                            5,6,0,0,0,2,3,0,0,
                            0,7,6,8,0,5,0,0,4,
                            0,8,0,0,0,0,6,0,0,
                            2,0,0,7,3,0,5,0,1]
    
    var possibleArray:[[Int]] = []
    var originData:[Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let size:CGFloat = 20
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: size, height: size)
        layout.minimumLineSpacing = size
        layout.sectionInset = UIEdgeInsets.init(top: size, left: size, bottom: size, right: size)
        
        self.collectionView.collectionViewLayout = layout
        
        for i in 0...80 {
            possibleArray.append([1,2,3,4,5,6,7,8,9])
        }
        
        originData = sudokuData
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 9;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        var title:UITextField?
        if let view = cell.viewWithTag(888) {
            title = view as! UITextField
        } else {
            title = UITextField(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            title!.tag = 888
            cell.contentView.addSubview(title!)
        }
        if (sudokuData[indexPath.row + indexPath.section * 9] == 0) {
            title!.text = "."
        } else {
            title!.text = String(sudokuData[indexPath.row + indexPath.section * 9])
        }
        
        if (originData![indexPath.row + indexPath.section * 9] == 0 && title!.text != ".") {
            title?.textColor = .red
        }
        
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func evaluate(_ sender: UIButton) {
        for i in 0...80 {
            if (sudokuData[i] == 0) {
                updatePossible(index: i)
            }
        }
        collectionView.reloadData()
    }
    
    func updatePossible(index:Int) {
        if (sudokuData[index] != 0) {
            return
        }
        
        let row = index / 9
        let column = index % 9
        let section:IndexPath = IndexPath(row: row / 3, section: column / 3)
        
        
        var updated = false;
        
        updated = updateRowPossible(row: row, index: index) || updated
        updated = updateColumnPossible(column: column, index: index) || updated
        updated = updateSectionPossible(section: section, index: index) || updated
        
        print(possibleArray[index], index)
        
        if(updated && possibleArray[index].count == 1) {
            sudokuData[index] = possibleArray[index][0]
            
            updateRows(row)
            updateColumns(column)
            updateSections(section)
        }
    }
    
    func updateRows(_ row:Int) {
        for i in 0...8 {
            updatePossible(index: row * 9 + i)
        }
    }
    
    func updateColumns(_ column:Int) {
        for i in 0...8 {
            updatePossible(index: column + i * 9)
        }
    }
    
    func updateSections(_ section:IndexPath) {
        let row = section.row * 3
        let colunm = section.section * 3
        updatePossible(index: colunm * 9 + row)
        updatePossible(index: colunm * 9 + row + 1)
        updatePossible(index: colunm * 9 + row + 2)
        updatePossible(index: (colunm + 1) * 9 + row)
        updatePossible(index: (colunm + 1) + row + 1)
        updatePossible(index: (colunm + 1) + row + 2)
        updatePossible(index: (colunm + 2) * 9 + row)
        updatePossible(index: (colunm + 2) + row + 1)
        updatePossible(index: (colunm + 2) + row + 2)
    }
    
    func updateRowPossible(row:Int, index:Int) -> Bool {
        var dataChanged = false;
        
        for i in 0...8 {
            if let arrayIndex = possibleArray[index].index(of: sudokuData[row * 9 + i]) {
                possibleArray[index].remove(at:arrayIndex)
                dataChanged = true
            }
        }
        
        return dataChanged
    }
    
    func updateColumnPossible(column:Int, index:Int) -> Bool {
        var dataChanged = false;
        
        for i in 0...8 {
            if let arrayIndex = possibleArray[index].index(of: sudokuData[i * 9 + column]) {
                possibleArray[index].remove(at: arrayIndex)
                dataChanged = true
            }
        }
        
        return dataChanged
    }
    
    func updateSectionPossible(section:IndexPath, index:Int) -> Bool {
        var dataChanged = false;
        
        let row = section.row * 3
        let column = section.section * 3
        for i in 0...2 {
            for j in 0...2 {
                let sudokuIndex = ((row + i) * 9) + (column + j)
                if let arrayIndex = possibleArray[index].index(of: sudokuData[sudokuIndex]) {
                    possibleArray[index].remove(at: arrayIndex)
                    dataChanged = true
                }
            }
        }
        
        return dataChanged
    }
}

