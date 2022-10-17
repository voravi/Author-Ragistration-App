import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:author_registration_app_firebase_miner3/helpers/firebase_coloud_helper.dart';
import 'package:author_registration_app_firebase_miner3/utils/colours.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  Uint8List? image;
  Uint8List? decodedImage;
  String encodedImage = "";
  String books = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController booksController = TextEditingController();

  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  TextEditingController updateNameController = TextEditingController();
  TextEditingController updateBooksController = TextEditingController();

  GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();

  // Future<List<Student>>? stuData;

  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   stuData = StudentHelper.studentHelper.fetchAllData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Ragister Your Book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              log(image.toString(), name: "image checking");
              insertNoteData(context);
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Authors : ",
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 3),
              ),
            ),
            SizedBox(
              height: 590,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseCloudHelper.firebaseCloudHelper.fetchAllData(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("ERROR: ${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;

                    return ListView.builder(
                      itemCount: queryDocumentSnapshot.length,
                      itemBuilder: (context, i) {
                        Map<String, dynamic> data = queryDocumentSnapshot[i].data() as Map<String, dynamic>;

                        if (data["image"] != null) {
                          // decodedImage == null;
                          decodedImage = base64Decode(data["image"]);
                        } else {
                          decodedImage == null;
                        }
                        //image = base64Decode(data['image']);
                        return Padding(
                          padding: EdgeInsets.all(12),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 220,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (decodedImage == null)
                                    ? Text(
                                        "NO IMAGE",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                      )
                                    : Container(
                                        height: 130,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.memory(
                                            decodedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                SizedBox(height: 15,),
                                Row(
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Author : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: secondaryColor,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${data["name"]}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: primaryColor.withOpacity(0.7),
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () async {
                                        deleteOneData(id: queryDocumentSnapshot[i].id);
                                      },
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Books : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: secondaryColor,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 225,
                                      padding: EdgeInsets.only(top: 3),
                                      child: Text(
                                        "${data["books"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: primaryColor.withOpacity(0.5),
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  insertNoteData(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  "Add Author",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                ),
                content: Form(
                  key: insertFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Ink(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: secondaryColor,
                          ),
                          child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();

                              XFile? img = await _picker.pickImage(source: ImageSource.gallery);

                              if (img != null) {
                                File compressedImage = await FlutterNativeImage.compressImage(img.path);
                                image = await compressedImage.readAsBytes();
                                encodedImage = base64Encode(image!);

                              }
                              setState(() {});
                            },
                            child: CircleAvatar(
                              backgroundColor: secondaryColor,
                              radius: 50,
                              child: Center(
                                child: image == null
                                    ? const Text(
                                        "ADD IMAGE",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                      )
                                    : Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.memory(
                                            image!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: nameController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter name";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            setState(() {
                              name = val!;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Name",
                            hintText: "Enter name",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 3,
                          controller: booksController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter Books";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            setState(() {
                              books = val!;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Books",
                            alignLabelWithHint: true,
                            hintText: "Enter Books...",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      if (insertFormKey.currentState!.validate()) {
                        insertFormKey.currentState!.save();

                        await FirebaseCloudHelper.firebaseCloudHelper.insertData(name: name, books: books, image: encodedImage);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Failed To Add data"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                      nameController.clear();
                      booksController.clear();

                      setState(() {
                        name = "";
                        books = "";
                        image == null;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    child: const Text("save"),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: secondaryColor,
                    ),
                    onPressed: () {
                      nameController.clear();
                      booksController.clear();

                      setState(() {
                        name = "";
                        books = "";
                        image == null;
                      });

                      Navigator.pop(context);
                    },
                    child: const Text("cancel"),
                  ),
                ],
              );
            },
          );
        });
  }

  // updateData(BuildContext context, {required String id, required String updateTitle, required String updateDesc}) {
  //   updateNameController.text = updateTitle;
  //   updateBooksController.text = updateDesc;
  //
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text("Update Record"),
  //           content: Form(
  //             key: updateFormKey,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   TextFormField(
  //                     controller: updateNameController,
  //                     validator: (val) {
  //                       if (val!.isEmpty) {
  //                         return "Enter Name";
  //                       }
  //                       return null;
  //                     },
  //                     onSaved: (val) {
  //                       setState(() {
  //                         name = val!;
  //                       });
  //                     },
  //                     decoration: const InputDecoration(
  //                       border: OutlineInputBorder(),
  //                       labelText: "Name",
  //                       hintText: "Enter name",
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   TextFormField(
  //                     maxLines: 3,
  //                     controller: updateBooksController,
  //                     validator: (val) {
  //                       if (val!.isEmpty) {
  //                         return "Enter Book";
  //                       }
  //                       return null;
  //                     },
  //                     onSaved: (val) {
  //                       setState(() {
  //                         books = val!;
  //                       });
  //                     },
  //                     decoration: const InputDecoration(
  //                       border: OutlineInputBorder(),
  //                       labelText: "Book",
  //                       alignLabelWithHint: true,
  //                       hintText: "Enter Books...",
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           actions: [
  //             ElevatedButton(
  //               onPressed: () async {
  //                 if (updateFormKey.currentState!.validate()) {
  //                   updateFormKey.currentState!.save();
  //
  //                   await FirebaseCloudHelper.firebaseCloudHelper.updateData(id: id, name: name, books: books);
  //                 } else {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                       backgroundColor: Colors.red,
  //                       content: Text("Failed To Update data"),
  //                       behavior: SnackBarBehavior.floating,
  //                     ),
  //                   );
  //                 }
  //                 updateNameController.clear();
  //                 updateBooksController.clear();
  //
  //                 setState(() {
  //                   name = "";
  //                   books = "";
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: const Text("Update"),
  //             ),
  //             OutlinedButton(
  //               onPressed: () {
  //                 updateNameController.clear();
  //                 updateBooksController.clear();
  //
  //                 setState(() {
  //                   name = "";
  //                   books = "";
  //                 });
  //
  //                 Navigator.pop(context);
  //               },
  //               child: const Text("cancel"),
  //             ),
  //           ],
  //         );
  //       });
  // }

  deleteOneData({required String id}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Data"),
        content: const Text(
          "Are you sure to delete this data permanently",
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () async {
              FirebaseCloudHelper.firebaseCloudHelper.deleteData(deleteId: id);

              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
