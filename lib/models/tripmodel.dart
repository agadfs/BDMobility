import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class DraggableContent extends StatefulWidget {
  DraggableContent({super.key, required this.tripDate});
  String tripDate;

  @override
  State<DraggableContent> createState() => _DraggableContentState();
}

class _DraggableContentState extends State<DraggableContent> {

  showTrackTile(List trackData, ScrollController controller){
      return ListView.builder(
        itemCount: trackData.length,
        controller: controller,
        itemBuilder: (BuildContext context, int index){
          final track = trackData[index];
          return Card(
             child: ListTile(
               leading: Image.network("https://d2vu7cvwtoyfwb.cloudfront.net/assets/modes/airplane-8818b880af28617d8222d43ce1c6d5c09e935cbfed60097d595dd841a7fed46e.png"),
               title: Column(
                 children: [
                   Text("Plane"),
                   Text("start time"),
                 ],
               ),
               trailing: Column(
                 children: [
                   Text("Distance"),
                   Text("Travel time"),
                 ],
               ),
             ),
          );
        },
      );
  }

  String tracks = "tracks", time="time", distance="distance";
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.chevron_left, size: 14,),
              Text(tracks, style: TextStyle(fontSize: 12),),
              Text(time, style: TextStyle(fontSize: 12)),
              Text(distance, style: TextStyle(fontSize: 12)),
              Icon(Icons.chevron_right, size: 14,)
            ],
          ),
        ],
      ),
    );
  }
}


