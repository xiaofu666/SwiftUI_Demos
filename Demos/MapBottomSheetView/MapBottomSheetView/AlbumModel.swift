//
//  AlbumModel.swift
//  MapBottomSheetView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct AlbumModel: Identifiable {
    var id = UUID().uuidString
    var albumName: String
    var albumImage: String
    var isLike: Bool = false
}

@available(iOS 15.0, *)
struct AlbumData {
    var albums: [AlbumModel] = [
        AlbumModel(albumName: "Positions", albumImage: "user1"),
        AlbumModel(albumName: "The Best", albumImage: "user2", isLike: true),
        AlbumModel(albumName: "My Everything", albumImage: "user3"),
        AlbumModel(albumName: "Your Turly", albumImage: "user4"),
        AlbumModel(albumName: "Sweetener", albumImage: "user5", isLike: true),
        AlbumModel(albumName: "Rain On Me", albumImage: "user6"),
        AlbumModel(albumName: "Struck With U", albumImage: "user3"),
        AlbumModel(albumName: "Seven Things", albumImage: "user5", isLike: true),
        AlbumModel(albumName: "Bang Bang", albumImage: "user4"),
        AlbumModel(albumName: "Your Turly", albumImage: "user4"),
        AlbumModel(albumName: "Sweetener", albumImage: "user5", isLike: true),
        AlbumModel(albumName: "Rain On Me", albumImage: "user6"),
        AlbumModel(albumName: "Struck With U", albumImage: "user3"),
        AlbumModel(albumName: "Seven Things", albumImage: "user5", isLike: true),
        AlbumModel(albumName: "Bang Bang", albumImage: "user4"),
    ]

    func getAlbumIndex(album: AlbumModel) -> Int {
        
        return albums.firstIndex { currentAlbum in
            return album.id == currentAlbum.id
        } ?? 0
    }

    @ViewBuilder
    func SongsList() -> some View {
        VStack(spacing: 25) {
            ForEach(albums) { albumModel in
                HStack(spacing: 12) {
                    Text("#\(getAlbumIndex(album:albumModel) + 1)")
                        .fontWeight(.semibold)
                    
                    Image(albumModel.albumImage)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    VStack(alignment: .leading) {
                        Text(albumModel.albumName)
                            .fontWeight(.semibold)
                        
                        Label {
                            Text("123456789")
                        } icon: {
                            Image(systemName: "beats.headphones")
                        }
                        .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        //
                    } label: {
                        Image(systemName: albumModel.isLike ? "suit.heart.fill" : "suit.heart")
                            .font(.title3 )
                            .foregroundColor(albumModel.isLike ? .red : .primary)
                    }

                    Button {
                        //
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }

                }
                .swipeActions {
                    Button {
                        print("trush")
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        print("add")
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .tint(.green)
                }
            }
        }
        .background(content: {
            Rectangle()
                .fill(Color.clear)
        })
        .padding(.top, 15)
        .edgesIgnoringSafeArea(.bottom)
    }

}
