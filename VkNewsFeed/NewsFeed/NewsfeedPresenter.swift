//
//  NewsfeedPresenter.swift
//  VkNewsFeed
//
//  Created by vladislavpanev on 23.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
  func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    weak var viewController: NewsfeedDisplayLogic?
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsfeed(let feed):
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups)
            }
            let feedViewModel = FeedViewModel.init(cells:cells)
            viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
        
        let profileRepresentable = profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        let photoAttechment = self.photoAttechment(feedItem: feedItem)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        
        return FeedViewModel.Cell.init(iconUrlString: profileRepresentable.photo, name: profileRepresentable.name, date: dateTitle, text: feedItem.text, likes: String(feedItem.likes?.count ?? 0), comments: String(feedItem.comments?.count ?? 0), shares: String(feedItem.reposts?.count ?? 0), views: String(feedItem.views?.count ?? 0), photoAttechment: photoAttechment)
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { (profileRepresentable) in
            profileRepresentable.id == normalSourceId
        }
        return profileRepresentable!
    }
    
    private func photoAttechment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttechment? {
        guard let photos = feedItem.attachments?.compactMap({ (attechment) in
            attechment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return FeedViewModel.FeedCellPhotoAttechment.init(photoUrlString: firstPhoto.src, width: firstPhoto.width, height: firstPhoto.heigh)
    }
}
