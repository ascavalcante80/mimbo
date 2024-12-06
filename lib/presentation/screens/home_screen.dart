// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mimbo/logic/cubits/page_controller_cubit.dart';

import '../../data/constants.dart';
import '../../data/models/users.dart';
import '../../logic/cubits/user_cubit.dart';
import '../widget/widgets.dart';
import 'create_project_screen.dart';

class HomeScreen extends StatefulWidget {
  // TODO place holder for home screen
  static const String routeName = '/home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int currentPageIndex = 0;

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = <Widget>[
    const LabRoom(),
    const FeedScreen(),
    const ProfileScreen(),
    const CreateProjectScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: BlocBuilder<PageControllerCubit, PageControllerState>(
          builder: (context, state) {
        return pages[state.currentPageIndex];
      }),
      bottomNavigationBar: NavigationBar(
        elevation: 10,
        height: 45,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          BlocProvider.of<PageControllerCubit>(context)
              .updateCurrentPageIndex(index);
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

class LabRoom extends StatefulWidget {
  const LabRoom({super.key});

  @override
  State<LabRoom> createState() => _LabRoomState();
}

class _LabRoomState extends State<LabRoom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Welcome to the Lab Room'),
        Text('🧪'),
        TextButton(
            onPressed: () {
              log('Create Project');
              BlocProvider.of<PageControllerCubit>(context)
                  .updateCurrentPageIndex(3);
            },
            child: const Text('Create Profile')),
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
