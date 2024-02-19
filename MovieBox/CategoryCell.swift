//
//  CategoryCell.swift
//  MovieBox
//
//  Created by Uriel Castillo on 19/02/24.
//

import Foundation
import SwiftUI

struct CategoryCell: View {
    var category: Genre

    var body: some View {
        Text(String(category.name))
            .lineLimit(1)
            .padding(.all, 8)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
            .background(Color.white.opacity(0.7))
            .foregroundColor(.black)
            .cornerRadius(5)
            .minimumScaleFactor(0.5)

    }
}
