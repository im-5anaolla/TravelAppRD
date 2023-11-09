import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InterestPoint extends StatelessWidget {
  const InterestPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Icon(Icons.arrow_back),
            SizedBox(width: 90,),
            Text('Add Location', style: TextStyle(
              fontSize: 20,
              fontFamily: 'SourceSans3',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40, right: 30, left: 30),
            child: const Text(
              'Add Image', style: TextStyle(
              fontSize: 16,
              fontFamily: 'SourceSans3',
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: Colors.black54

            ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 60,),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.image, size: 120, color: Colors.black12,),
                Icon(Icons.image, size: 120, color: Colors.black12,),
                Icon(Icons.image, size: 120, color: Colors.black12,),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200, right: 30, left: 30),
            child: const Column(
              children: [
                Text('Add Location Name', style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'SourceSans3',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 210, right: 30, left: 30),
            height: 50,
          width: 300,
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Location Name',
              ),
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,

              ),
              ),
          ),
          Container(
            margin: EdgeInsets.only(top: 300, right: 30, left: 30),
            child: const Column(
              children: [
                Text('Add Location Name', style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'SourceSans3',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 310, right: 30, left: 30),
            height: 50,
            width: 300,
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Add Location',
              ),
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,

              ),
            ),
          ),

          Center(
            child: Container(
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              margin: EdgeInsets.only(top: 450,),
              child: const Center(
                child: Text('Submit', style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'SourceSans3',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
              ),
            ),
          )


        ],
      ),

    );
  }
}
