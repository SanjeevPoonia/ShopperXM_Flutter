
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:shopperxm_flutter/utils/app_theme.dart';
import '../../network/loader.dart';

class ViewPDFScreen extends StatefulWidget
{
  final String url;
  ViewPDFScreen(this.url);
  PrivacyPolicyState createState()=>PrivacyPolicyState();
}
class PrivacyPolicyState extends State<ViewPDFScreen> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:



        Column(
          children: [

            Container(
              height: 57,
              color: AppTheme.themeColor,
              child: Row(
                children: [
                  SizedBox(width: 8),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white)),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          'Training',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                              color: Colors.white.withOpacity(0.9)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 36),
                ],
              ),
            ),

            Expanded(
              child:
              isLoading?
                  Center(
                    child: Loader(),
                  ):


              Container(
                color: Colors.white,
                  child: SfPdfViewer.network(
                 widget.url))
            ),
          ],
        ),






      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

}
