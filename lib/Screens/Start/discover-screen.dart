import 'package:Poro/Api/api-clients.dart';
import 'package:Poro/Model/pothole.dart';
import 'package:Poro/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pothole>>(
      future: fetchDataPotholes(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? PhotosList(potholes: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
class PhotosList extends StatelessWidget {
  final List<Pothole> potholes;

  PhotosList({Key key, this.potholes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: potholes.length,
      itemBuilder: (context, index) {
        return Image.network(APIClient.imageURL+potholes[index].image);
      },
    );
  }
}
