//
//  MovieModel.swift
//  MovieBox
//
//  Created by Uriel Castillo on 19/02/24.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let poster_path: String?
    let vote_average: Double?
    let original_language: String?
    let release_date: String?
    let overview: String?
    let genre_ids: [Int]
}

struct MovieDetail: Codable {
    let title: String
    let genres: [Genre]
    let homepage: String?
}

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}
