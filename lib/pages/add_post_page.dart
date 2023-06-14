import 'package:flutter/material.dart';
import 'package:itg_consume_api/controllers/post_controller.dart';
import 'package:itg_consume_api/models/post.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({
    super.key,
    this.post,
  });
  final Post? post;

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final PostController postController = PostController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController bodyController;

  @override
  void initState() {
    titleController = TextEditingController();
    bodyController = TextEditingController();

    if (widget.post != null) {
      titleController.text = widget.post!.title;
      bodyController.text = widget.post!.body;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post != null ? "Edit Berita" : "Tambah Berita"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: "title",
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Judul harus diisi";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      controller: bodyController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: "body",
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Body harus diisi";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            child: TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Post post = Post(
                    userId: widget.post != null ? widget.post!.userId : 1,
                    id: widget.post != null ? widget.post!.id : 1,
                    title: titleController.text,
                    body: bodyController.text,
                  );
                  if (widget.post != null) {
                    postController.patch(post).then((res) {
                      if (res) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Post edited"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to edit post"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    });
                  } else {
                    postController.create(post).then((res) {
                      if (res) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Post added"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to add post"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text(widget.post != null ? "Edit" : "Tambah"),
            ),
          )
        ],
      ),
    );
  }
}
