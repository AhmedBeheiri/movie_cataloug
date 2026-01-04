# Movie Catalog App - Code Fixes

## movie_remote_data_source.dart
/// api key and base url moved to constants.dart
```dart
Future<List<MovieModel>> getTrendingMovies() async {
  try {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/trending/movie/week?api_key=${Constants.apiKey}'),
    );
  }
}
```

## movie_repository_impl.dart
/// Prevents creating Movie domain objects with empty or null
```dart
@override
Future<List<Movie>> getTrendingMovies() async {
  final models = await dataSource.getTrendingMovies();
  return models
      .where((m) => m.id != 0 && m.title.isNotEmpty)
      .map((m) => Movie(model: m))
      .toList();
}
```

/// Validate model has data before creating Movie
```dart
@override
Future<Movie?> getMovieDetails(int id) async {
  final model = await dataSource.getMovieDetails(id);
  if (model == null) return null;
  if (model.id == 0 || model.title.isEmpty) return null;
  return Movie(model: model);
}
```

## main.dart
/// Provider manages lifecycle - creates and disposes controller
/// Inject all dependencies through constructor for proper DI
```dart
return ChangeNotifierProvider(
  create: (_) => MovieController(
    GetTrendingMovies(
      MovieRepositoryImpl(MovieRemoteDataSource()),
    ),
  ),
  child: MaterialApp(...)
);
```

/// needed for i10n
```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  ...
)
```

## movies_list_screen.dart
/// Use const constructor and add key parameter for better performance
```dart
class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});
}
```

/// Provider manages instance lifecycle properly
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<MovieController>().fetchMovies();
  });
}
```

/// Avoid expensive wrap operations by using ListView.builder only instead of wrapping the entire list in SingleChildScrollView with Column for better performance
```dart
return ListView.builder(
  physics: BouncingScrollPhysics(),
  itemCount: controller.movies.length + 1,
  itemBuilder: (context, index) {
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Text(AppLocalizations.of(context)!.topPicksForYou, 
                    style: Theme.of(context).textTheme.titleLarge),
      );
    }
    final movie = controller.movies[index - 1];
    // ... movie card
  },
);
```

## movie_details_screen.dart
/// Use const constructor and add key parameter for better performance
```dart
class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });
}
```

/// use localisation instead of hardcoded string
```dart
AppBar(
  title: Text(AppLocalizations.of(context)!.details),
)
```

/// wrap column into a SingleChildScrollView to avoid the overflow
```dart
return SingleChildScrollView(
  child: Column(
    children: [
      // ... content
    ],
  )
);
```

## movie_controller.dart
/// Remove singleton pattern - inject dependencies in constructor
```dart
class MovieController extends ChangeNotifier {
  final GetTrendingMovies _getTrendingMovies;

  MovieController(this._getTrendingMovies);
}
```

/// context shall be passed and not stored in a variable to avoid memory leaks
```dart
// Removed: BuildContext? context;
// Removed: void setContext(BuildContext c) { context = c; }
```

/// fake delay is bad for performance
```dart
Future<void> fetchMovies() async {
  isLoading = true;
  notifyListeners();

  try {
    // Removed: await Future.delayed(Duration(seconds: 2));
    movies = await _getTrendingMovies();
  }
}
```

/// Clear movies list on error
```dart
try {
  movies = await _getTrendingMovies();
} catch (e) {
  movies = [];
  print(e);
}
```

/// Clean up resources before disposal
/// Clear list to free memory references
```dart
@override
void dispose() {
  movies.clear();
  super.dispose();
}
```