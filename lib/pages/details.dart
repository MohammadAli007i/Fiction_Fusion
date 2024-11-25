import 'package:book_app/database/shared-preference.dart';
import 'package:book_app/pages/pdf.dart';
import 'package:book_app/widget/widget_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  String image, name, detail, description, file;
  Details(
      {required this.name,
      required this.image,
      required this.detail,
      required this.description,
      required this.file});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1;
  String? id;
  bool isLoadingRead = false;
  bool isLoadingFavourite = false;

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.black,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.image,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.2,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Lora"),
                      ),
                      Text(
                        widget.detail,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lora'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                widget.description,
                maxLines: 35,
                style: AppWidget.LightTextFieldStyle(),
              ),
              SizedBox(height: 30.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF018786),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isLoadingRead
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isLoadingRead = true;
                                    });
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PDF1(
                                                pdf: widget.file,
                                                detail: widget.detail,
                                              )),
                                    );
                                    setState(() {
                                      isLoadingRead = false;
                                    });
                                  },
                                  child: Text(
                                    "Read Me",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'Bitter',
                                    ),
                                  ),
                                ),
                          SizedBox(width: 30.0),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Color(0xFF03DAC6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.read_more,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(width: 20.0),
                    // GestureDetector(
                    //   onTap: () async {
                    //     setState(() {
                    //       isLoadingFavourite = true;
                    //     });
                    //     Map<String, dynamic> addBooktofav = {
                    //       "Name": widget.name,
                    //       "Image": widget.image,
                    //       "Detail": widget.detail
                    //     };
                    //     await DatabaseMethods().addBooktofav(addBooktofav, id!);
                    //     setState(() {
                    //       isLoadingFavourite = false;
                    //     });
                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //         backgroundColor: Colors.brown,
                    //         content: Text(
                    //           "Your Book is Added to Favorite",
                    //           style: TextStyle(
                    //               fontSize: 18.0, fontFamily: "Bitter"),
                    //         )));
                    //   },
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width / 2.2,
                    //     padding: EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black,
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: [
                    //         isLoadingFavourite
                    //             ? CircularProgressIndicator(
                    //                 color: Colors.white,
                    //                 strokeWidth: 2,
                    //               )
                    //             : Text(
                    //                 "Favourite",
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 16.0,
                    //                   fontFamily: 'Bitter',
                    //                 ),
                    //               ),
                    //         SizedBox(width: 30.0),
                    //         Container(
                    //           padding: EdgeInsets.all(3),
                    //           decoration: BoxDecoration(
                    //             color: Colors.grey,
                    //             borderRadius: BorderRadius.circular(8),
                    //           ),
                    //           child: Icon(
                    //             Icons.library_add,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
