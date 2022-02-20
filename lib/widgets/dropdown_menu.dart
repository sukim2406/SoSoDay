import 'package:flutter/material.dart';

class DropdownMenu extends StatelessWidget {
  final matchDocId;
  final user;
  final data;
  final index;
  const DropdownMenu(
      {Key? key,
      required this.matchDocId,
      required this.user,
      required this.data,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List dropdownList = [
      () {
        print('menu 1');
      },
      () {
        print('menu 2');
      },
      () {
        print('menu 3');
      },
    ];
    return Container(
        child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
          icon: const Icon(Icons.more_vert),
          items: (data['images'][index]['creator'] == user['name'])
              ? [
                  'Set as profile image',
                  'Set as background image',
                  'Delete image'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList()
              : [
                  'Set as profile image',
                  'Set as background image',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
          onChanged: (String? newValue) {
            if (newValue == 'Set as profile image') {
              dropdownList[0]();
            } else if (newValue == 'Set as background image') {
              dropdownList[1]();
            } else {
              dropdownList[2]();
            }
          }),
    ));
  }
}
