import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'models/app_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MaterialColor primarySwatch = const MaterialColor(
    0xff03FC96,
    <int, Color>{
      50: Color(0xffE0FFF2),
      100: Color(0xffB3FFE0),
      200: Color(0xff80FFCD),
      300: Color(0xff4DFFBA),
      400: Color(0xff1AFFA8),
      500: Color(0xff03FC96),
      600: Color(0xff00CC7A),
      700: Color(0xff009D5F),
      800: Color(0xff006F44),
      900: Color(0xff003F29),
    },
  );

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YURCHEF',
      theme: ThemeData(
        primarySwatch: primarySwatch,
        fontFamily: 'Prompt',
        errorColor: AppConstants.pink,
      ),
      // home: InputPage(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // fixed super constructor call

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImageController _imageController = Get.put(ImageController());
  final TextEditingController _imageTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double widthNum = MediaQuery.of(context).size.width.toDouble();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            margin: const EdgeInsets.only(top: 40, bottom: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                                setState(() {
                                  _imageController.data.value = '';
                                });
                              },
                              child: Image.asset(
                                'assets/images/yurchef_logo_regular.png',
                                width: 120,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: MaterialButton(
                        splashColor: Colors.transparent,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        },
                        child: const Icon(
                          Icons.refresh,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return _imageController.isLoading.value
                      ? SizedBox(
                          width: double.infinity,
                          // height: 319,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/loading_transparent.gif',
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Cookin\'up something good!',
                                style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5)),
                              ),
                            ],
                          ))
                      : (_imageController.data.value.isNotEmpty)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: InkWell(
                                  onTap: () => showDialog(
                                      builder: (BuildContext context) => AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding: const EdgeInsets.all(2),
                                            title: SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              // height: MediaQuery.of(context).size.height / 2,

                                              child: Column(children: [
                                                InteractiveViewer(
                                                  panEnabled: true, // Set it to false
                                                  boundaryMargin: const EdgeInsets.all(300),
                                                  minScale: 1,
                                                  maxScale: 16,
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: widthNum,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          _imageController.data.value,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                      context: context),
                                  child: Container(
                                    width: double.infinity,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppConstants.lightHover,
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.black.withOpacity(1),
                                        width: 1,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          _imageController.data.value,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/header_image_transparent.png',
                                          ),
                                        ),
                                        const Text(
                                          "To get started, simply type ingredients you have, or want to use! More info below.",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "Use commas to help show more accurate results (possibly).",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                }),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  width: MediaQuery.of(context).size.width / 1,
                  child: Material(
                    color: Colors.white,
                    elevation: 3,
                    shadowColor: Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (
                          _imageTextController,
                        ) {
                          if (_imageTextController?.isEmpty ?? true) {
                            return "Please enter at least 1 ingredient.";
                          }
                          return null;
                        },
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Enter your ingredients!',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppConstants.green),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        controller: _imageTextController,
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 3,
                        // textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  return _imageController.isLoading.value
                      ? const Center()
                      : Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                          child: Material(
                            color: Colors.transparent,
                            child: MaterialButton(
                              elevation: 3,
                              highlightElevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              color: AppConstants.green,
                              splashColor: AppConstants.green,
                              // splashColor: Colors.red,
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  await _imageController.getImage(
                                    imageText: _imageTextController.text.trim(),
                                  );
                                }
                              },
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  )),
                                  width: MediaQuery.of(context).size.width,
                                  // padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                  child: (_imageController.data.value.isEmpty) ? const Center(child: Text("Show Me The Dish!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))) : const Center(child: Text("Show Me Another One!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)))),
                            ),
                          ),
                        );
                }),
                const SizedBox(height: 10),
                Tooltip(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  triggerMode: TooltipTriggerMode.tap,
                  message: AppConstants.appDescription,
                  child: const Text(
                    '🤨 What\'s this app about❓',
                    style: TextStyle(
                      fontSize: 10,
                    ),
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

class ImageController extends GetxController {
  var url = Uri.parse('https://api.openai.com/v1/images/generations');
  // ignore: non_constant_identifier_names
  var api_token = '';

  Rx<List<ImageModel>> image = Rx<List<ImageModel>>([]);
  final data = ''.obs;
  final isLoading = false.obs;

  Future getImage({required String imageText}) async {
    try {
      isLoading.value = true;
      var request = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $api_token',
        },
        body: jsonEncode(
          {
            'prompt': "create a dish with " + imageText + " in an all white square plate, and with a vibrant pastel background. Make the meal look as realistic, & tasty as possible.",
          },
        ),
      );
      if (request.statusCode == 200) {
        isLoading.value = false;
        data.value = jsonDecode(request.body)['data'][0]['url'];
        // print(data.value);
        // image.value.add(ImageModel.fromJson((jsonDecode(request.body))));
        // print(jsonDecode(request.body));
      } else {
        isLoading.value = false;
        // print(jsonDecode(request.body));
      }
    } catch (e) {
      isLoading.value = false;
      // print(e.toString());
    }
  }
}

ImageModel imageModelFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  ImageModel({
    this.created,
    this.data,
  });

  int? created;
  List<Datum>? data;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        created: json["created"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "created": created,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.url,
  });

  String? url;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
