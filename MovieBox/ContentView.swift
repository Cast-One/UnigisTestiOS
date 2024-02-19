//
//  ContentView.swift
//  MovieBox
//
//  Created by Uriel Castillo on 19/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @State private var scrollIndex = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let posterBaseURL = "https://image.tmdb.org/t/p/w500"

    @State private var selectedMovie: Movie?
    @State private var showDetail: Bool = false
    
    @ViewBuilder
    private func movieRow(movie: Movie) -> some View {
       VStack(spacing: 0.0) {
           HStack {
               if let posterPath = movie.poster_path, let url = URL(string: "\(posterBaseURL)\(posterPath)") {
                   AsyncImage(url: url) { image in
                       image.resizable()
                   } placeholder: {
                       Color.gray
                   }
                   .frame(width: 50, height: 75)
               }
               
               VStack(alignment: .leading, spacing: 4) {
                   Text(movie.title)
                       .font(.headline)
                   
                   let movieReleaseDate = movie.release_date ?? ""
                   Text(movieReleaseDate.movieFormat())
                       .font(.subheadline)
                   
                   Text((movie.original_language ?? "").uppercased())
                       .font(.caption)
               }
               .foregroundColor(.white)
               
               Spacer()
               
               ZStack {
                   let rating = (movie.vote_average ?? 0.0) * 10

                  Circle()
                      .stroke(lineWidth: 6)
                      .opacity(0.3)
                      .foregroundColor(Color("GrayColorMB"))
                  
                  Circle()
                      .trim(from: 0.0, to: CGFloat(min(rating / 100, 1.0)))
                      .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                      .foregroundColor(rating > 50 ? .green : .yellow)
                      .rotationEffect(Angle(degrees: 270.0))
                  
                  Text("\(Int(rating))%")
                       .font(.system(size: 9))
                      .foregroundColor(.white.opacity(50))
              }
              .frame(width: 40, height: 40)
           }
           .padding()
           .background(.black)
           
           Rectangle()
                  .fill(Color("GrayColorMB"))
                  .frame(height: 1)
                  .edgesIgnoringSafeArea(.horizontal)
       }
   }
    
    var body: some View {
        VStack(spacing: 0.0) {
            
            Text("MOVIEBOX")
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color("DarkColorMB"))
                .foregroundColor(Color("YellowColorMB"))
                .font(.custom("megatron", size: 25))

            Text("Playing now")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                .padding(.leading, 10)
                .background(Color("GrayColorMB"))
                .foregroundColor(Color("YellowColorMB"))
                .font(.custom("megatron", size: 14))
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollView in
                    HStack(spacing: 10) {
                        ForEach(viewModel.nowPlayingMovies.indices, id: \.self) { index in
                            let movie = viewModel.nowPlayingMovies[index]
                            if let posterPath = movie.poster_path, let url = URL(string: "\(posterBaseURL)\(posterPath)") {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 100, height: 150)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                            }
                        }
                    }
                    .padding()
                    .onAppear {
                        viewModel.loadNowPlayingMovies()
                    }
                    .onReceive(timer) { _ in
                        withAnimation {
                            if !viewModel.nowPlayingMovies.isEmpty {
                                scrollIndex = (scrollIndex + 1) % viewModel.nowPlayingMovies.count
                                if viewModel.nowPlayingMovies.indices.contains(scrollIndex) {
                                    scrollView.scrollTo(scrollIndex, anchor: .center)
                                }
                            }
                        }
                    }

                }
            } .background(Color.black)
            
            Text("Most Popular")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                .padding(.leading, 10)  
                .background(Color("GrayColorMB"))
                .foregroundColor(Color("YellowColorMB"))
                .font(.custom("megatron", size: 14))

            List {
                ForEach(viewModel.popularMovies) { movie in
                    movieRow(movie: movie)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            self.selectedMovie = movie
                            self.showDetail = true
                        }
                }
                
                if viewModel.canLoadMorePages {
                    HStack {
                       // ProgressView()
                    }.onAppear {
                        viewModel.loadPopularMovies()
                    }
                }
            }
            .onAppear {
                if viewModel.popularMovies.isEmpty {
                    viewModel.loadPopularMovies()
                }
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $showDetail) {
                if let selectedMovie = selectedMovie {
                    MovieDetailView(movie: selectedMovie)
                }
            }
        }.background(Color.black)
    }
}

#Preview {
    ContentView()
}
