import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopperxm_flutter/screen/barcode_scanner/scanned_data_model_class.dart';
import 'package:shopperxm_flutter/screen/barcode_scanner/shopper_browse_barcode_artifact_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import 'barcode_scan_screen.dart';
import 'product_scan_screen.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final String storeId;
  final String tagId;
  final String storeName;
  final String storeAddress;
  final String storeCity;
  final String storeCode;
  final String storeState;

  const BarcodeScannerScreen({
    required this.storeId,
    required this.tagId,
    required this.storeName,
    required this.storeAddress,
    required this.storeCity,
    required this.storeCode,
    required this.storeState,
  });

  @override
  State<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}



class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {

  List<ScannedBox> list = [];
  String shipmentId = "";
  String authKey = "", userId = "", emailStr = "";
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }
  // ================= USER =================
  void getUserDetails() async {
    authKey = await MyUtils.getSharedPreferences("access_token") ?? "";
    userId = await MyUtils.getSharedPreferences("user_id") ?? "";
    emailStr = await MyUtils.getSharedPreferences("email") ?? "";
    setState(() {});
  }
  /// ---------------- UI MESSAGE ----------------
  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
  /// ---------------- SCAN FLOW ----------------
  Future<void> scanTracking() async {
    if (shipmentId.isEmpty) {
      showMsg("Enter Shipment ID first");
      return;
    }
    showMsg("Please Scan Tracking Bar Code");
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BarcodeScanScreen(),
      ),
    );

    if (result != null) {
      print("RESULT: $result");
      openFNSKUStep(result); // 🔥 now it will work
    }

  }
  void openFNSKUStep(String tracking) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Tracking Scanned"),
          content: Text("Tracking ID: $tracking"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                scanFNSKU(tracking);
              },
              child: const Text("Scan FNSKU"),
            )
          ],
        );
      },
    );
  }
  Future<void> scanFNSKU(String tracking) async {
    showMsg("Please Scan FNSKU Bar Code");
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BarcodeScanScreen(),
      ),
    );
    print("FNSKU Result: $result");
    if(result!=null){
      openBoxDialog(tracking,result);
    }


  }
  /// ---------------- BOX DIALOG ----------------
  void openBoxDialog(String tracking, String fnsku) {
    TextEditingController box = TextEditingController();
    TextEditingController weight = TextEditingController();
    TextEditingController unit = TextEditingController();
    TextEditingController comment = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "Add Box",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text("Tracking: $tracking"),
                Text("FNSKU: $fnsku"),

                const SizedBox(height: 15),

                TextField(
                  controller: box,
                  decoration: InputDecoration(
                    labelText: "Box Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 10),


                TextField(
                  controller: weight,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    labelText: "Weight",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 10),


                TextField(
                  controller: unit,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    labelText: "Declared Unit",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: comment,
                  decoration: InputDecoration(
                    labelText: "Comment",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {


                      if (box.text.isEmpty ||
                          weight.text.isEmpty ||
                          unit.text.isEmpty) {
                        showMsg("Fill all fields");
                        return;
                      }

                      list.add(
                        ScannedBox(
                          widget.storeId,
                          widget.storeName,
                          widget.storeCode,
                          fnsku,
                          unit.text,
                          weight.text,
                          box.text,
                          comment.text.isEmpty ? " " : comment.text,
                          tracking,
                          shipmentId,
                          [],
                        ),
                      );

                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  /// ---------------- PRODUCT SCAN ----------------
  void openProduct(String tracking, String fnsku) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductScanScreen(tracking, fnsku)),
    );

    if (result != null) {
      for (var item in list) {
        if (item.trackingId == tracking && item.fnsku == fnsku) {
          item.products = result;
        }
      }
      setState(() {});
    }
  }
  /// ---------------- SUBMIT ----------------
  Future<void> submit() async {
    if (list.isEmpty) {
      showMsg("Please scan some data first");
      return;
    }
    APIDialog.showAlertDialog(context, "Uploading...");

    try {

      /// 🔥 CREATE DATA ARRAY (same Java logic)
      List data = list.map((e) {
        return {
          "barcode_store_id": widget.storeId,
          "user_id": userId,
          "tag_id": widget.tagId,
          "fnsku_no": e.fnsku,
          "declared_unit": e.unit,
          "box_weight": e.weight,
          "box_no": e.boxNo,
          "shipment_id": e.shipmentId,
          "scan_tracking_id": e.trackingId,
          "comment": e.comment,
          "product": e.products.map((p) {
            return {
              "product_id": p.productId,
              "weight": p.weight,
              "remark": p.remark,
              "tag_id": widget.tagId,
              "barcode_store_id": widget.storeId,
              "shipment_id": e.shipmentId,
              "scan_tracking_id": e.trackingId,
            };
          }).toList()
        };
      }).toList();
      Map<String, dynamic> body = {
        "data": data
      };

      print("REQUEST BODY: ${jsonEncode(body)}");

      var response = await ApiBaseHelper().postAPIWithHeader(
        "barcode_product_save",
        body,
        context,
      );

      if (!mounted) return;
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      var jsonResponse = jsonDecode(response.body);
      String message = jsonResponse["message"] ?? "";
      int status = jsonResponse["status"] ?? 0;
      showMsg(message);
      if (status == 200) {
        redirectToArtifactUpload();
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      showMsg(e.toString());
    }
  }
  void redirectToArtifactUpload() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ShopperBrowseBarcodeArtifactScreen(
          tagId: widget.tagId,
          storeId: widget.storeId,
        ),
      ),
    );
  }
  /// ---------------- CANCEL ----------------
  void cancelAuditDialog() {
    TextEditingController reason = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Cancel Audit", style: TextStyle(fontSize: 16)),
              TextField(
                controller: reason,
                decoration: const InputDecoration(labelText: "Reason"),
              ),
              const SizedBox(height: 10),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child:Row(
                children: [
                  Expanded(child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"),
                  )),
                  SizedBox(width: 10,),
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.orangeColor,
                        foregroundColor: Colors.white
                    ),
                    onPressed: () {
                      if (reason.text.isEmpty) {
                        showMsg("Enter valid reason");
                        return;
                      }
                      Navigator.pop(context);
                      cancelAuditOnServer(reason.text.toString());
                    },
                    child: const Text("Submit"),
                  ))

                ],
              ) ,),
              const SizedBox(height: 30,)


            ],
          ),
        );
      },
    );
  }
  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// ✅ APP BAR (modern)
      appBar: AppBar(
        title: const Text("Scan Barcode"),
        elevation: 0,
      ),

      /// ✅ BODY
      body: Column(
        children: [

          /// 🔥 STORE INFO CARD
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.storeName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.storeAddress}, ${widget.storeCity}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text("Store Code: ${widget.storeCode}"),
              ],
            ),
          ),

          /// 🔥 SHIPMENT INPUT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Shipment ID",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (v) => shipmentId = v,
            ),
          ),

          const SizedBox(height: 10),

          /// 🔥 ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: cancelAuditDialog,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: scanTracking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.themeColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Scan"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// 🔥 LIST
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text("No Data Scanned"))
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: list.length,
              itemBuilder: (_, i) {
                var item = list[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// TITLE
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.storeName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.qr_code),
                              onPressed: () =>
                                  openProduct(item.trackingId, item.fnsku),
                            )
                          ],
                        ),

                        const Divider(),

                        /// DATA
                        Text("Tracking: ${item.trackingId}"),
                        Text("FNSKU: ${item.fnsku}"),
                        Text("Unit: ${item.unit}"),
                        Text("Weight: ${item.weight}"),
                        Text("Box No: ${item.boxNo}"),
                        Text("Products: ${item.products.length}"),

                        if (item.comment.isNotEmpty)
                          Text("Comment: ${item.comment}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      /// 🔥 STICKY SUBMIT BUTTON (FIXED)
      bottomNavigationBar: list.isNotEmpty
          ? SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.orangeColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Submit"),
          ),
        ),
      )
          : null,
    );
  }
  Future<void> cancelAuditOnServer(String reason) async {

    APIDialog.showAlertDialog(context, "Please wait...");

    try {

      var body = {
        "tagging_id": widget.storeId,
        "user_id": userId,
        "cancel_reason": reason,
      };

      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPIWithHeader(
        "cancel_barcode_audit",
        body,
        context,
      );
      if (!mounted) return;
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // dismiss dialog
      }

      var jsonResponse = json.decode(response.body);

      bool success = jsonResponse["status"] == true ||
          jsonResponse["status"] == 1 ||
          jsonResponse["status"] == "1";
      String message = jsonResponse["message"]?.toString() ?? "";
      showMsg(message);

      if (success) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }

    } catch (e) {

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      showMsg(e.toString());
    }
  }
}