import 'package:flutter/material.dart';
import 'package:movie_cataloug/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'movie_controller.dart';
import 'movie_details_screen.dart';

class MoviesListScreen extends StatefulWidget {

  /// Use const constructor and add key parameter for better performance
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {

  @override
  void initState() {
    super.initState();
    //MovieController().fetchMovies(); // context is not needed in fetch and not stored in controller

    /// Provider manages instance lifecycle properly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieController>().fetchMovies();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.trendingNow),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: Consumer<MovieController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator(color: const Color(0xFFE50914)));
          }

          /// Avoid expensive wrap operations by using ListView.builder only instead of wrapping
          /// the entire list in SingleChildScrollView with Column for better performance

          // return SingleChildScrollView(
          //   physics: BouncingScrollPhysics(),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          //          child: Text("Top Picks for You", style: Theme.of(context).textTheme.titleLarge),
          //       ),
              return ListView.builder(
                // shrinkWrap: true, // Expensive
                physics: BouncingScrollPhysics(),
                itemCount: controller.movies.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Text(AppLocalizations.of(context)!.topPicksForYou, style: Theme.of(context).textTheme.titleLarge),
                    );
                  }

                  final movie = controller.movies[index - 1];
                    return GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movieId: movie.id),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        height: 250, // Fixed height
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            )
                          ],
                          image: DecorationImage(
                            image: NetworkImage(movie.posterUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.9),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        "${movie.voteAverage.toStringAsFixed(1)} / 10",
                                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    movie.overview,
                                    style: TextStyle(color: Colors.white60, fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
              );
          },
        ),
      );
    }
  }
