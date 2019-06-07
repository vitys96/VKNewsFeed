

import UIKit

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}


protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?, isFillSizedPost: Bool) -> FeedCellSizes
}

final class FeddCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?, isFillSizedPost: Bool) -> FeedCellSizes {
        
        var showMoreTextButton = false
        
        let cardWidth = screenWidth - Constants.cardInsets.left - Constants.cardInsets.right
        
        //MARK: - Работа с postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top),
                                    size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            var height = text.height(width: width, font: Constants.postLabelFont)
            
            let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
            print ("limitHeight \(limitHeight)")
            
            if !isFillSizedPost && height > limitHeight {
                height = Constants.postLabelFont.lineHeight * Constants.minifiedPostLines
                print ("Height \(height)")
                showMoreTextButton = true
            }
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        // MARK: Работа с moreTextButtonFrame
        
        var moreTextButtonSize = CGSize.zero
        
        if showMoreTextButton {
            moreTextButtonSize = Constants.moreTextButtonSize
        }
        
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        //MARK: - Работа с attachmentFrame
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : moreTextButtonFrame.maxY + Constants.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                     size: CGSize.zero)
        
        if let attach = photoAttachment {
            let photoHeight = Float(attach.height)
            let photoWidth = Float(attach.width)
            
            let ratio = CGFloat(photoHeight / photoWidth)
            attachmentFrame.size = CGSize(width: cardWidth, height: cardWidth * ratio)
        }
        
        //MARK: - Работа с bottomViewFrame
        
       let buttonViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: buttonViewTop),
                                    size: CGSize(width: cardWidth, height: Constants.bottonViewHeight))
        
        
       let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom
        
        return Sizes(postLabelFrame: postLabelFrame,
                     moreTextButtonFrame: moreTextButtonFrame,
                     attachmentFrame: attachmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
