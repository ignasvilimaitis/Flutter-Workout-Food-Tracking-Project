

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/assets.dart';
import 'package:flutter_application_1/features/settings/presentation/widgets/settings_button.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final double _kItemExtent = 32.0;
  List<String> genderOptions = ['Male', 'Female', 'Other'];
  String selectedGender = '';
  int selectedWeight = 70;
  int selectedHeight = 170;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((16.0)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Top row with back button and title
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: SvgPicture.asset(
                        AppAssets.misc.returnIcon,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.line_weight,
                        size: 30.0,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Profile",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              const Text("Sensitive", style: TextStyle(fontSize: 12.0)),
              Padding(padding: EdgeInsetsGeometry.directional(top: 5)),
              SettingsUIButton(
                text: "Set Gender",
                onPressed: () {
                  _showDialog(
                    CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: genderOptions.indexOf(selectedGender)),
                      itemExtent: _kItemExtent,
                      onSelectedItemChanged: (int selectedGender) {
                        setState(() {
                          this.selectedGender = genderOptions[selectedGender];
                        print(genderOptions[selectedGender]);
                          
                        });
                      },
                      children: List<Widget>.generate(genderOptions.length, (int index) {
                        return Center(
                          child: Text(genderOptions[index]),
                      );
                      },
                  )
                    )
                    );
                },
                icon: Icons.wc),
              SettingsUIButton(
                text: "Set Weight",
                onPressed: () {
                  _showDialog(
                    CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: selectedWeight),
                      itemExtent: _kItemExtent,
                      onSelectedItemChanged: (int selectedWeight) {
                        setState(() {
                          this.selectedWeight = selectedWeight;
                        });
                      },
                      children: List<Widget>.generate(300, (int index) {
                        return Center(
                          child: Text('${index}kg'),
                      );
                      },
                  )
                    )
                    );
                },
                icon: Icons.monitor_weight),
              SettingsUIButton(
                text: "Set Height",
                onPressed: () {
                                    _showDialog(
                    CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: selectedHeight),
                      itemExtent: _kItemExtent,
                      onSelectedItemChanged: (int selectedHeight) {
                        setState(() {
                          this.selectedHeight = selectedHeight;
                        });
                      },
                      children: List<Widget>.generate(250, (int index) {
                        return Center(
                          child: Text('${index}cm'),
                      );
                      },
                  )
                    )
                    );
                },
                icon: Icons.square_foot),
            ]
          )
        )
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
       builder: (BuildContext context) {
        return Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: child,
          ),
        );
       }
    );

  }
}
