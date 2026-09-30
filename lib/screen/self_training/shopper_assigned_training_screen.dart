import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopperxm_flutter/network/api_helper.dart';
import 'package:shopperxm_flutter/screen/self_training/shopper_start_lms_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import '../../network/Utils.dart';

class ShopperAssignedTrainingScreen extends StatefulWidget {
  final String trainingType;

  const ShopperAssignedTrainingScreen({super.key, required this.trainingType});

  @override
  State<ShopperAssignedTrainingScreen> createState() =>
      _ShopperAssignedTrainingScreenState();
}

class _ShopperAssignedTrainingScreenState
    extends State<ShopperAssignedTrainingScreen> {
  /// ================= VARIABLES =================
  List<dynamic> pendingTrainingList = [];

  bool isLoading = false;
  bool isEmpty = false;

  String userEmail = "";

  String getTrainingListApi = "https://lms.qdegrees.com/api/get-all-trainings";
  String getTrainingUrlApi = "https://lms.qdegrees.com/api/get-training-url";

  /// ================= INIT =================
  @override
  void initState() {
    super.initState();
    findUserDetails();
  }

  /// ================= USER =================
  void findUserDetails() async {
    String? email = await MyUtils.getSharedPreferences("email");
    String? nme = await MyUtils.getSharedPreferences("name");
    String? uType = await MyUtils.getSharedPreferences("usertype");
    userEmail = email ?? "NA";
    getTrainingList();
  }

  /// ================= API 1 =================
  Future<void> getTrainingList() async {
    setState(() {
      isLoading = true;
      isEmpty = false;
    });

    try {
      var response = await http.post(
        Uri.parse(getTrainingListApi),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "User-Agent": "Flutter",
        },
        body: {
          "email": userEmail,
          "status": widget.trainingType,
        },
      );

      var jsonData = jsonDecode(response.body);

      print("APi Response: $jsonData");

      if (jsonData["success"] == true) {
        pendingTrainingList = jsonData["data"] ?? [];

        if (pendingTrainingList.isEmpty) {
          isEmpty = true;
        }
      } else {

        showMsg(jsonData["message"]?.toString()??"Something went wrong! Please try again later");
        isEmpty = true;
      }
    } catch (e) {
      showMsg(e.toString());
      isEmpty = true;
    }

    setState(() {
      isLoading = false;
    });
  }

  /// ================= API 2 =================
  Future<void> getTrainingUrl(String trainingId) async {
    showLoader();

    try {
      var response = await http.post(
        Uri.parse(getTrainingUrlApi),
        body: {
          "email": userEmail,
          "training_id": trainingId,
        },
      );

      Navigator.pop(context);

      var jsonData = jsonDecode(response.body);

      print("Response $jsonData");

      if (jsonData["success"] == true) {
        String url = jsonData["data"] ?? "";
        if (url.isNotEmpty && url != "null") {
          redirectToTraining(url);
        } else {
          showMsg("Training Url is Empty");
        }
      } else {
        showMsg(jsonData["message"]?.toString()??"Something went wrong! Please try again");
      }
    } catch (e) {
      Navigator.pop(context);
      showMsg(e.toString());
    }
  }

  /// ================= NAVIGATION =================
  Future<void> redirectToTraining(String url) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopperStartLMSScreen(trainingUrl: url),
      ),
    );

    getTrainingList();
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Card(
          elevation: 4,
          margin: EdgeInsets.only(top: 27),
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Container(
            height: 69,
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.keyboard_backspace_rounded)),
                Expanded(
                    child: Center(
                  child: Text(
                      widget.trainingType == "0"
                          ? "Training Assigned"
                          : "Training Completed",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      )),
                ))
              ],
            ),
          ),
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : isEmpty
                ? Expanded(child: _emptyView())
                : Expanded(
                    child: ListView.builder(
                    itemCount: pendingTrainingList.length,
                    itemBuilder: (context, index) {
                      var item = pendingTrainingList[index];
                      double progress = double.tryParse(
                              item["completion_percentage"].toString()) ??
                          0;

                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 3,
                        child: InkWell(
                          onTap: () {
                            getTrainingUrl(item["id"]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                /// IMAGE
                                Image.network(
                                  item["thumbnail"] ?? "",
                                  height: 60,
                                  width: 60,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image),
                                ),

                                const SizedBox(width: 10),

                                /// TEXT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["title"] ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      LinearProgressIndicator(
                                        value: progress / 100,
                                      ),
                                      const SizedBox(height: 5),
                                      Text("${progress.toInt()}% Completed"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
      ],
    ));
  }

  /// ================= EMPTY =================
  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.trainingType == "0"
              ? "No Assigned Training Found. Please Try to refresh"
              : "No Completed Training Found. Please Try to refresh"),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppTheme.orangeColor),
            onPressed: getTrainingList,
            child: const Text("Refresh"),
          )
        ],
      ),
    );
  }

  /// ================= LOADER =================
  void showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  /// ================= MSG =================
  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
