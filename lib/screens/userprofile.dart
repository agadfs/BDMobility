import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60.0,
              backgroundImage: NetworkImage(
                'https://img.freepik.com/free-photo/androgynous-avatar-non-binary-queer-person_23-2151100228.jpg?t=st=1707192411~exp=1707196011~hmac=7321ebf663a2d87ad8a9486d87ceeba9f261d44196a5615556c32d65679ffa68&w=1060', // Replace with the user's profile image URL
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            const Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                try {
                  //Get User details

                }catch(e){
                  print("error occured: $e");
                }
              },
              child: const Text('Edit Profile', style: TextStyle(fontSize: 14),),
            ),
            const SizedBox(height: 8.0),
            const Card(
              elevation: 4.0,
              child: ListTile(
                title: Text('Bio'),
                subtitle: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Card(
              elevation: 4.0,
              child: ListTile(
                title: Text('Location'),
                subtitle: Text('City, Country'),
              ),
            ),
            const SizedBox(height: 16.0),
            const Card(
              elevation: 4.0,
              child: ListTile(
                title: Text('Joined Date'),
                subtitle: Text('January 1, 2022'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}