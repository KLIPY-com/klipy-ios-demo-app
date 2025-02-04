//
//  DisableCustomControls+AVPlayer.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 04.02.25.
//

import UIKit
import AVKit

extension AVPlayerViewController {
  override open func viewDidLoad() {
    super.viewDidLoad()
    self.showsPlaybackControls = false
  }
}
