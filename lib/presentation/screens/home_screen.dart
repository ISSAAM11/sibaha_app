import 'package:flutter/material.dart';
import 'package:sibaha_app/presentation/widgets/home/home_main_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: HomeMainWidget(scaffoldKey: _scaffoldKey),
      drawer: Drawer(
        elevation: 0,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            spacing: 10,
            children: [
              const Spacer(flex: 1),
              const Text('Your city',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onTap: () {},
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
