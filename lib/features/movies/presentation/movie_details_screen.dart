import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_cataloug/features/movies/data/movie_repository_impl.dart';
import 'package:movie_cataloug/features/movies/data/movie_remote_data_source.dart';
import 'package:movie_cataloug/features/movies/domain/movie.dart';
import 'package:movie_cataloug/l10n/app_localizations.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  /// Use const constructor and add key parameter for better performance
  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {

  final MovieRepositoryImpl repo = MovieRepositoryImpl(MovieRemoteDataSource());
  Future<Movie?>? movieFuture;

  @override
  void initState() {
    super.initState();
    movieFuture = repo.getMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Make body go behind app bar for immersive effect
      appBar: AppBar(
        /// use localisation instead of hardcoded string
        title: Text(AppLocalizations.of(context)!.details), // Hardcoded string
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26, 
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Movie?>(
        future: movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: const Color(0xFFE50914)));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Error fetching details", style: TextStyle(color: Colors.white)));
          }

          final movie = snapshot.data!;
          /// wrap column into a SingleChildScrollView to avoid the overflow
          return SingleChildScrollView(
           child: Column(
            children: [

              Container(
                height: 500, // Very tall header
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        movie.posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF151925), // Matches scaffold background
                            ],
                            stops: [0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black, blurRadius: 10)]
                            ),
                          ),
                          SizedBox(height: 10),
                           Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 24),
                              SizedBox(width: 5),
                              Text(
                                "${movie.voteAverage.toStringAsFixed(1)}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.movieText,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.storyLine, style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10),
                     Text(
                      movie.overview, 
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 16),
                    ),
                    SizedBox(height: 30),

                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF1E2330),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.castPlaceholder, style: TextStyle(color: Colors.white54)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
         );
        },
      ),
    );
  }
}
