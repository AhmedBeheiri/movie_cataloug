import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/movies/data/movie_remote_data_source.dart';
import 'features/movies/data/movie_repository_impl.dart';
import 'features/movies/domain/get_trending_movies.dart';
import 'features/movies/domain/movie_repository.dart';
import 'features/movies/presentation/movie_controller.dart';
import 'features/movies/presentation/movie_details_screen.dart';
import 'features/movies/presentation/movies_list_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Inject all dependencies through constructor for proper DI
    return MultiProvider(
      providers: [
        Provider<MovieRepository>(
          create: (_) => MovieRepositoryImpl(MovieRemoteDataSource()),
        ),
        ChangeNotifierProxyProvider<MovieRepository, MovieController>(
          create: (context) => MovieController(
            GetTrendingMovies(context.read<MovieRepository>()),
          ),
          update: (context, repo, previous) => previous ?? MovieController(GetTrendingMovies(repo)),
        ),
      ],
      child: MaterialApp(
        /// needed for i10n
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Movie Catalog',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        /// routes for screens
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => const MoviesListScreen(),
              );
            case '/details':
              final movieId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(
                  movieId: movieId,
                  repository: context.read<MovieRepository>(),
                ),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const MoviesListScreen(),
              );
          }
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData.dark();

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF151925), // Deep dark blue/grey
      primaryColor: const Color(0xFFE50914), // Netflix Red-ish
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFFE50914),
        secondary: const Color(0xFFDB0000),
        surface: const Color(0xFF1E2330),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[400],
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF151925),
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFE50914),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
