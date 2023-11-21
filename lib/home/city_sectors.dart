import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'city_details.dart';

class CitySectors extends StatefulWidget {
  final int cityId;
  final String name;
  final String description;

  const CitySectors({
    Key? key,
    required this.cityId,
    required this.name,
    required this.description,
  }) : super(key: key);

  @override
  State<CitySectors> createState() => _CitySectorsState();
}

class _CitySectorsState extends State<CitySectors> {
  final sectorImgs = 'https://travelapp.redstonz.com/assets/uploads/place/';

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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'City Sectors',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
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
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CityDetails(
                                            city: intPoint['name'],
                                            country: intPoint['city_name'],
                                            images: intPoint['images'],
                                            description: intPoint['detail'],
                                            id: intPoint['id'],
                                            voiceNote: intPoint['voice_note'],
                                          ),
                                        ),
                                      );
                                    },
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
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 0.6,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
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
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 3.0),
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
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 8.0),
                                          height: 80,
                                          width: 190,
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
