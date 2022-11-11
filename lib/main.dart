import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rest_api/data/api_provider.dart';
import 'package:rest_api/model/popular_movies.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var api = ApiProvider();
  late Future<PupularMovies> popular;

  @override
  void initState() {
    popular = api.getMovies();
    super.initState();
    // ignore: todo
    // TODO: implement initState
  }
  
  @override
  Widget build(BuildContext context) {
    String imageBaseUrl = "https://image.tmdb.org/t/p/w500/";
    return Scaffold(
        appBar: AppBar(
          title: const Text("Movie DB"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: popular,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.results.length,
                itemBuilder: (context, index) {
                  return moviesItem(
                    poster:
                        "$imageBaseUrl${snapshot.data?.results[index].posterPath}",
                    title: "${snapshot.data?.results[index].title}",
                    date: "${snapshot.data?.results[index].releaseDate}",
                    voteAverage: "${snapshot.data?.results[index].voteAverage}",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MovieDetail(
                          movie: snapshot.data!.results[index],
                        ),
                      ));
                    },
                  );
                },
              );
            }
            return Text("ok");
          },
        ));
  }
}

Widget moviesItem(
    {required String poster,
    required String title,
    required String date,
    required String voteAverage,
    required Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      child: Card(
        child: Container(
          child: Row(
            children: [
              Container(
                width: 120,
                child: CachedNetworkImage(imageUrl: poster),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Container(
                child: Column(
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(date)
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 12,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(voteAverage)
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    ),
  );
}

class MovieDetail extends StatelessWidget {
  final Result movie;

  const MovieDetail({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Center(
        child: Text(movie.overview),
      ),
    );
  }
}
