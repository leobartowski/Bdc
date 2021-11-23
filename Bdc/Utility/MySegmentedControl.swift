//
//  MySegmentedControl.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/11/21.
//

import Foundation
import UIKit

class MySegmentedControl: UISegmentedControl {
    
  //Needed to remove the greyish background
  override func layoutSubviews() {
    super.layoutSubviews()
      
    for i in 0...(numberOfSegments - 1)  {
      subviews[i].isHidden = true
    }
  }
}
