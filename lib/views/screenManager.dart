import 'dart:io';

import 'package:ashesicom/common_widgets/customSearchBar.dart';
import 'package:ashesicom/services/database.dart';
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

  // Loading screen
  Widget _currentPage = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(
        color: Color(0xFFAF3A42),
      ),
    ),
  );

  //Database variable
  late Database _db;
  String avi = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = Database(authID: widget.auth.currentUser!.uid);
    getProfileData();
  }

  // Get user profile data
  Future<void> getProfileData() async {
    Map<String, dynamic>? userInfo = await _db.getUserInfo(uid: widget.auth.currentUser!.uid);


    setState(() {
      avi = userInfo!['avi'];
      _currentPage = _getPage(_selectedIndex);
          // : Profile(uid: widget.auth.currentUser!.uid, authID: widget.auth.currentUser!.uid,);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _clickedProfile = false;
      _selectedIndex = index;
      _currentPage = _getPage(_selectedIndex);
    });
  }

  // Widget _getProfile(){
  //   print("beans");
  //   _currentPage = Profile(uid: widget.auth.currentUser!.uid, authID: widget.auth.currentUser!.uid,);
  //   return _currentPage;
  // }

  Widget _getPage(int index){
    switch (index) {
      case 0:
        _title = Image.asset(
          "assets/images/ashesicom.png",
          height: 70,
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

      // case 3:
      //   _title = const Text(
      //     "",
      //     style: TextStyle(
      //         color: Colors.black
      //     ),
      //   );
      //   return Profile(authID: widget.auth.currentUser!.uid,uid: widget.auth.currentUser!.uid,); // return the profile page as a widget
      }

    _title = const Text("Page Not Found");
    return const Center(child: Text("There is no page builder for this index."),);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentPage, // _clickedProfile == false ? _getPage(_selectedIndex) : _getProfile(),
        appBar: _clickedProfile == false ? AppBar(
          backgroundColor: const Color(0xFFD0BBC4),
          elevation: 0,
          leading: _selectedIndex == 1 ? null : Container(
            margin: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _clickedProfile = true;
                  _currentPage = Profile(authID: widget.auth.currentUser!.uid,uid: widget.auth.currentUser!.uid,);
                });
              },
              child: CircleAvatar(
                backgroundImage: avi == ""
                    ? const AssetImage("assets/images/AshLogo.jpg")
                    :Image.file(
                  File(avi),
                  fit: BoxFit.cover,
                ).image,
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

  // Widget _buildContent(){
  //   return Scaffold(
  //       body: _clickedProfile == false ? _getPage(_selectedIndex) : _getProfile(),
  //       appBar: _clickedProfile == false ? AppBar(
  //         backgroundColor: const Color(0xFFD0BBC4),
  //         elevation: 0,
  //         leading: _selectedIndex == 1 ? null : Container(
  //           margin: const EdgeInsets.all(10.0),
  //           child: GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 _clickedProfile = true;
  //               });
  //             },
  //             child: CircleAvatar(
  //               backgroundImage: avi == ""
  //                   ? const AssetImage("assets/images/AshLogo.jpg")
  //                   :Image.file(
  //                 File(avi),
  //                 fit: BoxFit.cover,
  //               ).image,
  //             ),
  //           ),
  //         ),
  //         title: _title,
  //         centerTitle: true,
  //         actions: [
  //           IconButton(
  //               onPressed: () {
  //                 showDialog(
  //                     builder: (BuildContext context) {
  //                       return AlertDialog(
  //                         title: const Text('Sign Out'),
  //                         content: const Text('Are you sure you want to sign out?'),
  //                         actions: <Widget>[
  //                           TextButton(
  //                             onPressed: () => Navigator.pop(context, 'No'),
  //                             child: const Text('No'),
  //                           ),
  //                           TextButton(
  //                             onPressed: () {
  //                               widget.auth.signOut();
  //                               Navigator.pushReplacement(
  //                                   context, MaterialPageRoute(
  //                                   builder: (context) => Login())
  //                               );
  //                             },
  //                             child: const Text('Yes'),
  //                           ),
  //                         ],
  //                       );
  //                     },
  //                     context: context
  //                 );
  //               },
  //               icon: const Icon(
  //                 Icons.logout,
  //                 color:  Color(0xFFAF3A42),
  //               )
  //           )
  //         ],
  //       ) : null,
  //       bottomNavigationBar: BottomNavigationBar(
  //         backgroundColor: const Color(0xFFD0BBC4),
  //         type: BottomNavigationBarType.fixed,
  //         items: [
  //           BottomNavigationBarItem(
  //             icon: Image.asset("assets/images/AshesiLogo.png"),
  //             label: "Home",
  //           ),
  //           const BottomNavigationBarItem(
  //               icon: Icon(
  //                 Icons.search,
  //                 size: 30,
  //               ),
  //               label: "Search"
  //           ),
  //           const BottomNavigationBarItem(
  //               icon: Icon(
  //                 FontAwesomeIcons.envelope,
  //                 size: 28,
  //               ),
  //               label: "Messages"
  //           ),
  //         ],
  //         currentIndex: _selectedIndex,
  //         selectedItemColor: const Color(0xFFAF3A42),
  //         unselectedItemColor: const Color(0xFF808083),
  //         showSelectedLabels: false,
  //         showUnselectedLabels: false,
  //         onTap: _onItemTapped,
  //       )
  //   );
  // }
}
