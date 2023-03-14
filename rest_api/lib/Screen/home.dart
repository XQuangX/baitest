// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  Future<void> _refresh() async {
    return Future.delayed(const Duration(seconds: 3));
  }

  fetchmovie() async {
    // ignore: prefer_typing_uninitialized_variables
    var url;
    url = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=26763d7bf2e94098192e629eb975dab0&page=1'));
    return json.decode(url.body)['results'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191826),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xfff43370),
            )),
        title: const Text(
          'MOVIES',
          style: TextStyle(fontSize: 20.0, color: Color(0xfff43370)),
        ),
        elevation: 0.0,
        backgroundColor: const Color(0xff191826),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder(
            future: fetchmovie(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Container(
                          height: 250,
                          alignment: Alignment.centerLeft,
                          child: Card(
                            child: Image.network(
                                "https://image.tmdb.org/t/p/w500" +
                                    snapshot.data[index]['poster_path']),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  snapshot.data[index]["original_title"],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data[index]["release_date"],
                                  style:
                                      const TextStyle(color: Color(0xff868597)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: Text(
                                    snapshot.data[index]["overview"],
                                    style: const TextStyle(
                                        color: Color(0xff868597)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
