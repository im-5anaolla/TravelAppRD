import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travely/auth_pages/welcom_page.dart';
import 'package:travely/components/global_variables.dart';
import 'city_details.dart';

class CitySectors extends StatefulWidget {
  final int cityId;
  final String name;
  final String description;
  final String lat;
  final String lng;

  const CitySectors({
    Key? key,
    required this.cityId,
    required this.name,
    required this.description,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  State<CitySectors> createState() => _CitySectorsState();
}

class _CitySectorsState extends State<CitySectors> {
  final sectorImgs =
      'https://travelapp.redstonz.com/project/public/assets/uploads/place/';

  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://travelapp.redstonz.com/api/v1/point-of-intersts?city_id=${widget.cityId}'));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      print('City Sectors ID: ${widget.cityId}');
      // Check if "data" key exists and is a List
      if (decodedData.containsKey('data') && decodedData['data'] is List) {
        setState(() {
          data = List<Map<String, dynamic>>.from(decodedData['data']);
        });
      } else {
        print('Error: Invalid data format');
      }
    } else {
      print(
          'Error: Failed to load city sectors. Status code: ${response.statusCode}');
    }

    // Simulate a delay of 1 seconds to show CircularProgressIndicator
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'City Sectors',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black26,
                strokeWidth: 3.0,
              ),
            )
          : data.isNotEmpty
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> intPoint = data[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('Tapped');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CityDetails(
                                        name: intPoint['name'],
                                        images: intPoint['images'],
                                        city_name: intPoint['city_name'],
                                        detail: intPoint['detail'],
                                        //voice_note: intPoint['voice_note'],
                                        lng: intPoint['lng'],
                                        lat: intPoint['lat'],
                                        id: intPoint['id'],
                                        city_id: intPoint['city_id'],
                                      )));
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: screenHeight * 0.013),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.16,
                                    width: screenWidth * 0.333,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Image.network(
                                        sectorImgs + intPoint['images'][0],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.black12),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Image not found',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            // Image is fully loaded, display the image
                                            return child;
                                          } else {
                                            // Image is still loading, display a custom circular progress indicator
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.black26,
                                                strokeWidth: 3.0,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        (loadingProgress
                                                                .expectedTotalBytes ??
                                                            1)
                                                    : null,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.001,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.015),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(3),
                                            child: Text(
                                              intPoint['name'] ?? 'Country',
                                              style: const TextStyle(
                                                fontFamily: 'SourceSans3',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: screenWidth * 0.008),
                                            child: Text(
                                              intPoint['city_name'].toString(),
                                              style: const TextStyle(
                                                fontFamily: 'SourceSans3',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: screenWidth * 0.02,
                                                right: screenWidth * 0.04),
                                            height: screenHeight * 0.10,
                                            width: screenWidth * 0.52,
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              intPoint['detail'].toString(),
                                              maxLines: 4,
                                              style: const TextStyle(
                                                fontFamily: 'SourceSans3',
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'No data available.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
    );
  }
}
