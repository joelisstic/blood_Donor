import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'databasehelper.dart';
import 'registration.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imageUrls = [
    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image3.png',
  ];
  List<Map<String, dynamic>> _donors = [];
  List<Map<String, dynamic>> _filteredDonors = [];
  String _searchQuery = '';


  @override
  void initState() {
    super.initState();
    _fetchDonors();
  }

  Future<void> _fetchDonors() async {
    final donors = await DatabaseHelper.instance.getAllDonors();
    setState(() {
      _donors = donors;
      _filteredDonors = donors;
    });
  }

  void _callPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _deleteDonor(int id) async {
    await DatabaseHelper.instance.deleteDonor(id);
    _fetchDonors();
  }

  void _editDonor(Map<String, dynamic> donor) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(donor: donor),
      ),
    );
    _fetchDonors();
  }

  void _filterDonors(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredDonors = _donors.where((donor) {
        final name = donor['name']?.toLowerCase() ?? '';
        final bloodType = "${donor['bloodType'] ?? ''}${donor['rhFactor'] ?? ''}".toLowerCase();
        return name.contains(_searchQuery) || bloodType.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(null),
        title: Text("Donor List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: imageUrls.map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterDonors,
              decoration: InputDecoration(
                hintText: 'Search by name or blood type',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredDonors.isEmpty
                ? Center(child: Text("No donors available"))
                : ListView.builder(
              itemCount: _filteredDonors.length,
              itemBuilder: (context, index) {
                final donor = _filteredDonors[index];

                String formattedDate;
                if (donor['lastDonationDate'] != null) {
                  DateTime lastDonationDate = DateTime.parse(donor['lastDonationDate']);
                  formattedDate = DateFormat('yyyy-MM-dd').format(lastDonationDate);
                } else {
                  formattedDate = 'N/A';
                }

                return Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          top: 12,
                          left: 150,
                          child: Row(
                            children: [
                              Icon(Icons.water_drop, color: Colors.redAccent),
                              SizedBox(width: 4),
                              Text(
                                "${donor['bloodType'] ?? 'Unknown'}${donor['rhFactor'] ?? ''}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Text(donor['name'] ?? 'Unknown Name'),
                              Icon(
                                donor['gender']?.toString().toLowerCase() == 'female' ||
                                    donor['gender']?.toString().toLowerCase() == 'f'
                                    ? Icons.female
                                    : Icons.male,
                              ),
                              SizedBox(width: 30),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text("Last donation: $formattedDate"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (donor['phone'] != null) {
                                    _callPhoneNumber(donor['phone']!);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Phone number not available')),
                                    );
                                  }
                                },
                                icon: Icon(Icons.phone, size: 20),
                              ),
                              IconButton(
                                onPressed: () {
                                  _editDonor(donor);
                                },
                                icon: Icon(Icons.edit, size: 20),
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteDonor(donor['id']);
                                },
                                icon: Icon(Icons.delete, size: 20, color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Divider()
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
          );
          _fetchDonors();
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
