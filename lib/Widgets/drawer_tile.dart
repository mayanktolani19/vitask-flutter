import 'package:flutter/material.dart';

Widget drawerTile(
    BuildContext context, MaterialPageRoute mPR, Icon icon, String text) {
  return ListTile(
    leading: icon,
    dense: true,
    title: Text(
      text,
      style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal),
    ),
    onTap: () async {
      Navigator.pop(context);
      Navigator.push(
        context,
        mPR,
      );
    },
  );
}

Widget div() {
  return Divider(
    thickness: 1,
    color: Colors.indigo,
  );
}
