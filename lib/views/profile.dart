import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../widgetGenerators/posts.dart';

class Profile extends StatefulWidget {
  final String id;

  const Profile({Key? key, required this.id}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        flexibleSpace: const Image(
          image: AssetImage("assets/images/profile.jpeg"),
          fit: BoxFit.cover,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: IconButton(
            icon: const CircleAvatar(
                backgroundColor: Color(0xFFAF3A42),
                radius: 15,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                  ),
                )),
            onPressed: () {
              setState(() {
                Navigator.of(context).pop();
              });
            },
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 80,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFD0BBC4),
            elevation: 0,
            onPressed: (){},
            child: const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/images/profile.jpeg"),
            ),
          ),
        ),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Dreday",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          ),
                        ),
                        Text(
                          "@beans",
                          style: TextStyle(
                            color: Color(0xFF808083),
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      child: const Text(
                        "Edit Button",
                        style: TextStyle(
                          color: Color(0xFFAF3A42)
                        ),
                      ),
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color(0xFFD0BBC4)
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Color(0xFFAF3A42)
                            )
                          )
                        ),
                      ),
                     ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 8.0),
            child: Text(
              "Digital Goodies Team - Web & Mobile UI/UX development; Graphics; Illustrations",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 8.0),
            child: Row(
              children: const [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Color(0xFF808083),
                ),
                SizedBox(width: 3,),
                Text(
                  "Joined September 2018",
                  style: TextStyle(
                    color: Color(0xFF808083)
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      "217",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 3.0,),
                    Text(
                      "Following",
                      style: TextStyle(
                        color: Color(0xFF808083)
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 5,),
                Row(
                  children: const [
                    Text(
                      "118",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(width: 3.0,),
                    Text(
                      "Followers",
                      style: TextStyle(
                        color: Color(0xFF808083)
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFFAF3A42),
                  labelColor: const Color(0xFFAF3A42),
                  unselectedLabelColor: const Color(0xFF808083),
                  tabs: const [
                    Tab(
                      child: Text(
                        "Post",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),

                    ),
                    Tab(
                      child: Text(
                        "Reposts",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Media",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Likes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 403.2,
                    width: MediaQuery.of(context).size.width -2,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                      Container(
                        child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return posts[index];
                          },
                          separatorBuilder: (BuildContext context, int index) => Divider(
                            height: 0,
                          ),
                          itemCount: posts.length,
                        ),
                      ),
                        Text("Second"),
                        Text("Third"),
                        Text("Fourth")
                      ]
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
