import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../apis/profile.dart';

class MenuDashboardPage extends StatefulWidget {
  MenuDashboardPage(profileData);
  var profileData;
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            margin: EdgeInsetsDirectional.only(
              top: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.red[900], Colors.red[500]]),
              borderRadius: BorderRadius.circular(20),
              color: Colors.red,
            ),
            height: 300,
            width: 350,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.red[900], Colors.red[500]]),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  height: 200,
                  width: 350,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Attendance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.red[900], Colors.red[500]]),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  height: 200,
                  width: 350,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Time Table',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              child: PageView(
                controller: PageController(viewportFraction: 0.8),
                scrollDirection: Axis.horizontal,
                pageSnapping: true,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.redAccent,
                    width: 100,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.blueAccent,
                    width: 100,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.greenAccent,
                    width: 100,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Transactions",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Macbook"),
                    subtitle: Text("Apple"),
                    trailing: Text("-2900"),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(height: 16);
                },
                itemCount: 10)
          ],
        ),
      ),
    );
  }
}
