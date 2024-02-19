//
//  MovieDetailView.swift
//  MovieBox
//
//  Created by Uriel Castillo on 19/02/24.
//

import Foundation
import SwiftUI
import Combine

struct MovieDetailView: View {
    
    let movie: Movie
    let gridItems = [GridItem](repeating: GridItem(.flexible(), spacing: 10), count: 4)
    var cancellationToken: AnyCancellable?
    @StateObject private var viewModel = MovieDetailViewModel()

    var body: some View {
        
        VStack {
            let posterBaseURL = "https://image.tmdb.org/t/p/w500"

            if let posterPath = movie.poster_path, let url = URL(string: "\(posterBaseURL)\(posterPath)") {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 150, height: 200)
                .cornerRadius(8)
                .padding(.top, 20)
                .shadow(radius: 5)
            }
            
            Text(movie.title)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white)
                .font(.custom("megatron", size: 20))
            
            let movieReleaseDate = movie.release_date ?? ""
            Text(movieReleaseDate.movieFormat())
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 12))
            
            Text("Overview")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 16))
                .padding(.top,20)

            Text(movie.overview ?? "")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 16))
                .padding(.top, 1)
            
            Text("Genres")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 16))
                .padding(.top,20)
            
            ScrollView {
                LazyVGrid(columns: gridItems, alignment: .leading, spacing: 10) {
                    ForEach(viewModel.movieDetail?.genres ?? [], id: \.self) { category in
                        CategoryCell(category: category)
                    }
                }
            }
            
            if let url = URL(string: viewModel.movieDetail?.homepage ?? ""){ 
                Link("Visitar sitio oficial", destination: url)
                    .foregroundColor(.white.opacity(0.7))
            }

        }  .background(Color.black)
        
        .onAppear {
            viewModel.loadMovieDetail(movieId: String(movie.id))
        }
    }
    
}


#Preview {
    ContentView()
}

