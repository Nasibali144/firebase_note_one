import 'package:firebase_note_one/main.dart';
import 'package:firebase_note_one/models/post_model.dart';
import 'package:firebase_note_one/pages/detail_page.dart';
import 'package:firebase_note_one/services/auth_service.dart';
import 'package:firebase_note_one/services/db_service.dart';
import 'package:firebase_note_one/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const id = "/home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with RouteAware{
  bool isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    super.initState();
    _getAllPost();
  }

  void _getAllPost() async {
    isLoading = true;
    setState(() {});

    String userId = await DBService.loadUserId() ?? "null";
    items = await RTDBService.loadPosts(userId);

    isLoading = false;
    setState(() {});
  }

  void _logout() {
    AuthService.signOutUser(context);
  }

  void _openDetailPage() {
    Navigator.pushNamed(context, DetailPage.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyFirebaseApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    _getAllPost();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Post"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _itemOfList(items[index]);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openDetailPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemOfList(Post post) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      leading: SizedBox(
        height: 60,
        width: 60,
        child: post.image != null
            ? Image.network(post.image!, fit: BoxFit.cover,)
            : const Image(
          image: AssetImage("assets/images/placeholder.jpeg",),
          fit: BoxFit.cover,
        ),
      ),
      title: Text(post.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
      subtitle: Text(post.content, style: const TextStyle(fontSize: 18),),
    );
  }
}
