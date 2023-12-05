class CityListModel {
  String? response;
  List<Data>? data;

  CityListModel({this.response, this.data});

  CityListModel.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response'] = response;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // Method to get city details by ID
  Data? getCityById(int id) {
    if (data != null) {
      for (Data cityData in data!) {
        if (cityData.id == id) {
          return cityData;
        }
      }
    }
    return null; // Return null if no city with the specified ID is found
  }
}

class Data {
  int? id;
  String? country;
  String? city;
  String? lat;
  String? lng;
  String? description;
  List<String>? images;

  Data({
    this.id,
    this.country,
    this.city,
    this.lat,
    this.lng,
    this.description,
    this.images,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    city = json['city'];
    lat = json['lat'];
    lng = json['lng'];
    description = json['description'];
    if (json['images'] != null) {
      if (json['images'] is List) {
        images = json['images'].cast<String>();
      } else if (json['images'] is String) {
        images = <String>[json['images']];
      }
    } else {
      images = <String>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['country'] = country;
    data['city'] = city;
    data['lat'] = lat;
    data['lng'] = lng;
    data['description'] = description;
    data['images'] = images;
    return data;
  }
}
