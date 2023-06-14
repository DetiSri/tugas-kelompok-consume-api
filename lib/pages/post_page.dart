import 'package:flutter/material.dart';
import 'package:itg_consume_api/controllers/post_controller.dart';
import 'package:itg_consume_api/models/comment.dart' as c;
import '../models/album.dart';
import '../models/photo.dart';
import '../models/post.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.post});
  final Post post;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    final PostController postController = PostController();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Post"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              SizedBox(
                width: size.width,
                child: Text(
                  widget.post.body,
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const SizedBox(height: 20),
              const Text(
                "Album",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Expanded(
                child: FutureBuilder<List<Album>>(
                  future: postController.fetchAlbums(widget.post.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        List<Album> albums = snapshot.data!;
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(albums[index].title),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: albums.length,
                        );
                      } else {
                        return const Text("Belum ada album");
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const Text("Err");
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Photo",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Expanded(
                child: FutureBuilder<List<Photo>>(
                  future: postController.fetchPhotos(widget.post.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        List<Photo> photos = snapshot.data!;
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(photos[index].title),
                                subtitle:
                                    Image.network(photos[index].thumbnailUrl),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: photos.length,
                        );
                      } else {
                        return const Text("Belum ada komentar");
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const Text("Err");
                    }
                  },
                ),
              ),
              const Text(
                "Komentar",
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Expanded(
                child: FutureBuilder<List<c.Comment>>(
                  future: postController.fetchComments(widget.post.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        List<c.Comment> comments = snapshot.data!;
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(comments[index].name),
                                subtitle: Text(comments[index].body),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: size.height * 0.0005,
                            );
                          },
                          itemCount: comments.length,
                        );
                      } else {
                        return const Text(
                          "Belum ada komentar",
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return AspectRatio(
                          aspectRatio: 1 / 1,
                          child: SizedBox(
                            width: size.width * 0.2,
                            height: size.width * 0.2,
                            child: const CircularProgressIndicator(),
                          ));
                    } else {
                      return const Text("err");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
