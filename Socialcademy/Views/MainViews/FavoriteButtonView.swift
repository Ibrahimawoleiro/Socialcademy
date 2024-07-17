//
//  FavoriteButtonView.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 3/3/24.
//

import SwiftUI

struct FavoriteButtonView: View {
    let isFavorite: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            if isFavorite {
                Label("Remove from Favorites", systemImage: "heart.fill")
            } else {
                Label("Add to Favorites", systemImage: "heart")
            }
        }
        .foregroundColor(isFavorite ? .red : .gray)
        .animation(.default, value: isFavorite)
    }
}

struct FavoriteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButtonView(isFavorite: true, action: {})
    }
}
