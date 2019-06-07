

import UIKit

protocol NewsfeedPresentationLogic {
    func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    weak var viewController: NewsfeedDisplayLogic?
    
    var cellLayoutCalc: FeedCellLayoutCalculatorProtocol = FeddCellLayoutCalculator()
    
    
    lazy var dateFormatrer: DateFormatter = {
        let dateForm = DateFormatter()
        dateForm.locale = Locale(identifier: "ru_RU")
        dateForm.dateFormat = "d MMM 'в' HH:mm"
        
        return dateForm
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        
        switch response {
        case .presentNewsfeed(let feed, let revealedPostIds):
            
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPostIds: revealedPostIds)
            }
            let feedViewModel = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let photoAttachment = self.photoAttchament(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateItem = dateFormatrer.string(from: date)
        
        let isFullSized = revealedPostIds.contains { (postId) -> Bool in
            return postId == feedItem.postId
        }
        
        let sizes = cellLayoutCalc.sizes(postText: feedItem.text, photoAttachment: photoAttachment, isFillSizedPost: isFullSized)
        
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconUrlString: profile.photo,
                                         name: profile.name,
                                         date: dateItem,
                                         text: feedItem.text,
                                         likes: String(feedItem.likes?.count ?? 0),
                                         comments: String(feedItem.comments?.count ?? 0),
                                         shares: String(feedItem.reposts?.count ?? 0),
                                         views: String(feedItem.views?.count ?? 0),
                                         photoAttachment: photoAttachment,
                                         sizes: sizes)
        
    }
    
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresenatable {
        
        let profilesOrGroups: [ProfileRepresenatable] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresenatable = profilesOrGroups.first { (myProfileRepresenatable) -> Bool in
            myProfileRepresenatable.id == normalSourseId
        }
        return profileRepresenatable!
    }
    
    private func photoAttchament(feedItem: FeedItem) -> FeedViewModel.FeddCellPhotoAttachment? {
        
        guard let photos = feedItem.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return FeedViewModel.FeddCellPhotoAttachment(photoUrlString: firstPhoto.srcBig,
                                                     width: firstPhoto.width,
                                                     height: firstPhoto.height)
    }
}
