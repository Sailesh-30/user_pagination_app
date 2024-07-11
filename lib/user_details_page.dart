// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'apiService.dart';
import 'user.dart';


class UserDetailsPage extends StatefulWidget {
  final int userId;

  const UserDetailsPage({super.key, required this.userId});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _fetchUser();
  }

  Future<void> _fetchUser() async {
    _user = await ApiService.fetchUser(widget.userId);
    setState(() {
      _isLoading = false;
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Center(child: Column(
          children: [
            Text('User Details' , style: TextStyle(fontFamily: 'SFPro', fontSize: 18)),
            SizedBox(height: 10),
            Divider()
          ],
        )),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _animation,
              child: Container(
                height: null,
                decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.black, width: 2)),
                                            margin: EdgeInsets.only(top:10, left: 10, right: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(_user!.avatar),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Email: ${_user!.email}',
                        style: TextStyle(fontFamily: 'SFPro', fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Name: ${_user!.firstName + " " + _user!.lastName}',
                        style: TextStyle(fontFamily: 'SFPro', fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
