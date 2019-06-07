

import UIKit

protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        switch request {
            
        case .getNewsfeed:
            fetcher.getFeed { [weak self] (feedResponse) in
                guard let self = self else { return }
                
                self.feedResponse = feedResponse
                self.presenterFeed()
                
            }
        case .revealPostIds(let postId):
            revealedPostIds.append(postId)
            
            presenterFeed()
        }
    }
    
    private func presenterFeed() {
        guard let feedResponse = feedResponse else { return }
        self.presenter?.presentData(response: .presentNewsfeed(feed: feedResponse, revealedPostIds: revealedPostIds))
    }
}
