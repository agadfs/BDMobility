

import 'package:flutter/material.dart';

class DraggableBottomSheet extends StatefulWidget {
  @override
  _DraggableBottomSheetState createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {
  double _sheetPosition = 0.0;
  double _minSheetPosition = 0.25;
  double _maxSheetPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _sheetPosition -= details.primaryDelta! / (MediaQuery.of(context).size.height/2.0);
          _sheetPosition = _sheetPosition.clamp(_minSheetPosition, _maxSheetPosition);
        });
      },
      onVerticalDragEnd: (details) {
        if (_sheetPosition < (_maxSheetPosition - _minSheetPosition) / 2) {
          // Collapse the sheet
          setState(() {
            _sheetPosition = _minSheetPosition;
          });
        } else {
          // Expand the sheet
          setState(() {
            _sheetPosition = _maxSheetPosition;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: MediaQuery.of(context).size.height * (_maxSheetPosition - _sheetPosition),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40.0,
              alignment: Alignment.center,
              child: Icon(Icons.drag_handle),
            ),
            Expanded(
              child: Center(
                child: Text('Bottom Sheet Content'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}