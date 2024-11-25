import 'dart:io';
import 'package:book_app/database/database.dart';
import 'package:book_app/widget/widget_support.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final List<String> moviesitems = ['Marvel', 'Stranger', 'Disney', 'Harry' , 'IT'];
  String? value;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  File? selectedFile;

  bool isLoading = false; // Loading flag

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'epub'],
    );

    if (result != null) {
      selectedFile = File(result.files.single.path!);
      setState(() {});
    }
  }

  uploadItem() async {
    if (selectedImage != null &&
        namecontroller.text.isNotEmpty &&
        detailcontroller.text.isNotEmpty &&
        value != null) {
      setState(() {
        isLoading = true; // Start loading
      });

      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child("blogImage").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();

      Reference firebaseStorageRefFile =
      FirebaseStorage.instance.ref().child("bookFiles").child(addId);
      final UploadTask taskFile = firebaseStorageRefFile.putFile(selectedFile!);
      var downloadFileUrl = await (await taskFile).ref.getDownloadURL();

      Map<String, dynamic> addItem = {
        "Image": downloadUrl,
        "File": downloadFileUrl,
        "Name": namecontroller.text,
        "Detail": detailcontroller.text,
        "Description": descontroller.text,
      };
      await DatabaseMethods().addBookItem(addItem, value!).then((value) {
        setState(() {
          isLoading = false; // Stop loading
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Item has been added Successfully",
              style: TextStyle(fontSize: 18.0),
            )));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Please complete all fields.",
          style: TextStyle(fontSize: 18.0 ,fontFamily: "Bitter"),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF018786),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFFF5F5F5),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Book",
          style: TextStyle(
              fontSize: 24.0,
              color: Color(0xFFF5F5F5),
              fontFamily: "Bitter",
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              left: 20.0, right: 20.0, top: 20.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Upload the Book Image",
                style: TextStyle(color: Colors.black ,
                    fontSize: 18.0 ,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Bitter"),
              ),
              SizedBox(
                height: 20.0,
              ),
              selectedImage == null
                  ? GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Center(
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF018786), width: 1.5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.camera_enhance_sharp,
                        color: Color(0xFF018786),
                      ),
                    ),
                  ),
                ),
              )
                  : Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Book Name",
                style:TextStyle(color: Colors.black ,
                    fontSize: 18.0 ,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Bitter"),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Book Name",
                      hintStyle: AppWidget.LightTextFieldStyle()),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Book Details",
                style: TextStyle(color: Colors.black ,
                    fontSize: 18.0 ,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Bitter"),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: detailcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Book Details",
                      hintStyle: AppWidget.LightTextFieldStyle()),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Book Description",
                style: TextStyle(color: Colors.black ,
                    fontSize: 18.0 ,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Bitter"),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 10,
                  controller: descontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Book Description",
                      hintStyle: AppWidget.LightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Select Book File (PDF or EPUB)",
                style: TextStyle(color: Colors.black ,
                    fontSize: 18.0 ,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Bitter"),
              ),
              SizedBox(height: 10.0),
              selectedFile == null
                  ? GestureDetector(
                onTap: () {
                  pickFile();
                },
                child: Center(
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF018786),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Select File",
                        style: TextStyle(
                            color: Color(0xFFececf8), fontSize: 18.0 , fontWeight: FontWeight.bold , fontFamily: "bitter"),
                      ),
                    ),
                  ),
                ),
              )
                  : Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF018786),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "File Selected: ${selectedFile!.path.split('/').last}",
                      style: TextStyle(
                          color: Color(0xFFececf8), fontSize: 18.0 ,fontFamily: "bitter"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Select Category",
                style:TextStyle(color: Colors.black ,
                    fontSize: 18.0 ,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Bitter"),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: moviesitems
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                            fontSize: 18.0, color: Colors.black),
                      ),
                    ))
                        .toList(),
                    onChanged: ((value) => setState(() {
                      this.value = value;
                    })),
                    dropdownColor: Color(0xFFececf8),
                    hint: Text("Select Book Category" , style: TextStyle(fontFamily: "bitter"),),
                    iconSize: 36,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,style: TextStyle(fontFamily: 'bitter'),
                  ),
                ),
              ),
              SizedBox(height: 30.0),

              // The "Add" Button with Loading Indicator
              GestureDetector(
                onTap: () {
                  if (!isLoading) {
                    uploadItem();
                  }
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                          color: Color(0xFF018786),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: isLoading
                            ? CircularProgressIndicator(
                          color: Color(0xFFececf8),
                        )
                            : Text(
                          "Add",
                          style: TextStyle(
                            color: Color(0xFFececf8),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Bitter',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}