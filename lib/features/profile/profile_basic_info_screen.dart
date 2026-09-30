import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../network/api_helper.dart';

class ProfileBasicInfoScreen extends StatefulWidget{
  _ShopperBasicDetailScreenState createState()=>_ShopperBasicDetailScreenState();
}
class _ShopperBasicDetailScreenState extends State<ProfileBasicInfoScreen> {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  String countryCode = "+91";
  String countryName = "India";



  String firstName="";
  String lastName="";
  String mobileNumber="";
  String emailStr="";


  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProfileFromServer();
  }





  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }








  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Basic Information")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildField(firstName, firstNameController, "First Name"),
                buildField(lastName, lastNameController, "Last Name"),
                // 🔥 Country Picker + Mobile
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (code) {
                        countryCode = code.dialCode ?? "+91";
                        countryName = code.name ?? "India";
                      },
                      initialSelection: 'IN',
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                    ),
                    Expanded(
                      child: buildField(
                        mobileNumber,
                        mobileController,
                        "Mobile Number",
                        type: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                buildField(emailStr,emailController, "Email", type: TextInputType.emailAddress),
                const SizedBox(height: 20),
                /*ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // 🔶 background color
                    foregroundColor: Colors.white,  // ⚪ text color
                  ),
                  onPressed: () {
                    if (validate()) {
                      addBasicDetailsSignup();
                    }
                  },
                  child: const Text("Next"),
                )*/
              ],
            ),
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
  Widget buildField(String value,TextEditingController controller, String hint,
      {TextInputType type = TextInputType.text, bool obscure = false}) {
    controller.text=value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        enabled: false,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }


  // =============================get Basic Profile ======================

  Future<void> getProfileFromServer() async {

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {

      final helper = ApiBaseHelper();
      final response = await helper.getWithHeader(
        "get_freelancer_data",
        context,
      );
      final jsonObject = json.decode(response.body);
      debugPrint("Profile API Response: $jsonObject");
      int status = jsonObject['status']??0;
      String msg = jsonObject['message']?.toString()??"";
      if(status==1){
        final dataObject = jsonObject["data"];
        String id = dataObject['id']?.toString()??'';
        emailStr = dataObject['email']?.toString()??'';
        mobileNumber = dataObject['mobile_no']?.toString()??'';
        final userObject = dataObject["user_detail"];
        String firstN = userObject['first_name']?.toString()??'';
        String lastN = userObject['last_name']?.toString()??'';

        final basicObject =dataObject ['basic_info'];
        String fullName = basicObject['full_name']?.toString()??'';
        if(firstN.isNotEmpty){
          firstName = firstN;
        }
        if(lastN.isNotEmpty){
          lastName = lastN;
        }
        if(firstName.isEmpty && lastName.isEmpty){
          List<String> parts = fullName.split(" ");
          if(parts.length>=2){
            firstName = parts[0];
            lastName = parts[1];
          }else{
            firstName = parts[0];
          }
        }
      }else{
        Toast.show(
          jsonObject["message"]?.toString() ??
              "Unable to load profile",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      }


    } catch (e) {

      debugPrint(
        "getProfileFromServer error: $e",
      );

      if (mounted) {
        Toast.show(
          "Error! Something went wrong. Please try again.",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      }

    } finally {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


}
