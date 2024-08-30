import 'package:flutter/material.dart';
import 'package:visto_mobile/Profile.dart';

class EditUserDialog extends StatefulWidget {
  final User user;

  EditUserDialog({required this.user});

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _fullnameController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _cinController;
  late TextEditingController _phoneController;
  late TextEditingController _adresseController;
  late TextEditingController _streetController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _postalcodeController;
  late TextEditingController _countryController;
  late TextEditingController _typeofdegreeController;
  late TextEditingController _specialityController;
  late TextEditingController _dateofdegreeController;
  late TextEditingController _jobtitleController;
  late TextEditingController _departementController;
  late TextEditingController _linemanagerController;
  late TextEditingController _startdateController;
  late TextEditingController _enddateController;
  late TextEditingController _avatarController;
  late TextEditingController _statusController;
  late TextEditingController _id2Controller;
  late TextEditingController _degreeController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController(text: widget.user.fullname);
    _dobController = TextEditingController(text: widget.user.dob);
    _genderController = TextEditingController(text: widget.user.gender);
    _cinController = TextEditingController(text: widget.user.cin.toString());
    _phoneController =
        TextEditingController(text: widget.user.phone.toString());
    _adresseController = TextEditingController(text: widget.user.adresse);
    _streetController = TextEditingController(text: widget.user.street);
    _stateController = TextEditingController(text: widget.user.state);
    _cityController = TextEditingController(text: widget.user.city);
    _postalcodeController =
        TextEditingController(text: widget.user.postalcode.toString());
    _countryController = TextEditingController(text: widget.user.country);
    _typeofdegreeController =
        TextEditingController(text: widget.user.typeofdegree);
    _specialityController = TextEditingController(text: widget.user.speciality);
    _dateofdegreeController =
        TextEditingController(text: widget.user.dateofdegree);
    _jobtitleController = TextEditingController(text: widget.user.jobtitle);
    _departementController =
        TextEditingController(text: widget.user.departement);
    _linemanagerController =
        TextEditingController(text: widget.user.linemanager);
    _startdateController = TextEditingController(text: widget.user.startdate);
    _enddateController = TextEditingController(text: widget.user.enddate);
    _avatarController = TextEditingController(text: widget.user.avatar);
    _statusController = TextEditingController(text: widget.user.status);
    _id2Controller = TextEditingController(text: widget.user.id2);
    _degreeController = TextEditingController(text: widget.user.degree);
    _passwordController = TextEditingController(text: widget.user.password);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _cinController.dispose();
    _phoneController.dispose();
    _adresseController.dispose();
    _streetController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _postalcodeController.dispose();
    _countryController.dispose();
    _typeofdegreeController.dispose();
    _specialityController.dispose();
    _dateofdegreeController.dispose();
    _jobtitleController.dispose();
    _departementController.dispose();
    _linemanagerController.dispose();
    _startdateController.dispose();
    _enddateController.dispose();
    _avatarController.dispose();
    _statusController.dispose();
    _id2Controller.dispose();
    _degreeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User Details'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _fullnameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextField(
              controller: _cinController,
              decoration: InputDecoration(labelText: 'CIN'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _adresseController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _streetController,
              decoration: InputDecoration(labelText: 'Street'),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _postalcodeController,
              decoration: InputDecoration(labelText: 'Postal Code'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(labelText: 'Country'),
            ),
            TextField(
              controller: _typeofdegreeController,
              decoration: InputDecoration(labelText: 'Degree Type'),
            ),
            TextField(
              controller: _specialityController,
              decoration: InputDecoration(labelText: 'Speciality'),
            ),
            TextField(
              controller: _dateofdegreeController,
              decoration: InputDecoration(labelText: 'Date of Degree'),
            ),
            TextField(
              controller: _jobtitleController,
              decoration: InputDecoration(labelText: 'Job Title'),
            ),
            TextField(
              controller: _departementController,
              decoration: InputDecoration(labelText: 'Department'),
            ),
            TextField(
              controller: _startdateController,
              decoration: InputDecoration(labelText: 'Start Date'),
            ),
            TextField(
              controller: _enddateController,
              decoration: InputDecoration(labelText: 'End Date'),
            ),
            TextField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog without saving
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(User(
              fullname: _fullnameController.text,
              dob: _dobController.text,
              gender: _genderController.text,
              cin: int.tryParse(_cinController.text) ?? 0,
              phone: int.tryParse(_phoneController.text) ?? 0,
              email: widget.user.email,
              adresse: _adresseController.text,
              street: _streetController.text,
              state: _stateController.text,
              city: _cityController.text,
              postalcode: int.tryParse(_postalcodeController.text) ?? 0,
              country: _countryController.text,
              typeofdegree: _typeofdegreeController.text,
              speciality: _specialityController.text,
              dateofdegree: _dateofdegreeController.text,
              jobtitle: _jobtitleController.text,
              departement: _departementController.text,
              linemanager: _linemanagerController.text,
              startdate: _startdateController.text,
              enddate: _enddateController.text,
              avatar: _avatarController.text,
              status: _statusController.text,
              id2: _id2Controller.text,
              degree: _degreeController.text,
              password: _passwordController.text,
            )); // Save and close dialog
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
