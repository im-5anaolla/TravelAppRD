import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travely/home/city_sectors.dart';
import '../app_models/city_list_model.dart';

class CityListScreen extends StatefulWidget {
  @override
  _CityListScreenState createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  final imgUrl = 'https://travelapp.redstonz.com/assets/uploads/city-images/';
  TextEditingController searchController = TextEditingController();
  String search = '';

  Color getColorForFilteredAlphabets(alphabets) {
    for (int i = 0; i < searchController.text.length; i++) {
      if (searchController.text[i].isNotEmpty) {
        return Colors.blue;
      }
    }
    return Colors.black;
  }

  List<TextSpan> getAlphabetsColor(String text) {
    List<TextSpan> filteredAlphabets = [];

    for (int i = 0; i < searchController.text.length; i++) {
      filteredAlphabets.add(TextSpan(
          text: searchController.text[i],
          style: TextStyle(
            color: getColorForFilteredAlphabets(searchController.text[i]),
          )));
    }
    return filteredAlphabets; //This list (filteredAlphabets) return search alphabets.
  }

  Future<CityListModel?> fetchCityList() async {
    final response = await http
        .get(Uri.parse('https://travelapp.redstonz.com/api/v1/cities'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CityListModel.fromJson(data);
    } else {
      throw Exception('Failed to load city data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('City List', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              height: 50,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    search = value.toString();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.maxFinite,
              child: Stack(
                children: [
                  FutureBuilder<CityListModel?>(
                    future: fetchCityList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('No data available.');
                      } else {
                        // Display the city data using snapshot.data
                        final cityList = snapshot.data!;
                        return ListView.builder(
                          itemCount: cityList.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final city = cityList.data![index];
                            //Store city and country name to compare with the text in searchController.
                            late String position = city.city!;
                            if (searchController.text.isEmpty) {
                              return ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CitySectors(
                                                              cityId: city.id!,
                                                              name: city.city!,
                                                              description: city
                                                                  .description!,
                                                            )));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                  imgUrl + city.images![0],
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrac) {
                                                    //Returns text widget if picture not found.
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white12,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12),
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
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade50,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: Text(
                                                      city.city ?? 'Country',
                                                      //Path to the city name.
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'SourceSans3',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 0, left: 3.0),
                                                    child: Text(
                                                      ///Path to the country name.
                                                      city.country! ??
                                                          'Country',
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'SourceSans3',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0,
                                                            right: 8.0),
                                                    height: 80,
                                                    width: 190,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white12,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      city.description
                                                          .toString(),
                                                      //Path to the cityDescription
                                                      maxLines: 4,
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'SourceSans3',
                                                        fontSize: 14,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                            } else if (position.toLowerCase().contains(
                                searchController.text.toLowerCase())) {
                              return ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CitySectors(
                                                              cityId: city.id!,
                                                              name: city.city!,
                                                              description: city
                                                                  .description!,
                                                            )));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                  imgUrl + city.images![0],
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrac) {
                                                    //Returns text widget if picture not found.
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white12,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12),
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
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade50,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: RichText(
                                                      text: TextSpan(
                                                          //text: city.city ?? 'Country',
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: position
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: getColorForFilteredAlphabets(
                                                                      searchController
                                                                          .text),
                                                                ))
                                                          ]),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 0, left: 3.0),
                                                    child: Text(
                                                      ///Path to the country name.
                                                      city.country! ??
                                                          'Country',
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'SourceSans3',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0,
                                                            right: 8.0),
                                                    height: 80,
                                                    width: 190,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white12,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      city.description
                                                          .toString(),
                                                      //Path to the cityDescription
                                                      maxLines: 4,
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'SourceSans3',
                                                        fontSize: 14,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                            } else {
                              return Container();
                            }
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
