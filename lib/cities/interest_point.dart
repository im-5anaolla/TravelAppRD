import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travely/components/global_variables.dart';

class InterestPoint extends StatelessWidget {
  const InterestPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            SizedBox(
              width: screenWidth * 0.25,
            ),
            const Text(
              'Add Location',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'SourceSans3',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: screenHeight * 0.02,
                  right: screenWidth * 0.03,
                  left: screenWidth * 0.055),
              child: const Text(
                'Add Image',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SourceSans3',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: Colors.black54),
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.image,
                  size: 120,
                  color: Colors.black12,
                ),
                Icon(
                  Icons.image,
                  size: 120,
                  color: Colors.black12,
                ),
                Icon(
                  Icons.image,
                  size: 120,
                  color: Colors.black12,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.06,
                      right: screenWidth * 0.03,
                      left: screenWidth * 0.05),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Location Name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontFamily: 'SourceSans3',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: screenHeight * 0.02,
                              right: screenWidth * 0.02,
                              left: screenWidth * 0.02),
                          height: screenHeight * 0.04,
                          width: screenWidth,
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
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        const Text(
                          'Add Location Name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontFamily: 'SourceSans3',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: screenHeight * 0.02,
                              right: screenWidth * 0.02,
                              left: screenWidth * 0.02),
                          height: screenHeight * 0.04,
                          width: screenWidth,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                margin: EdgeInsets.only(
                  top: screenHeight * 0.2,
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04,
                ),
                child: const Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SourceSans3',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
