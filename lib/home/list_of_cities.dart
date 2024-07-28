import 'dart:convert';

import 'package:flutter/material.dart';

import '../app_models/city_list_model.dart';
import '../components/global_variables.dart';
import 'package:http/http.dart' as http;

import 'city_sectors.dart';
class ListOfCities extends StatefulWidget {
  const ListOfCities({super.key});

  @override
  State<ListOfCities> createState() => _ListOfCitiesState();
}

class _ListOfCitiesState extends State<ListOfCities> {
  final imgUrl = 'https://travelapp.redstonz.com/project/public/assets/uploads/city-images/';
  TextEditingController searchController = TextEditingController();
  String search = '';

  Color getColorForFilteredAlphabets(alphabets) {
    if (searchController.text.isNotEmpty) {
      return Colors.indigo;
    }
    return Colors.black;
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
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'List of cities',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(
                  left: screenWidth * 0.02,
                  right: screenWidth * 0.02,
                  top: screenHeight * 0.02,
                  bottom: screenHeight * 0.02),
              height: screenHeight * 0.055,
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
                        return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black26,
                              strokeWidth: 3.0,
                            ));
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
                            late String cityPosition = city.city!;
                            late String countryPosition = city.country!;
                            if (searchController.text.isEmpty) {
                              return ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CitySectors(
                                                      cityId: city.id!,
                                                      name: city.city!,
                                                      description:
                                                      city.description!,
                                                      lat: city.lat!,
                                                      lng: city.lng!,
                                                    )));
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: screenHeight * 0.16,
                                            width: screenWidth * 0.33,
                                            child: ClipRRect(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Image.network(
                                                imgUrl + city.images![0],
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return Center(
                                                      child:
                                                      CircularProgressIndicator(
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
                                                errorBuilder: (context, error,
                                                    stackTrac) {
                                                  // Returns a widget if the picture is not found.
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white12,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
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
                                          SizedBox(
                                            width: screenWidth * 0.001,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: screenWidth * 0.03),
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
                                                      //city.images![0],
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
                                                        left: screenWidth *
                                                            0.013),
                                                    child: Text(
                                                      ///Path to the country name.
                                                      city.country!,
                                                      //city.images![0],
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
                                                    padding: EdgeInsets.only(
                                                        left:
                                                        screenWidth * 0.02,
                                                        right:
                                                        screenWidth * 0.02),
                                                    height: screenHeight * 0.1,
                                                    width: screenWidth * 0.52,
                                                    decoration: BoxDecoration(
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
                                                        )),
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
                            } else if (cityPosition.toLowerCase().contains(
                                searchController.text.toLowerCase()) ||
                                countryPosition.toLowerCase().contains(
                                    searchController.text.toLowerCase())) {
                              return ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: screenHeight * 0.02,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: screenHeight * 0.16,
                                            width: screenWidth * 0.33,
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
                                                              lng: city.lng!,
                                                              lat: city.lat!,
                                                            )));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                                child: Image.network(

                                                  // (city.images != null &&
                                                  //     city.images!
                                                  //         .isNotEmpty)
                                                  //     ? imgUrl +
                                                  //     jsonDecode(
                                                  //         city.images![0].toString())
                                                  //     : 'no data',

                                                  city.images![0],
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
                                          SizedBox(
                                            width: screenWidth * 0.001,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: screenWidth * 0.015),
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
                                                    padding:
                                                    const EdgeInsets.all(3),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        ///This show the result as cityName + CityName e.g: IndiaIndia
                                                          // text: city.city ??
                                                          //     'Country',
                                                          style: DefaultTextStyle
                                                              .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: cityPosition.toString(),
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
                                                        left: screenWidth *
                                                            0.001),
                                                    child: Text(
                                                      ///Path to the searched country name.
                                                      countryPosition,
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
                                                    height: screenHeight * 0.10,
                                                    width: screenWidth * 0.52,
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
                                                  ),
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
