import 'package:ashesicom/common_widgets/customSearchBar.dart';
import 'package:ashesicom/views/homepage.dart';
import 'package:ashesicom/views/profile.dart';
import 'package:ashesicom/views/search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth.dart';
import 'login.dart';
import 'messages.dart';

class ScreenManager extends StatefulWidget {
  final Auth auth;


  const ScreenManager({Key? key, required this.auth}) : super(key: key);

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  TextEditingController _searchController = TextEditingController();
  late int _selectedIndex = 0;
  Widget _title = const Text("Home");
  bool _clickedProfile = false;
  // Icon _icon = const Icon(Icons.cancel);

  void _onItemTapped(int index) {
    setState(() {
      _clickedProfile = false;
      _selectedIndex = index;
    });
  }

  Widget _getProfile(){
    return const Profile(uid: "dreday", authID: "n",);
  }

  Widget _getPage(int index){
    switch (index) {
      case 0:
        _title = Image.asset(
          "assets/images/ashesicom.png",
          height: 100,
          fit: BoxFit.cover,
        );
        return HomePage(auth: widget.auth); // return the home page as a widget

      case 1:
        _title = CustomSearchBar(
            controller: _searchController,
            hint: "Search AshesiCom"
        );
        return const SearchScreen();// return the search page as a widget

      case 2:
        _title = const Text(
          "Messages",
          style: TextStyle(
              color: Colors.black
          ),
        );
        return Messages(auth: widget.auth,); // return the messages page as a widget

      case 3:
        _title = const Text(
          "",
          style: TextStyle(
              color: Colors.black
          ),
        );
        return Profile(authID: widget.auth.currentUser!.uid,uid: widget.auth.currentUser!.uid,); // return the profile page as a widget
    }

    _title = const Text("Page Not Found");
    return const Center(child: Text("There is no page builder for this index."),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: _clickedProfile == false ? null : Container(
        //   height: 80,
        //   child: FittedBox(
        //     child: FloatingActionButton(
        //       backgroundColor: const Color(0xFFD0BBC4),
        //       elevation: 0,
        //       onPressed: (){},
        //       child: const CircleAvatar(
        //         radius: 25,
        //         backgroundImage: AssetImage("assets/images/profile.jpeg"),
        //       ),
        //     ),
        //   ),),
        // floatingActionButtonLocation: _clickedProfile == false ? null : FloatingActionButtonLocation.startTop,
        body: _clickedProfile == false ? _getPage(_selectedIndex) : _getProfile(),
        appBar: _clickedProfile == false ? AppBar(
          backgroundColor: const Color(0xFFD0BBC4),
          elevation: 0,
          leading: _selectedIndex == 1 ? null : Container(
            margin: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _clickedProfile = true;
                });
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/profile.jpeg"),
              ),
            ),
          ),
          title: _title,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sign Out'),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'No'),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                var user = widget.auth.currentUser;
                                widget.auth.signOut();
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(
                                    builder: (context) => Login())
                                );
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                      context: context
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color:  Color(0xFFAF3A42),
                )
            )
          ],
        ) : null,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFD0BBC4),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Image.asset("assets/images/AshesiLogo.png"),
                label: "Home",
            ),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
                label: "Search"
            ),
            const BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.envelope,
                  size: 28,
                ),
                label: "Messages"
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFAF3A42),
          unselectedItemColor: const Color(0xFF808083),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onItemTapped,
        )
    );
  }

  AppBar _profileAppBar(){
    return AppBar(
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
              _clickedProfile = false;
            });
          },
        ),
      ),
    );
  }
}
