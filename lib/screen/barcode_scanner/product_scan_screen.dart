import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopperxm_flutter/screen/barcode_scanner/scanned_data_model_class.dart';
import '../../utils/app_theme.dart';
import 'barcode_scan_screen.dart';



class ProductScanScreen extends StatefulWidget {
  final String TrackingId;
  final String FnskuId;

  const ProductScanScreen(this.TrackingId, this.FnskuId, {super.key});

  @override
  State<ProductScanScreen> createState() => _ProductScanScreenState();
}

class _ProductScanScreenState extends State<ProductScanScreen> {

  List<ScannedProduct> list = [];

  /// ================= SCAN =================
  Future<void> scanProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BarcodeScanScreen()),
    );

    if (result == null) {
      showMsg("Unable to Scan. Please try again");
      return;
    }

    showProductDialog(result.toString());
  }

  /// ================= DIALOG =================
  void showProductDialog(String code) {
    TextEditingController weight = TextEditingController();
    TextEditingController remark = TextEditingController();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                const Text(
                  "Add Product",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                /// CODE
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(code),
                ),

                const SizedBox(height: 15),

                /// WEIGHT
                TextField(
                  controller: weight,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: "Weight",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                /// REMARK
                TextField(
                  controller: remark,
                  decoration: const InputDecoration(
                    labelText: "Remark",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                /// SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.themeColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      if (weight.text.isEmpty) {
                        showMsg("Enter weight");
                        return;
                      }

                      list.add(ScannedProduct(code, weight.text, remark.text));

                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// APPBAR
      appBar: AppBar(
        title: const Text("Scan Product"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      body: Column(
        children: [

          /// HEADER CARD
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tracking Id: ${widget.TrackingId}"),
                const SizedBox(height: 5),
                Text("FNSKU: ${widget.FnskuId}"),
              ],
            ),
          ),

          /// SCAN BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.themeColor,
                minimumSize: const Size(double.infinity, 50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: scanProduct,
              child: const Text("Scan Product"),
            ),
          ),

          const SizedBox(height: 10),

          /// LIST
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text("No Products Added"))
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final item = list[i];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(item.productId),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Weight: ${item.weight}"),
                        if (item.remark.isNotEmpty)
                          Text("Remark: ${item.remark}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        list.removeAt(i);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          /// SUBMIT BUTTON
          if (list.isNotEmpty)
            SafeArea(child: Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.orangeColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pop(context, list); // ✅ RESULT RETURN
                },
                child: const Text("Submit"),
              ),
            )),
        ],
      ),
    );
  }

  /// ================= HELPER =================
  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}