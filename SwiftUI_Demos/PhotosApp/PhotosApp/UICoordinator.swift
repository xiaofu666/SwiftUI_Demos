//
//  UICoordinator.swift
//  PhotosApp
//
//  Created by Lurich on 2024/5/12.
//

import SwiftUI

@Observable
class UICoordinator {
    var items: [Item] = sampleItems.compactMap({
        Item(title: $0.title, image: $0.image, previewImage: $0.image)
    })
    var selectedItem: Item?
    var animateView: Bool = false
    var showDetailView: Bool = false
    var detailScrollPosition: String?
    var detailIndicatorPosition: String?
    var offset: CGSize = .zero
    var dragProgress: CGFloat = 0
    
    func didDetailPageChanged() {
        if let updateItem = items.first(where: { $0.id == detailScrollPosition }) {
            selectedItem = updateItem
            withAnimation(.easeInOut(duration: 0.1)) {
                detailIndicatorPosition = updateItem.id
            }
        }
    }
    func didDetailIndicatorPageChanged() {
        if let updateItem = items.first(where: { $0.id == detailIndicatorPosition }) {
            selectedItem = updateItem
            withAnimation(.easeInOut(duration: 0.1)) {
                detailScrollPosition = updateItem.id
            }
        }
    }
    
    func toggleView(show: Bool) {
        if show {
            detailScrollPosition = selectedItem?.id
            detailIndicatorPosition = selectedItem?.id
            withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.showDetailView = true
            }
        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
                animateView = false
                offset = .zero
            } completion: {
                self.resetAnimationProperties()
            }
        }
    }
    
    func resetAnimationProperties() {
        detailIndicatorPosition = nil
        detailScrollPosition = nil
        selectedItem = nil
        offset = .zero
        dragProgress = 0
    }
}
