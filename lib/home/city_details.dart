import 'package:flutter/material.dart';

class CityDetails extends StatefulWidget {
  final country;
  final city;
  final images;
  final description;

  const CityDetails(
      {super.key,
      required this.country,
      required this.city,
      required this.images,
      required this.description});

  @override
  State<CityDetails> createState() => _CityDetailsState();
}

const imgUrl = 'https://travelapp.redstonz.com/assets/uploads/city-images/';

class _CityDetailsState extends State<CityDetails> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Details'),
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              imgUrl + widget.images![0],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrac){
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
                  child:  Center(
                    child: Container(
                      width: screenWidth,
                      child: Image.asset('assets/images/imgNotFound.jpg', fit: BoxFit.cover,),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 270),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    left: 15,
                  ),
                  child: Text(
                    (widget.city),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(
                    (widget.country),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(
                    left: 15,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (widget.description),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
