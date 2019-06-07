

import UIKit

struct FeedResponseWrapped: Decodable {
    var response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Group]
}

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachments]?
}

struct Attachments: Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    
    let sizes: [PhotoSizes]
    
    var height: Int {
        return getProperSize().height
    }
    
    var width: Int {
        return getProperSize().width
    }
    
    var srcBig: String {
        return getProperSize().url
    }
    
    private func getProperSize() -> PhotoSizes {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fullSize = sizes.last {
            return fullSize
        } else {
            return PhotoSizes(type: "Wrong Image", url: "Wrong Image", width: 0, height: 0)
        }
    }
}

struct PhotoSizes: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

struct CountableItem: Decodable {
    let count: Int
}

protocol ProfileRepresenatable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct Profile: Decodable, ProfileRepresenatable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String { return firstName + " " + lastName }
    var photo: String { return photo100 }
}

struct Group: Decodable, ProfileRepresenatable {
    let id: Int
    let name: String
    let photo100: String
    
    var photo: String { return photo100 }
}
