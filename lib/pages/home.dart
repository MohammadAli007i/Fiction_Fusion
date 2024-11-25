import 'package:book_app/database/database.dart';
import 'package:book_app/pages/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool harry = false,
      disney = false,
      stranger = false,
      marvel = false,
      it = false;
  @override
  Stream? bookitemsStream;

  onload() async {
    bookitemsStream = await DatabaseMethods().getBookitem("Harry");
    setState(() {});
  }

  @override
  void initState() {
    onload();
    super.initState();
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Exit App",
          style: TextStyle(
            fontFamily: "Lora",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          "Do you really want to exit the app?",
          style: TextStyle(
            fontFamily: "Bitter",
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontFamily: "Lora"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontFamily: 'Lora'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Yes"),
          ),
        ],
      ),
    )) ??
        false;
  }

  Widget allItemsVertical() {
    return StreamBuilder(
      stream: bookitemsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot ma = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(
                            name: ma["Name"],
                            image: ma["Image"],
                            detail: ma["Detail"],
                            description: ma["Description"],
                            file: ma["File"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    ma["Image"],
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        ma["Name"],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Bitter",
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        ma["Detail"],
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Bitter",
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        "Read Me ->",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Lora",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        )
            : CircularProgressIndicator();
      },
    );
  }

  Widget allItems() {
    return StreamBuilder(
      stream: bookitemsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            DocumentSnapshot ma = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      name: ma["Name"],
                      image: ma["Image"],
                      detail: ma["Detail"],
                      description: ma["Description"],
                      file: ma["File"],
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(4),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            ma["Image"],
                            height: 150,
                            width: 250,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Text(
                          ma["Name"],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Bitter",
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          ma["Detail"],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Bitter",
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Read Me ->",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Lora",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )
            : CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              top: 50.0,
              left: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome to FictionFusion",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Lora",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70.0),
                Container(
                  margin: EdgeInsets.only(right: 20.0),
                  child: showItem(),
                ),
                SizedBox(height: 30.0),
                Container(height: 270, child: allItems()),
                SizedBox(height: 30.0),
                allItemsVertical(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Add your gesture detectors here for other categories
          // Harry Potter example:
          GestureDetector(
            onTap: () async {
              harry = true;
              disney = false;
              stranger = false;
              marvel = false;
              it = false;
              bookitemsStream = await DatabaseMethods().getBookitem("Harry");
              setState(() {});
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: harry ? Color(0xFFCCAF3C) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: harry
                    ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ]
                    : [],
              ),
              child: AnimatedScale(
                scale: harry ? 1.3 : 1.0,
                duration: Duration(milliseconds: 300),
                child: Image.asset(
                  "images/harrylog1.png",
                  color: harry ?  Colors.white : Color(0xFFCCAF3C),
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              harry = false;
              disney = true;
              stranger = false;
              marvel = false;
              it = false;
              bookitemsStream = await DatabaseMethods().getBookitem("Disney");
              setState(() {});
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: disney ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: disney
                    ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ]
                    : [],
              ),
              child: AnimatedScale(
                scale: disney ? 1.3 : 1.0,
                duration: Duration(milliseconds: 300),
                child: Image.asset(
                  "images/disney.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: disney ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              harry = false;
              disney = false;
              stranger = true;
              marvel = false;
              it = false;
              bookitemsStream = await DatabaseMethods().getBookitem("Stranger");
              setState(() {});
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: stranger ? Color(0xFFD90A0A) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: stranger
                    ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ]
                    : [],
              ),
              child: AnimatedScale(
                scale: stranger ? 1.3 : 1.0,
                duration: Duration(milliseconds: 300),
                child: Image.asset(
                  "images/strange1.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: stranger ? Colors.white : Color(0xFFD90A0A),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              harry = false;
              disney = false;
              stranger = false;
              marvel = true;
              it = false;
              bookitemsStream = await DatabaseMethods().getBookitem("Marvel");
              setState(() {});
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: marvel ? Color(0xFF4B0101) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: marvel
                    ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ]
                    : [],
              ),
              child: AnimatedScale(
                scale: marvel ? 1.3 : 1.0,
                duration: Duration(milliseconds: 300),
                child: Image.asset(
                  "images/marvel3.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: marvel ? Colors.white : Color(0xFF4B0101),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              harry = false;
              disney = false;
              stranger = false;
              marvel = false;
              it = true;
              bookitemsStream = await DatabaseMethods().getBookitem("IT");
              setState(() {});
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: it ? Color(0xFF011D45) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: it
                    ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ]
                    : [],
              ),
              child: AnimatedScale(
                scale: it ? 1.3 : 1.0,
                duration: Duration(milliseconds: 300),
                child: Image.asset(
                  "images/tech-remove.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: it ? Colors.white : Color(0xFF011D45),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
