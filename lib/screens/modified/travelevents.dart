import 'package:flutter/material.dart';
import 'package:mobi_div/screens/modified/map_test.dart';
import '../../models/finalTracker.dart';

class TravelEvents extends StatefulWidget {
  final List<Days> tripDaysList;
  final String uuid;
  TravelEvents({super.key, required this.uuid,required this.tripDaysList});

  @override
  State<TravelEvents> createState() => _TravelEventsState();
}

class _TravelEventsState extends State<TravelEvents> {

  Widget tripModel(String position, String date, String tripCount){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.list, size: 22,),
          Text("Day: $position", textAlign: TextAlign.start, style: TextStyle(fontSize: 16, fontFamily: 'NotoSans')),
          Text(date, textAlign: TextAlign.start, style: TextStyle(fontSize: 16, fontFamily: 'NotoSans')),
          Text("$tripCount Trips", textAlign: TextAlign.start, style: TextStyle(fontSize: 16, fontFamily: 'NotoSans'),),
          Icon(Icons.mode_edit_outline_rounded, size: 20,),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.amber[100],
          iconTheme: IconThemeData(
            color: Colors.black
          ),
        title: Text("My Trips", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24, fontFamily: 'NotoSans'),),
        actions: [

        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: Column(
          children: [
            Text("Select to view Your trips from below", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200, fontFamily: 'NotoSans')),

            Flexible(
              child: widget.tripDaysList.isNotEmpty ? ListView.builder(
                  itemCount: widget.tripDaysList.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) => MapScreen(date: widget.tripDaysList[index].date)));
                      },
                      child: Padding(
                          padding: EdgeInsets.all(3),
                        child: tripModel(
                            "${index + 1}",
                            widget.tripDaysList[index].date,
                           "${widget.tripDaysList[index].storyline_count}"
                        )
                      ),
                    );
              }): Center(
                child: Text("No data available at the moment")
              ),
            ),
          ],
        ),
      ),
    );
  }
}
