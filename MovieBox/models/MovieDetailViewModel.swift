//
//  MovieDetailViewModel.swift
//  MovieBox
//
//  Created by Uriel Castillo on 19/02/24.
//

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    var cancellationToken: AnyCancellable?

    func loadMovieDetail(movieId: String) {
        let apiKey = "55957fcf3ba81b137f8fc01ac5a31fb5"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(apiKey)&language=en-US"
        
        print(urlString)
        guard let url = URL(string: urlString) else { return }

        cancellationToken = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MovieDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription) 
                }
            }, receiveValue: { [weak self] movieDetail in
                self?.movieDetail = movieDetail
            })
    }
}
