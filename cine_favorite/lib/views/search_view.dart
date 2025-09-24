import 'package:flutter/material.dart';
import 'package:cine_favorite/services/tmdb_service.dart';
import 'package:cine_favorite/controllers/movie_firestore_controller.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  final _firestoreController = MovieFirestoreController();

  Future<void> _searchMovie() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    final movies = await TmdbService.searchMovie(query);
    setState(() {
      _results = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)], // azul degrade
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text("Buscar Filme"),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        hintText: "Digite o nome do filme",
                        hintStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _searchMovie,
                    icon: const Icon(Icons.search, color: Colors.white),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final movie = _results[index];
                  return Card(
                    color: Colors.white10,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: movie["poster_path"] != null
                          ? Image.network(
                              "https://image.tmdb.org/t/p/w92${movie["poster_path"]}")
                          : const Icon(Icons.movie, color: Colors.white),
                      title: Text(
                        movie["title"],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "ID: ${movie["id"]}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.star_border,
                            color: Colors.yellow),
                        onPressed: () =>
                            _firestoreController.addFavoriteMovie(movie),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
