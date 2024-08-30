import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/svg_string.dart';

class LocationSearchScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const LocationSearchScreen({super.key, required this.latitude, required this.longitude});

  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _places = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchPlaces);
  }

  void _searchPlaces() async {
    final query = _searchController.text;

    if (query.isNotEmpty) {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=10'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _places = data.take(3).map((place) => {
              'name': place['display_name'],
              'lat': place['lat'],
              'lon': place['lon']
            }).toList();
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _places = [];
        });
      }
    }
  }

  void _selectPlace(Map<String, dynamic> place) {
    Navigator.of(context).pop(place['name']); // Return only the name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: SvgPicture.string(
            SvgStringName.svgBack,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
            'Add Location',
            style: TextStyle(
             fontSize: 20,
             fontWeight: FontWeight.w500,
          ),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Input Text',
                hintStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w400, fontSize: 14,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                return ListTile(
                  title: Text(place['name']),
                  onTap: () => _selectPlace(place),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
