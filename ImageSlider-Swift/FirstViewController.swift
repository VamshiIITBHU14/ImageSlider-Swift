//
//  FirstViewController.swift
//  ImageSlider-Swift
//
//  Created by Vamshi Krishna on 24/03/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import UIKit
let _AUTO_SCROLL_ENABLED:Bool = false

class FirstViewController: UIViewController, SBSliderDelegate {
    @IBOutlet var autoPlayToggle: UISwitch!
    @IBOutlet var sampleImageView: UIImageView!
    var imagesArray = [Any]()
    var slider : SBSliderView?

    override func viewDidLoad() {
        super.viewDidLoad()

        imagesArray = ["Black-Car-HD-Wallpaper.jpg", "lamborghini_murcielago_superveloce_2-2880x1800.jpg", "nature-landscape-photography-lanscape-cool-hd-wallpapers-fullscreen-high-resolution.jpg", "wallpaper-hd-3151.jpg"]
        autoPlayToggle.isOn = _AUTO_SCROLL_ENABLED
        slider = Bundle.main.loadNibNamed("SBSliderView", owner: self, options: nil)?.first as! SBSliderView?
        slider?.delegate = self
        self.view.addSubview(slider!)
        slider?.createSlider(withImages: imagesArray, withAutoScroll: _AUTO_SCROLL_ENABLED, in: self.view)
        slider?.frame = CGRect(x: CGFloat(0), y: CGFloat(100), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(300.0))
    }


    func sbslider(_ sbslider: SBSliderView, didTapOn targetImage: UIImage, andParentView targetView: UIImageView) {
        let photoViewerManager = SBPhotoManager()
        photoViewerManager.initializePhotoViewer(fromViewControlller: self, forTargetImageView: targetView, withPosition: sbslider.frame)
    }
    
 
    @IBAction func tappedOnSampleImage(_ sender: Any) {
        let gesture: UIGestureRecognizer? = (sender as? UIGestureRecognizer)
        let targetView: UIImageView? = (gesture?.view as? UIImageView)
        let photoViewerManager = SBPhotoManager()
        photoViewerManager.initializePhotoViewer(fromViewControlller: self, forTargetImageView: targetView!, withPosition: (targetView?.frame)!)

    }
    @IBAction func toggleAutoPlay(_ sender: Any) {
        let toggleSwitch: UISwitch? = (sender as? UISwitch)
        if (toggleSwitch?.isOn)! {
            slider?.startAutoPlay()
        }
        else {
            slider?.stopAutoPlay()
        }
    }

}
