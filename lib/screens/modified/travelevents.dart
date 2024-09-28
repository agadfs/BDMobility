import 'package:flutter/material.dart';
import 'package:mobi_div/main.dart';

class TravelEvents extends StatefulWidget {
  const TravelEvents({super.key});

  @override
  State<TravelEvents> createState() => _TravelEventsState();
}

class _TravelEventsState extends State<TravelEvents> {

  Widget tripModel(String position, String date, String tripCount){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Icon(Icons.list),
          Text(position),
          Text(date),
          Text(tripCount),
          Icon(Icons.edit_rounded),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black
            ),
            child: Row(
              children: [
                Text("My trips", style: TextStyle(color: Colors.white, fontSize: 24),),
                Icon(Icons.close_rounded)
              ],
            ),
          )
        ],
      ),
    );
  }
}
