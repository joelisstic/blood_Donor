import 'package:flutter/material.dart';
import 'databasehelper.dart';

class RegistrationPage extends StatefulWidget {
  final Map<String, dynamic>? donor;

  RegistrationPage({this.donor});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedBloodType = 'A';
  String _selectedRhFactor = '+';
  DateTime? _lastDonationDate;
  String _selectedGender = 'Male';
  int? _donorId;

  @override
  void initState() {
    super.initState();

    if (widget.donor != null) {
      _donorId = widget.donor!['id'];
      _nameController.text = widget.donor!['name'];
      _phoneController.text = widget.donor!['phone'];
      _selectedBloodType = widget.donor!['bloodType'];
      _selectedRhFactor = widget.donor!['rhFactor'];
      _selectedGender = widget.donor!['gender'];
      if (widget.donor!['lastDonationDate'] != null) {
        _lastDonationDate = DateTime.parse(widget.donor!['lastDonationDate']);
      }
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty || value.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  Widget _buildGridButton(String label, bool isSelected, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        color: isSelected ? Colors.redAccent : Colors.white,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.donor == null ? "Register Donor" : "Edit Donor",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Color(0xfffaeeee),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      return value!.length < 1 ? "Must enter name" : null;
                    }),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNumber,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Select Gender:", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = 'Male';
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.male,
                            color: _selectedGender == 'Male'
                                ? Colors.redAccent
                                : Colors.grey,
                            size: 40,
                          ),
                          Text("Male"),
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = 'Female';
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.female,
                            color: _selectedGender == 'Female'
                                ? Colors.redAccent
                                : Colors.grey,
                            size: 40,
                          ),
                          Text("Female"),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text("Select Blood Group:", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                SizedBox(
                  height: screenHeight * 0.2,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildGridButton('A', _selectedBloodType == 'A', () {
                        setState(() {
                          _selectedBloodType = 'A';
                        });
                      }),
                      _buildGridButton('B', _selectedBloodType == 'B', () {
                        setState(() {
                          _selectedBloodType = 'B';
                        });
                      }),
                      _buildGridButton('AB', _selectedBloodType == 'AB', () {
                        setState(() {
                          _selectedBloodType = 'AB';
                        });
                      }),
                      _buildGridButton('O', _selectedBloodType == 'O', () {
                        setState(() {
                          _selectedBloodType = 'O';
                        });
                      }),
                    ],
                  ),
                ),
                Text("Select Rh Factor:", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                SizedBox(
                  height: screenHeight * 0.1,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildGridButton('+', _selectedRhFactor == '+', () {
                        setState(() {
                          _selectedRhFactor = '+';
                        });
                      }),
                      _buildGridButton('-', _selectedRhFactor == '-', () {
                        setState(() {
                          _selectedRhFactor = '-';
                        });
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _lastDonationDate) {
                      setState(() {
                        _lastDonationDate = picked;
                      });
                    }
                  },
                  child: Text(
                    _lastDonationDate == null
                        ? 'Last Donation Date'
                        : _lastDonationDate!.toLocal().toString().split(' ')[0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 60),
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> donor = {
                        'name': _nameController.text,
                        'phone': _phoneController.text,
                        'bloodType': _selectedBloodType,
                        'rhFactor': _selectedRhFactor,
                        'lastDonationDate':
                            _lastDonationDate?.toIso8601String(),
                        'gender': _selectedGender,
                      };

                      if (_donorId == null) {
                        await DatabaseHelper.instance.insertDonor(donor);
                      } else {
                        donor['id'] = _donorId;
                        await DatabaseHelper.instance.updateDonor(donor);
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.donor == null ? "Add Donor" : "Update Donor",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
