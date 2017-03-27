//
//  SBSliderView.swift
//  ImageSlider-Swift
//
//  Created by Vamshi Krishna on 24/03/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import UIKit

protocol SBSliderDelegate: NSObjectProtocol {
    func sbslider(_ sbslider: SBSliderView, didTapOn targetImage: UIImage, andParentView targetView: UIImageView)
}

class SBSliderView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var imagesArray = [Any]()
    var autoSrcollEnabled:Bool = false
    var activeTimer:Timer?

weak var _delegate:SBSliderDelegate?
weak var delegate: SBSliderDelegate?

    @IBOutlet var sliderMainScroller: UIScrollView!
    @IBOutlet weak var pageIndicator: UIPageControl!

func createSlider(withImages images: [Any], withAutoScroll isAutoScrollEnabled: Bool, in parentView: UIView) {
    self.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(UIScreen.main.bounds.size.height))
    imagesArray = images
    print(imagesArray)
    autoSrcollEnabled = isAutoScrollEnabled
    sliderMainScroller.isPagingEnabled = true
    sliderMainScroller.delegate = self
    pageIndicator.numberOfPages = imagesArray.count
    
    sliderMainScroller.contentSize = CGSize(width:CGFloat(UIScreen.main.bounds.size.width*3*(CGFloat(imagesArray.count))), height:CGFloat(sliderMainScroller.frame.size.height))
    var mainCount: Int = 0
    
    for _ in 0..<3 {
    
        for i in 0..<imagesArray.count {
            let imageV = UIImageView()
            var frameRect = CGRect.zero
            frameRect.origin.y = 0.0
            frameRect.size.width = UIScreen.main.bounds.size.width
            frameRect.size.height = sliderMainScroller.frame.size.height
            frameRect.origin.x = (frameRect.size.width * CGFloat(mainCount))
            imageV.frame = frameRect
            imageV.contentMode = .scaleAspectFill
            let imageName:String = "\(imagesArray [i])"
            imageV.image = UIImage(named:imageName)
            sliderMainScroller.addSubview(imageV)
            imageV.clipsToBounds = true
            imageV.isUserInteractionEnabled = true
            let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(self.tapOnImage))
            tapOnImage.delegate = self
            tapOnImage.numberOfTapsRequired = 1
            imageV.addGestureRecognizer(tapOnImage)
            mainCount += 1
        }
    }
    
    let startX = CGFloat(imagesArray.count) * UIScreen.main.bounds.size.width
    sliderMainScroller.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
    if (imagesArray.count > 1) && (isAutoScrollEnabled) {
        self.startTimerThread()
    }

}

func tapOnImage(gesture: UITapGestureRecognizer){
    let targetView: UIImageView? = (gesture.view as? UIImageView)
    _delegate?.sbslider(self , didTapOn: (targetView?.image)!, andParentView: targetView!)

}
    
//#pragma mark - UIScrollView delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width: CGFloat = scrollView.frame.size.width
        let page: Int = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        var moveToPage: Int = page
        if moveToPage == 0 {
            moveToPage = imagesArray.count
            let startX = CGFloat(moveToPage) * UIScreen.main.bounds.size.width
            scrollView.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
        }
        else if moveToPage == ((imagesArray.count * 3) - 1) {
            moveToPage = imagesArray.count - 1
            let startX = CGFloat(moveToPage) * UIScreen.main.bounds.size.width
            scrollView.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
        }
        
        if moveToPage < imagesArray.count {
            pageIndicator.currentPage = moveToPage
        }
        else {
            moveToPage = moveToPage % imagesArray.count
            pageIndicator.currentPage = moveToPage
        }
        if (imagesArray.count > 1) && (autoSrcollEnabled) {
            self.startTimerThread()
        }

    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let width: CGFloat = scrollView.frame.size.width
        let page: Int = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        var moveToPage: Int = page
        if moveToPage == 0 {
            moveToPage = imagesArray.count
            let startX = CGFloat(moveToPage) * UIScreen.main.bounds.size.width
            scrollView.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
        }
        else if moveToPage == ((imagesArray.count * 3) - 1) {
            moveToPage = imagesArray.count - 1
            let startX = CGFloat(moveToPage) * UIScreen.main.bounds.size.width
            scrollView.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
        }
        
        if moveToPage < imagesArray.count {
            pageIndicator.currentPage = moveToPage
        }
        else {
            moveToPage = moveToPage % imagesArray.count
            pageIndicator.currentPage = moveToPage
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if((activeTimer) != nil){
            activeTimer?.invalidate()
            activeTimer = nil
        }
    }
//pragma mark end
func slideImage(){

    var startX: CGFloat = 0.0
    let width: CGFloat = sliderMainScroller.frame.size.width
    let page: Int = Int((sliderMainScroller.contentOffset.x + (0.5 * width)) / width)
    let nextPage: Int = page + 1
    startX = CGFloat(nextPage) * width

    sliderMainScroller .setContentOffset(CGPoint(x:startX, y:0), animated: true)
}
    
func startTimerThread(){
    if((activeTimer) != nil){
        activeTimer?.invalidate()
        activeTimer = nil
    }
   
    activeTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.slideImage), userInfo: nil, repeats: true)

}
    
func startAutoPlay() {
    autoSrcollEnabled = true
    if(imagesArray .count > 1 && autoSrcollEnabled){
        self .startTimerThread()
    }
}

func stopAutoPlay() {
    autoSrcollEnabled =  false
    if((activeTimer) != nil){
        activeTimer?.invalidate()
        activeTimer = nil
    }
}
}
