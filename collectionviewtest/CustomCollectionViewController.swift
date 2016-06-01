//
//  CustomCollectionViewController.swift
//  collectionviewtest
//
//  Created by Steven_WATREMEZ on 31/05/16.
//  Copyright © 2016 Steven_WATREMEZ. All rights reserved.
//

import UIKit
import Foundation

private let reuseIdentifier = "Cell"

class CustomCollectionViewController: UICollectionViewController {
  
  // MARK: properties
  private let dataSource = DataSource()
  
  // MARK: overide methods
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  override func viewDidLoad() {
      super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  // MARK: UICollectionViewDataSource
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      return dataSource.numberOfGroups()
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return dataSource.numbeOfRowsInEachGroup(section)
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SwiftCollectionViewCell
    // Configure the cell
    let languages = dataSource.fruitsInGroup(indexPath.section)
    let language = languages[indexPath.row]
    if let icon = language.icon,
          name = language.name,
          description = language.description {
      cell.imageView.image = UIImage(named: icon)
      cell.name.text = name
      cell.desc.text = description
    }
    return cell
  }
  
  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let headerView =
        collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                              withReuseIdentifier: "HeaderView",
                                                              forIndexPath: indexPath) as! LangageHeaderViewCell
      headerView.title.text = dataSource.gettGroupLabelAtIndex(indexPath.section)
      return headerView
    default:
      assert(false, "Unexpected element kind")
    }
  }

  // MARK: UICollectionViewDelegate

  /*
  // Uncomment this method to specify if the specified item should be highlighted during tracking
  override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      return true
  }
  */

  /*
  // Uncomment this method to specify if the specified item should be selected
  override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      return true
  }
  */

  /*
  // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
  override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      return false
  }

  override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
      return false
  }

  override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
  
  }
  */

}

class Language {
  var icon: String?
  var group:String?
  var name:String?
  var description: String?
  
  init(icon: String, group: String, name: String, description: String ) {
    self.icon = icon
    self.group = group
    self.name = name
    self.description = description
  }
}

class DataSource {
  
  init() {
    populateData()
  }
  
  var languages:[Language] = []
  var groups:[String] = []
  
  func numbeOfRowsInEachGroup(index: Int) -> Int {
    return fruitsInGroup(index).count
  }
  
  func numberOfGroups() -> Int {
    return groups.count
  }
  
  func gettGroupLabelAtIndex(index: Int) -> String {
    return groups[index]
  }
  
  // MARK:- Populate Data from plist
  func populateData() {
    if let path = NSBundle.mainBundle().pathForResource("languages", ofType: "plist") {
      if let dictArray = NSArray(contentsOfFile: path) {
        for item in dictArray {
          if let dict = item as? NSDictionary {
            let icon = dict["icon"] as! String
            let name = dict["name"] as! String
            let group = dict["group"] as! String
            let description = dict["description"] as! String
            
            let fruit = Language(icon: icon, group: group, name: name, description: description)
            if !groups.contains(group) {
              groups.append(group)
            }
            languages.append(fruit)
          }
        }
      }
    }
  }
  
  // MARK:- FruitsForEachGroup
  func fruitsInGroup(index: Int) -> [Language] {
    let item = groups[index]
    let filteredFruits = languages.filter { (language: Language) -> Bool in
      return language.group == item
    }
    return filteredFruits
  }
}


