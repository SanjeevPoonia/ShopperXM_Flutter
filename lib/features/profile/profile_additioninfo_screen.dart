import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';

class ProfileAdditioninfoScreen extends StatefulWidget {
  const ProfileAdditioninfoScreen({
    super.key,
  });

  @override
  State<ProfileAdditioninfoScreen> createState() =>
      _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<ProfileAdditioninfoScreen> {
  // ============================================================
  // API
  // ============================================================

  // Replace these with the same API URLs used by
  // Constant_Strings.getAddAdditionalInfo_Api()
  // Constant_Strings.getGetAdditionalInfo_Api()

  static const String addAdditionalInfoApi = 'save_freelancer_additional_details';

  static const String getAdditionalInfoApi = 'get_freelancer_additional_details';

  // ============================================================
  // SESSION
  // ============================================================

  String authKey = '';
  String userId = '';

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final preferredLocationController = TextEditingController();

  final languageKnownController = TextEditingController();

  final currentAddressLine1Controller = TextEditingController();

  final currentAddressLine2Controller =
  TextEditingController();

  final currentCityController =
  TextEditingController();

  final currentStateController =
  TextEditingController();

  final currentPinCodeController =
  TextEditingController();

  final permanentAddressLine1Controller =
  TextEditingController();

  final permanentAddressLine2Controller =
  TextEditingController();

  final permanentCityController =
  TextEditingController();

  final permanentStateController =
  TextEditingController();

  final permanentPinCodeController =
  TextEditingController();

  final whatsappNumberController =
  TextEditingController();

  final interestAreaController =
  TextEditingController();

  final industryController =
  TextEditingController();

  final companyController =
  TextEditingController();

  final spouseNameController =
  TextEditingController();

  final dobController =
  TextEditingController();

  final mobileModelController =
  TextEditingController();

  final mobileCameraController =
  TextEditingController();

  final experienceController =
  TextEditingController();

  final annualIncomeController =
  TextEditingController();

  // ============================================================
  // RADIO VALUES
  // ============================================================

  String openToTravel = '';
  String livingStatus = '';
  String carOwned = '';
  String maritalStatus = '';
  String laptopOwned = '';

  // ============================================================
  // ADDRESS
  // ============================================================

  bool sameAsCurrentAddress = false;

  String currentAddress = '';
  String permanentAddress = '';

  // ============================================================
  // DOB
  // ============================================================

  String dob = '';

  // ============================================================
  // IMAGES
  // ============================================================

  File? tenthMarksheet;
  File? twelfthMarksheet;
  File? educationCertificate;

  String aws10th = '';
  String aws12 = '';
  String awsCertificate = '';

  // ============================================================
  // LOADING
  // ============================================================

  bool isLoading = false;

  final ImagePicker imagePicker = ImagePicker();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  // ============================================================
  // SESSION
  // ============================================================

  Future<void> _loadSession() async {

    authKey = await MyUtils.getSharedPreferences("access_token") ?? "";
    userId = await MyUtils.getSharedPreferences("user_id") ?? "";

    if (authKey.isEmpty || userId.isEmpty) {
      if (!mounted) return;

      _showMessage(
        'Your Session has been Expired Please login Again.',
      );

      Navigator.pop(context);
      return;
    }

    await _getAddinalDetail();
  }

  // ============================================================
  // GET ADDITIONAL INFORMATION
  // ============================================================

  Future<void> _getAddinalDetail() async {

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {

      final helper = ApiBaseHelper();
      final response = await helper.getWithHeader(
        getAdditionalInfoApi,
        context,
      );
      final jsonObject = json.decode(response.body);
      debugPrint("Profile API Response: $jsonObject");
      int status = jsonObject['status']??0;
      String msg = jsonObject['message']?.toString()??"";
      if(status==1){
        final dataObject = jsonObject["data"];
        final otherObject = dataObject['other_detail'];
        final userObject = dataObject['user_detail'];
        final addObject = dataObject['address_info'];
        final experObject = dataObject['experience_detail'];
        final profesObject = dataObject['professional_detail'];
        final perObject = dataObject['personal_info'];


        String compName = experObject['company_name']?.toString()??'';
        String experYear = experObject['total_experience']?.toString()??'';
        String annualIncom = experObject['annual_income']?.toString()??'';
        companyController.text= compName;
        experienceController.text = experYear;
        annualIncomeController.text = annualIncom;


        String phoneName =otherObject['phone_name']?.toString()??'';
        String cameraQuality =otherObject['camera_quality']?.toString()??'';
        String havePC =otherObject['have_pc']?.toString()??'0';
        String haveVehicle =otherObject['have_vehicle']?.toString()??'0';
        mobileCameraController.text=cameraQuality;
        mobileModelController.text = phoneName;
        carOwned=haveVehicle;
        laptopOwned=havePC;


        String matStatus = perObject['marital_status']?.toString()??'0';
        maritalStatus=matStatus;
        String db = perObject['dob']?.toString()??'';
        dobController.text= db;
        String opToT = otherObject['open_to_travel']?.toString()??'0';
        openToTravel = opToT;

        String languageSpoken=userObject['language_spoken']?.toString()??'';
        languageKnownController.text = languageSpoken;
        String livStatus = userObject['living_status']?.toString()??'';
        livingStatus=livStatus;

        String currAddress=addObject['current_address']?.toString()??'';
        String perAddress = addObject['permanent_address']?.toString()??'';


        parseAddress(
            currAddress,
            line1Controller: currentAddressLine1Controller,
            cityController: currentCityController,
            stateController: currentStateController,
            pinCodeController: currentPinCodeController);

        parseAddress(
            perAddress,
            line1Controller: permanentAddressLine1Controller,
            cityController: permanentCityController,
            stateController: permanentStateController,
            pinCodeController: permanentPinCodeController);











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

  void parseAddress(
      String address, {
        required TextEditingController line1Controller,
        required TextEditingController cityController,
        required TextEditingController stateController,
        required TextEditingController pinCodeController,
      }) {
    final parts = address.split(',');

    if (parts.length <= 2) {
      return;
    }

    final city = parts[parts.length - 2].trim();
    final statePin = parts[parts.length - 1].trim();

    // Everything before City and State(PIN) is Address Line 1
    final addressLine1 = parts
        .sublist(0, parts.length - 2)
        .map((e) => e.trim())
        .join(',');

    line1Controller.text = addressLine1;
    cityController.text = city;

    // Example: Rajasthan(302012)
    final statePinParts = statePin.split('(');

    if (statePinParts.length > 1) {
      final state = statePinParts[0].trim();
      final pin = statePinParts[1]
          .replaceAll(')', '')
          .trim();

      stateController.text = state;
      pinCodeController.text = pin;
    }
  }


  // ============================================================
  // PARSE GET RESPONSE
  // ============================================================

  void _parseAdditionalInfo(String responseBody) {

    debugPrint(
      'Additional Info Response: $responseBody',
    );


  }

  // ============================================================
  // RADIO MAPPING
  // ============================================================

  void setOpenToTravel(String value) {
    setState(() {
      if (value == 'Yes') {
        openToTravel = '1';
      } else {
        openToTravel = '0';
      }
    });
  }

  void setLivingStatus(String value) {
    setState(() {
      if (value == 'Rental') {
        livingStatus = '2';
      } else {
        livingStatus = '1';
      }
    });
  }

  void setCarOwned(String value) {
    setState(() {
      if (value == 'Yes') {
        carOwned = '1';
      } else {
        carOwned = '0';
      }
    });
  }

  void setLaptopOwned(String value) {
    setState(() {
      if (value == 'Yes') {
        laptopOwned = '1';
      } else {
        laptopOwned = '0';
      }
    });
  }

  void setMaritalStatus(String value) {
    setState(() {
      if (value == 'Married') {
        maritalStatus = '1';
      } else {
        maritalStatus = '0';

        spouseNameController.clear();
      }
    });
  }

  // ============================================================
  // SAME AS CURRENT ADDRESS
  // ============================================================

  void setSameAsCurrentAddress(bool value) {
    setState(() {
      sameAsCurrentAddress = value;

      if (value) {
        permanentAddressLine1Controller.text =
            currentAddressLine1Controller.text;

        permanentAddressLine2Controller.text =
            currentAddressLine2Controller.text;

        permanentCityController.text =
            currentCityController.text;

        permanentStateController.text =
            currentStateController.text;

        permanentPinCodeController.text =
            currentPinCodeController.text;
      }
    });
  }

  // ============================================================
  // ADDRESS LISTENERS
  // ============================================================

  void _syncPermanentAddress() {
    if (!sameAsCurrentAddress) return;

    permanentAddressLine1Controller.text =
        currentAddressLine1Controller.text;

    permanentAddressLine2Controller.text =
        currentAddressLine2Controller.text;

    permanentCityController.text =
        currentCityController.text;

    permanentStateController.text =
        currentStateController.text;

    permanentPinCodeController.text =
        currentPinCodeController.text;
  }

  // ============================================================
  // COMBINE ADDRESS
  // ============================================================

  void _combineAddress() {
    String current = currentAddressLine1Controller.text.trim();

    if (currentAddressLine2Controller.text.trim().isNotEmpty) {
      current +=
      ',${currentAddressLine2Controller.text.trim()}';
    }

    current +=
    ',${currentCityController.text.trim()}'
        ',${currentStateController.text.trim()}'
        '(${currentPinCodeController.text.trim()})';

    currentAddress = current;

    String permanent =
    permanentAddressLine1Controller.text.trim();

    if (permanentAddressLine2Controller.text
        .trim()
        .isNotEmpty) {
      permanent +=
      ',${permanentAddressLine2Controller.text.trim()}';
    }

    permanent +=
    ',${permanentCityController.text.trim()}'
        ',${permanentStateController.text.trim()}'
        '(${permanentPinCodeController.text.trim()})';

    permanentAddress = permanent;
  }

  // ============================================================
  // DOB
  // ============================================================

  Future<void> _selectDob() async {
    final now = DateTime.now();

    // Same as Java:
    // Calendar.getInstance();
    // cldr.add(Calendar.YEAR, -18);

    final maximumDate = DateTime(
      now.year - 18,
      now.month,
      now.day,
    );

    final initialDate = DateTime(
      now.year - 25,
      now.month,
      now.day,
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: maximumDate,
    );

    if (picked == null) return;

    final day =
    picked.day.toString().padLeft(2, '0');

    final month =
    picked.month.toString().padLeft(2, '0');

    final year =
    picked.year.toString();

    setState(() {
      dob = '$day-$month-$year';
      dobController.text = dob;
    });
  }

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  Future<void> _pickImage(int type) async {
    try {
      final XFile? selected =
      await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (selected == null) return;

      final file = File(selected.path);

      setState(() {
        if (type == 1) {
          tenthMarksheet = file;
        } else if (type == 2) {
          twelfthMarksheet = file;
        } else if (type == 3) {
          educationCertificate = file;
        }
      });

      /*
       * Java implementation uploads immediately after
       * selecting the image.
       */
      await _uploadImageToS3(
        file: file,
        type: type,
      );
    } catch (e) {
      debugPrint(
        'Image selection error: $e',
      );

      _showMessage(
        'Error!! Unable to browse Image',
      );
    }
  }

  // ============================================================
  // S3 UPLOAD
  // ============================================================

  Future<void> _uploadImageToS3({
    required File file,
    required int type,
  }) async {
    /*
     * Your Java implementation:
     *
     * bucket       = awsBucketName
     * region       = AP_SOUTH_1
     * directory    = images/kyc/
     *
     * Filename:
     *
     * userId + image_10th + timestamp + s3 + extension
     * userId + image_12th + timestamp + s3 + extension
     * userId + image_certificate + timestamp + extension
     *
     * The AWS credentials should come from your Flutter
     * SessionManager equivalent.
     */

    final prefs = await SharedPreferences.getInstance();

    final bucket =
        prefs.getString('aws_bucket') ?? '';

    final accessKey =
        prefs.getString('aws_key') ?? '';

    final secretKey =
        prefs.getString('aws_secret') ?? '';

    final baseUrl =
        prefs.getString('aws_base_url') ?? '';

    if (bucket.isEmpty ||
        accessKey.isEmpty ||
        secretKey.isEmpty) {
      _showMessage(
        'AWS configuration not found.',
      );
      return;
    }

    /*
     * IMPORTANT:
     *
     * Do not put real AWS credentials directly into
     * this Dart file.
     *
     * The actual S3 call should be implemented using
     * your project's existing AWS configuration.
     */

    final timestamp =
        DateTime.now().millisecondsSinceEpoch;

    final extension =
        file.path.split('.').last;

    String fileName;

    if (type == 1) {
      fileName =
      '${userId}image_10th${timestamp}s3.$extension';
    } else if (type == 2) {
      fileName =
      '${userId}image_12th${timestamp}s3.$extension';
    } else {
      fileName =
      '${userId}image_certificate${timestamp}s3.$extension';
    }

    final fileKey =
        'images/kyc/$fileName';

    debugPrint(
      'S3 File Key: $fileKey',
    );

    /*
     * Add your S3 upload implementation here.
     *
     * After successful upload:
     *
     * if (type == 1) {
     *   aws10th = '$baseUrl/$fileKey';
     * }
     *
     * if (type == 2) {
     *   aws12 = '$baseUrl/$fileKey';
     * }
     *
     * if (type == 3) {
     *   awsCertificate = '$baseUrl/$fileKey';
     * }
     */

    if (type == 1) {
      aws10th = '$baseUrl/$fileKey';
    } else if (type == 2) {
      aws12 = '$baseUrl/$fileKey';
    } else {
      awsCertificate = '$baseUrl/$fileKey';
    }

    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // VALIDATION
  // ============================================================
  bool _checkUpdateValidation() {
    final preferred =
    preferredLocationController.text.trim();

    final language =
    languageKnownController.text.trim();

    final currentLine1 =
    currentAddressLine1Controller.text.trim();

    final currentCity =
    currentCityController.text.trim();

    final currentState =
    currentStateController.text.trim();

    final currentPin =
    currentPinCodeController.text.trim();

    final permanentLine1 =
    permanentAddressLine1Controller.text.trim();

    final permanentCity =
    permanentCityController.text.trim();

    final permanentState =
    permanentStateController.text.trim();

    final permanentPin =
    permanentPinCodeController.text.trim();

    final whatsapp =
    whatsappNumberController.text.trim();

    final interest =
    interestAreaController.text.trim();

    final industry =
    industryController.text.trim();

    final company =
    companyController.text.trim();

    final mobile =
    mobileModelController.text.trim();

    final camera =
    mobileCameraController.text.trim();

    final experience =
    experienceController.text.trim();

    final income =
    annualIncomeController.text.trim();

    // ------------------------------------------------------------
    // Preferred Location
    // ------------------------------------------------------------

    if (preferred.length != 6) {
      _showMessage(
        'Please enter valid(6 Digit) Preferred Location pin code',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Open To Travel
    // ------------------------------------------------------------

    if (openToTravel.isEmpty) {
      _showMessage(
        'Please select, are you Open to Travel',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Language
    // ------------------------------------------------------------

    if (language.length <= 3) {
      _showMessage(
        'Please enter at least one known language',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Living Status
    // ------------------------------------------------------------

    if (livingStatus.isEmpty) {
      _showMessage(
        'Please select your living Status',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Current Address
    // ------------------------------------------------------------

    if (currentLine1.length <= 5) {
      _showMessage(
        'Please Enter current Address Line1',
      );
      return false;
    }

    if (currentCity.length <= 2) {
      _showMessage(
        'Please Enter current Address City',
      );
      return false;
    }

    if (currentState.length <= 2) {
      _showMessage(
        'Please Enter current Address State',
      );
      return false;
    }

    if (currentPin.length != 6) {
      _showMessage(
        'Please Enter valid(6 Digits) current address pin code',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Permanent Address
    // ------------------------------------------------------------

    if (permanentLine1.length <= 5) {
      _showMessage(
        'Please Enter permanent Address Line1',
      );
      return false;
    }

    if (permanentCity.length <= 2) {
      _showMessage(
        'Please Enter Permanent Address City',
      );
      return false;
    }

    if (permanentState.length <= 2) {
      _showMessage(
        'Please Enter Permanent Address State',
      );
      return false;
    }

    if (permanentPin.length != 6) {
      _showMessage(
        'Please Enter valid(6 Digits) Permanent address pin code',
      );
      return false;
    }

    // ------------------------------------------------------------
    // WhatsApp
    // ------------------------------------------------------------

    if (whatsapp.length != 10) {
      _showMessage(
        'Please Enter valid 10 digit WhatsApp Number',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Interest Area
    // ------------------------------------------------------------

    if (interest.length <= 2) {
      _showMessage(
        'Please Enter valid Interested Area',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Industry
    // ------------------------------------------------------------

    if (industry.length <= 2) {
      _showMessage(
        'Please Enter valid Industry',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Company
    // ------------------------------------------------------------

    if (company.length <= 2) {
      _showMessage(
        'Please Enter valid Company Name',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Car
    // ------------------------------------------------------------

    if (carOwned.isEmpty) {
      _showMessage(
        'Please select, are you owned car',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Marital Status
    // ------------------------------------------------------------

    if (maritalStatus.isEmpty) {
      _showMessage(
        'Please select your Marital Status',
      );
      return false;
    }

    if (maritalStatus == '1') {
      if (spouseNameController.text.trim().length <= 2) {
        _showMessage(
          'Please Enter your Spouse Name',
        );
        return false;
      }
    }

    // ------------------------------------------------------------
    // DOB
    // ------------------------------------------------------------

    if (dob.isEmpty) {
      _showMessage(
        'Please select, Your date of Birth',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Laptop
    // ------------------------------------------------------------

    if (laptopOwned.isEmpty) {
      _showMessage(
        'Please select, are you owned laptop',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Mobile
    // ------------------------------------------------------------

    if (mobile.length <= 2) {
      _showMessage(
        'Please Enter valid Mobile Model Name',
      );
      return false;
    }

    if (camera.isEmpty) {
      _showMessage(
        'Please Enter Your mobile camera Resolution',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Education Images
    // ------------------------------------------------------------

    if (aws10th.isEmpty) {
      _showMessage(
        'Please upload your 10th Mark sheet Image',
      );
      return false;
    }

    if (aws12.isEmpty) {
      _showMessage(
        'Please upload your 12th Mark sheet Image',
      );
      return false;
    }

    if (awsCertificate.isEmpty) {
      _showMessage(
        'Please upload your Education certificate Image',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Experience
    // ------------------------------------------------------------

    if (experience.isEmpty) {
      _showMessage(
        'Please Enter your total experience in years',
      );
      return false;
    }

    // ------------------------------------------------------------
    // Income
    // ------------------------------------------------------------

    if (income.isEmpty) {
      _showMessage(
        'Please Enter your total annually Income',
      );
      return false;
    }

    return true;
  }
  // ============================================================
  // UPDATE
  // ============================================================
  Future<void> _updateAdditionalInfo() async {
    if (!_checkUpdateValidation()) {
      return;
    }

    _combineAddress();

    await _addAdditionalInfo();
  }

  // ============================================================
  // POST ADDITIONAL INFO
  // ============================================================

  Future<void> _addAdditionalInfo() async {
    if (addAdditionalInfoApi == 'YOUR_ADD_ADDITIONAL_INFO_API') {
      _showMessage(
        'Add Additional Info API is not configured.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final body = {
        'user_id': userId,
        'preferred_city_id':
        preferredLocationController.text.trim(),
        'open_to_travel':
        openToTravel,
        'language_known':
        languageKnownController.text.trim(),
        'living_status':
        livingStatus,
        'current_address':
        currentAddress,
        'permanent_address':
        permanentAddress,
        'whatsapp_number':
        whatsappNumberController.text.trim(),
        'interested_area':
        interestAreaController.text.trim(),
        'company':
        companyController.text.trim(),
        'car_owned':
        carOwned,
        'material_status':
        maritalStatus,
        'spouse_name':
        spouseNameController.text.trim(),
        'date_of_birth':
        dob,
        'laptop_owned':
        laptopOwned,
        'mobile_model':
        mobileModelController.text.trim(),
        'mobile_camera':
        mobileCameraController.text.trim(),
        'file_marksheet_10':
        aws10th,
        'file_marksheet_12':
        aws12,
        'file_education_certificate':
        awsCertificate,
        'experience_years':
        experienceController.text.trim(),
        'annually_income':
        annualIncomeController.text.trim(),
      };

      debugPrint(
        'Additional Info Request: $body',
      );


      final helper = ApiBaseHelper();
      final response = await helper.postAPIWithHeader(addAdditionalInfoApi, body, context);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      debugPrint(
        'Add Additional Info Response: ${response.body}',
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        _showMessage(
          'Additional information updated successfully.',
        );

        Navigator.pop(context);
      } else {
        _showMessage(
          'Unable to update additional information.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint(
        'addAdditionalInfo error: $e',
      );

      _showMessage(
        'Something went wrong. Please try again.',
      );
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    preferredLocationController.dispose();
    languageKnownController.dispose();

    currentAddressLine1Controller.dispose();
    currentAddressLine2Controller.dispose();
    currentCityController.dispose();
    currentStateController.dispose();
    currentPinCodeController.dispose();

    permanentAddressLine1Controller.dispose();
    permanentAddressLine2Controller.dispose();
    permanentCityController.dispose();
    permanentStateController.dispose();
    permanentPinCodeController.dispose();

    whatsappNumberController.dispose();
    interestAreaController.dispose();
    industryController.dispose();
    companyController.dispose();
    spouseNameController.dispose();
    dobController.dispose();

    mobileModelController.dispose();
    mobileCameraController.dispose();

    experienceController.dispose();
    annualIncomeController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Additional Info',
        ),
      ),

      body: Stack(
        children: [
          _buildForm(),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // FORM
  // ============================================================

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: 30,
      ),
      child: Column(
        children: [
          _textField(
            'Preferred Location(PIN CODE)',
            preferredLocationController,
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),

          _radioGroup(
            title: 'Open To Travel',
            options: const [
              'Yes',
              'No',
            ],
            selected: openToTravel == '1'
                ? 'Yes'
                : openToTravel == '0'
                ? 'No'
                : null,
            onChanged: setOpenToTravel,
          ),

          _textField(
            'Language Known',
            languageKnownController,
          ),

          _radioGroup(
            title: 'Living Status',
            options: const [
              'Own House',
              'Rental',
            ],
            selected: livingStatus == '1'
                ? 'Own House'
                : livingStatus == '2'
                ? 'Rental'
                : null,
            onChanged: setLivingStatus,
          ),

          _sectionTitle('Current Address'),

          _textField(
            'Address Line1',
            currentAddressLine1Controller,
            onChanged: (_) {
              _syncPermanentAddress();
            },
          ),

          _textField(
            'Address Line2',
            currentAddressLine2Controller,
            onChanged: (_) {
              _syncPermanentAddress();
            },
          ),

          _textField(
            'City',
            currentCityController,
            onChanged: (_) {
              _syncPermanentAddress();
            },
          ),

          _textField(
            'State',
            currentStateController,
            onChanged: (_) {
              _syncPermanentAddress();
            },
          ),

          _textField(
            'Pin Code',
            currentPinCodeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: (_) {
              _syncPermanentAddress();
            },
          ),

          _buildPermanentAddressHeader(),

          _textField(
            'Address Line1',
            permanentAddressLine1Controller,
          ),

          _textField(
            'Address Line2',
            permanentAddressLine2Controller,
          ),

          _textField(
            'City',
            permanentCityController,
          ),

          _textField(
            'State',
            permanentStateController,
          ),

          _textField(
            'Pin Code',
            permanentPinCodeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),

          _textField(
            'WhatsApp Number',
            whatsappNumberController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),

          _textField(
            'Interest Area',
            interestAreaController,
          ),

          _textField(
            'Industry',
            industryController,
          ),

          _textField(
            'Company',
            companyController,
          ),

          _radioGroup(
            title: 'Car Owned',
            options: const [
              'Yes',
              'No',
            ],
            selected: carOwned == '1'
                ? 'Yes'
                : carOwned == '0'
                ? 'No'
                : null,
            onChanged: setCarOwned,
          ),

          _radioGroup(
            title: 'Marital Status',
            options: const [
              'Single',
              'Married',
            ],
            selected: maritalStatus == '0'
                ? 'Single'
                : maritalStatus == '1'
                ? 'Married'
                : null,
            onChanged: setMaritalStatus,
          ),

          if (maritalStatus == '1')
            _textField(
              'Spouse Name',
              spouseNameController,
            ),

          _textField(
            'Date Of Birth',
            dobController,
            readOnly: true,
            onTap: _selectDob,
          ),

          _radioGroup(
            title: 'Laptop Owned',
            options: const [
              'Yes',
              'No',
            ],
            selected: laptopOwned == '1'
                ? 'Yes'
                : laptopOwned == '0'
                ? 'No'
                : null,
            onChanged: setLaptopOwned,
          ),

          _textField(
            'Mobile Model Name',
            mobileModelController,
          ),

          _textField(
            'Mobile Camera Resolution',
            mobileCameraController,
          ),

          _sectionTitle('Education Details'),

          _document(
            title: '10th Marksheet',
            file: tenthMarksheet,
            onBrowse: () {
              _pickImage(1);
            },
          ),

          _document(
            title: '12th Marksheet',
            file: twelfthMarksheet,
            onBrowse: () {
              _pickImage(2);
            },
          ),

          _document(
            title: 'Education Certificate',
            file: educationCertificate,
            onBrowse: () {
              _pickImage(3);
            },
          ),

          _sectionTitle('Experience Details'),

          _textField(
            'Experience(Number Of Years)',
            experienceController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),

          _textField(
            'Annually Income',
            annualIncomeController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : _updateAdditionalInfo,
                child: const Text(
                  'UPDATE',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PERMANENT ADDRESS HEADER
  // ============================================================

  Widget _buildPermanentAddressHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Permanent Address',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Checkbox(
            value: sameAsCurrentAddress,
            onChanged: (value) {
              setSameAsCurrentAddress(
                value ?? false,
              );
            },
          ),

          const Text(
            'Same as current address',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _textField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType =
            TextInputType.text,
        int? maxLength,
        bool readOnly = false,
        VoidCallback? onTap,
        ValueChanged<String>? onChanged,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 7,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          counterText: '',
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // ============================================================
  // RADIO GROUP
  // ============================================================

  Widget _radioGroup({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),

          Row(
            children: options.map((option) {
              return Expanded(
                child: RadioListTile<String>(
                  contentPadding:
                  EdgeInsets.zero,
                  dense: true,
                  title: Text(option),
                  value: option,
                  groupValue: selected,
                  onChanged: (value) {
                    if (value != null) {
                      onChanged(value);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // DOCUMENT
  // ============================================================

  Widget _document({
    required String title,
    required File? file,
    required VoidCallback onBrowse,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius:
              BorderRadius.circular(6),
            ),
            child: file == null
                ? const Center(
              child: Icon(
                Icons.image,
                size: 60,
                color: Colors.grey,
              ),
            )
                : Image.file(
              file,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 5),

          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: onBrowse,
              child: const Text(
                'Browse',
              ),
            ),
          ),
        ],
      ),
    );
  }
}