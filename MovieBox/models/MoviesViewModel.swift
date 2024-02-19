//
//  MoviesViewModel.swift
//  MovieBox
//
//  Created by Uriel Castillo on 19/02/24.
//

import Foundation

class MoviesViewModel: ObservableObject {
    @Published var nowPlayingMovies = [Movie]()
    @Published var popularMovies = [Movie]()
    
    var currentPage = 1
    var canLoadMorePages = true

    func loadNowPlayingMovies() {
        let nowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=1"
        loadMovies(from: nowPlayingURL) { movies in
            self.nowPlayingMovies = movies
        }
    }

    func loadPopularMovies() {
        guard canLoadMorePages else { return }

        let popularURL = "https://api.themoviedb.org/3/movie/popular?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=\(currentPage)"

        guard let url = URL(string: popularURL) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Error fetching popular movies: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let decodedResponse = try? JSONDecoder().decode(MovieResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.popularMovies += decodedResponse.results
                    if decodedResponse.results.isEmpty {
                        self.canLoadMorePages = false
                    } else {
                        self.currentPage += 1
                    }
                }
            }
        }
        task.resume()
    }

    private func loadMovies(from urlString: String, completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let decodedResponse = try? JSONDecoder().decode(MovieResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(decodedResponse.results)
                }
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}
