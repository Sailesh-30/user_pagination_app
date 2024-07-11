// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'user.dart';
import 'user_details_page.dart';


class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ScrollController _scrollController = ScrollController();
  List<User> _users = [];
  bool _isLoading = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchUsers(_currentPage);
    _scrollController.addListener(_scrollListener);
  }



  void  fetchUsers(int page ) async {
    var userlist = [];
    var response = await get(Uri.parse(
        'https://reqres.in/api/users?page=$page'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userdata = data['data'];
      print(userdata);
      setState(() {
        _currentPage = data['page'];
      });
      for (var user in userdata) {
        userlist.add(user);
      }
      _users.clear();
      for (var users in userlist) {
        setState(() {
          // ignore: non_constant_identifier_names
          User UserModel = User(
              id: users['id'],
              email: users['email'],
              firstName: users['first_name'],
              lastName: users['last_name'],
              avatar: users['avatar']);
          _users.add(UserModel);
        });
      }
      print(_users);

    } 
    else{
      print("error");
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      fetchUsers(_currentPage);
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Center(child: Column(
          children: [
            Text('Paginated User List', style: TextStyle(fontFamily: 'SFPro', fontSize: 20)),
            SizedBox(height: 10),
            Divider(),
          ],
        )),
      ),
      body: Column(
        children: [
          if(_users.isNotEmpty)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _users.length,
              itemBuilder: (context, index) {
                if (index == _users.length) {
                  return _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }
                return Container(
                   decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.black, width: 2)),
                                            margin: EdgeInsets.only(top:10, left: 10, right: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_users[index].avatar),
                    ),
                    title: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Email : " + _users[index].email, style: TextStyle(fontFamily: 'SFPro', fontSize: 18))),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Name :" + _users[index].firstName + " " + _users[index].lastName , style: TextStyle(fontFamily: 'SFPro', fontSize: 18)),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(userId: _users[index].id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if(_users.isEmpty)
          const Center(child: Text("No Data Found", style: TextStyle(fontFamily: 'SFPro', fontSize: 20))),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, size: 100,),
                  onPressed: () {
                    if (_currentPage > 1){
                      fetchUsers(_currentPage - 1);
                    }
                  },
                  color: _currentPage > 1 ? Colors.blue : Colors.grey,
                ),
                Text('Page $_currentPage', style: TextStyle(fontFamily: 'SFPro', fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.arrow_right, size: 100),
                  onPressed: () {
                    if(_users.isNotEmpty){
                      fetchUsers( _currentPage + 1);
                    }
                  },
                  color: _users.isNotEmpty ? Colors.blue : Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
