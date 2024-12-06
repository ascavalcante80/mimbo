// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/constants.dart';
import '../../data/models/users.dart';
import '../../logic/cubits/user_cubit.dart';
import '../widget/widgets.dart';


class HomeScreen extends StatefulWidget {
  // TODO place holder for home screen
  static const String routeName = '/home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  List<Widget> pages = <Widget>[
    const LabRoom(),
    const FeedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        elevation: 10,
        height: 45,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.transparent,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Container(
                alignment: Alignment.bottomCenter,
                child: Icon(Icons.home, color: Colors.amber)),
            icon: Container(
                alignment: Alignment.bottomCenter,
                child: Icon(Icons.home_outlined)),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                '🔥',
                style: TextStyle(fontSize: 22),
              ),
            ),
            icon: Container(
                alignment: Alignment.bottomCenter,
                child: Icon(FontAwesomeIcons.fireFlameCurved)),
            label: 'Feed',
          ),
          NavigationDestination(
            selectedIcon: Container(
                alignment: Alignment.bottomCenter,
                child: Icon(Icons.account_box, color: Colors.amber)),
            icon: Container(
                alignment: Alignment.bottomCenter,
                child: Icon(Icons.account_box_outlined)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          Text('Welcome to the Feed Screen'),
          Text('🔥'),
        ],
      ),
    );
  }
}

class LabRoom extends StatelessWidget {
  const LabRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Welcome to the Lab Room'),
        Text('🧪'),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Welcome to the Profile Screen'),
        UsernameDisplay('hello, ', ' !'),
        ElevatedButton(
            onPressed: () {
              MimUser mimUser = MimUser(
                  id: 'fa',
                  username: 'newusername',
                  name: 'toto',
                  projectIds: ['project_id'],
                  createdAt: DateTime.now(),
                  birthdate: DateTime.now(),
                  gender: UserGender.notBinary);
              BlocProvider.of<MimUserCubit>(context).updateUser(mimUser);
            },
            child: Text('change username')),
        Text('👤'),
      ],
    );
  }
}
