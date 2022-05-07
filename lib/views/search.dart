import 'package:flutter/material.dart';
import '../common_widgets/customSearchBar.dart';
import '../services/database.dart';

class SearchScreen extends StatefulWidget {
  final String authID;

  const SearchScreen({Key? key, required this.authID}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List posts;
  late Database db;
  TextEditingController _searchController = TextEditingController();

  final Widget _loading = const Center(
    child: CircularProgressIndicator(
      color: Color(0xFFAF3A42),
    ),
  );

  Widget _currentPage = Container();

  generatePosts(searchValue) async {
    // Generate posts from searched value
    posts = await db.getSearchResults(searchValue: searchValue);

    if (posts.isEmpty){
      setState(() {
        _currentPage = const Center(
          child: Text("No Results"),
        );
      });
    }
    else{
      setState(() {
        _currentPage = listOfPost();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = Database(authID: widget.authID);
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //       child: _currentPage
  //   );
  // }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0BBC4),
        elevation: 0,
        title: Container(
          height: 30,
          child: TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              setState(() {
                _currentPage = _loading;

                setState(() {
                  generatePosts(_searchController.text);
                });

              });

            },
            controller: _searchController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                contentPadding: const EdgeInsets.all(5),
                hintStyle: const TextStyle(color: Color(0xFF808083)),
                hintText: "Search AshesiCom",
                fillColor: const Color(0xFFD397A3),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty ? null : IconButton(
                  color: const Color(0xFF808083),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                  iconSize: 20,
                  padding: const EdgeInsets.only(bottom: 1.0),
                )
            ),
          ),
        ),
      ),
      body: _currentPage,
    );
  }

  // Widget _buildContent() {
  //   return Scaffold(
  //     body: listOfPost(),
  //   );
  // }

  Widget listOfPost() {
    return Container(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return posts[index];
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 0,
        ),
        itemCount: posts.length,
      ),
    );
  }
}
