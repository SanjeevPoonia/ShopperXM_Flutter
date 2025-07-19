import 'package:shopperxm_flutter/utils/app_theme.dart';
import '../../network/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';



class WebViewPPT extends StatefulWidget
{
  final String url;
  WebViewPPT(this.url);
  PrivacyPolicyState createState()=>PrivacyPolicyState();
}
class PrivacyPolicyState extends State<WebViewPPT> {
  bool isLoading=true;
  late final WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
    /*      SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);*/

          Navigator.pop(context);


          return Future.value(false);
        },
        child: Scaffold(
          body:
          /* Stack(
            children: <Widget>[
              WebViewWidget(
                controller: _controller,
              ),

              isLoading ? Center( child: CircularProgressIndicator())
                  : Stack(),
              TermsAppBar(
                onTap: () {
                  Navigator.pop(context);
                },
                showBackIc: true,
              ),

            ],
          ),*/


          Column(
            children: [

              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                ),
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
                          child:Icon(Icons.keyboard_backspace_rounded)),


                      Text("View",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),

                      Image.asset("assets/bell_ic.png",width: 23,height: 23)


                    ],
                  ),
                ),
              ),

              Expanded(
                child:
                isLoading?
                Center(
                  child: Loader(),
                ):


                WebViewWidget(
                  controller: _controller,
                ),
              ),
            ],
          ),



        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.url);
 /*   SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);*/
    _controller = WebViewController()
    ..enableZoom(true)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading=true;
            });
          },
          onPageFinished: (String url) {

            setState(() {
              isLoading=false;
            });


          },

          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
// /initialUrl: 'https://aha-me.com/aha/terms_and_conditions',

/*JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }*/
}