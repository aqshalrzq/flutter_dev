import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final GlobalKey webKey = GlobalKey();
  InAppWebViewController webViewController;
  PullToRefreshController refreshControl;

  double progress = 0;
  String flutterDevURL = "https://flutter.dev/";

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
      android: AndroidInAppWebViewOptions(
          initialScale: 100,
          useShouldInterceptRequest: true,
          useHybridComposition: true),
      crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false));

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi) {
        dialogConnectInternet();
        componentSnackBarOnline();

        refreshControl = PullToRefreshController(
            options: PullToRefreshOptions(
                color: Colors.lightBlue, backgroundColor: Colors.blue[800]),
            onRefresh: () async {
              if (Platform.isAndroid) {
                webViewController.reload();
              } else if (Platform.isIOS) {
                webViewController.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController.getUrl()));
              }
            });
      } else if (result == ConnectivityResult.mobile) {
        dialogConnectInternet();
        componentSnackBarOnline();

        refreshControl = PullToRefreshController(
            options: PullToRefreshOptions(
                color: Colors.lightBlue, backgroundColor: Colors.blue[800]),
            onRefresh: () async {
              if (Platform.isAndroid) {
                webViewController.reload();
              } else if (Platform.isIOS) {
                webViewController.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController.getUrl()));
              }
            });
      } else {
        dialogNoConnectInternet();
        componentSnackBarOffline();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: StreamBuilder<ConnectivityResult>(
              stream: Connectivity().onConnectivityChanged,
              builder: (_, snapshot) => snapshot.hasData
                  ? showConnectionStatus(snapshot.data)
                  : Text(
                      'Checking your connection . . .',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Column showConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi) {
      print(result.runtimeType);
      return stateConnectionInternet();
    } else if (result == ConnectivityResult.mobile) {
      print(result.runtimeType);
      return stateConnectionInternet();
    } else {
      print(result.runtimeType);
      return stateNoConnectionInternet();
    }
  }

  Column stateNoConnectionInternet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Oops!\nYour device is not connected to the internet.\n Please connect your device with internet!',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Warm greetings form @aqshalrzq',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Column stateConnectionInternet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                key: webKey,
                initialUrlRequest: URLRequest(url: Uri.parse(flutterDevURL)),
                initialOptions: options,
                pullToRefreshController: refreshControl,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.flutterDevURL = url.toString();
                  });
                },
                onLoadStop: (controller, url) async {
                  refreshControl.endRefreshing();
                  setState(() {
                    this.flutterDevURL = url.toString();
                  });
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    refreshControl.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  setState(() {
                    this.flutterDevURL = url.toString();
                  });
                },
              ),
              progress < 1.0
                  ? LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.blue[800],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                    )
                  : Center(),
            ],
          ),
        )
      ],
    );
  }

  componentSnackBarOffline() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.lightBlue,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Text(
        'Your device not connected internet',
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400, color: Colors.white, fontSize: 14),
      ),
    ));
  }

  dialogNoConnectInternet() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Flutter.dev Clone",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
                      child: Text(
                        'Your device is not connected to the internet. Please connect with internet to enjoy Flutter.dev Clone app!',
                        maxLines: 8,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, "Cancel!");
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(28),
                            bottomRight: Radius.circular(28)),
                      ),
                      child: Text(
                        "OK, Saya Mengerti!",
                        style:
                            GoogleFonts.lato(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  componentSnackBarOnline() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.lightBlue,
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Text(
        'Your device connected internet',
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400, color: Colors.white, fontSize: 14),
      ),
    ));
  }

  dialogConnectInternet() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Flutter.dev Clone",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
                      child: Text(
                        'Your device is connected to the internet. Enjoy the Flutter.dev Clone app!',
                        maxLines: 8,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, "Cancel!");
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(28),
                            bottomRight: Radius.circular(28)),
                      ),
                      child: Text(
                        "OK, Saya Mengerti!",
                        style:
                            GoogleFonts.lato(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<bool> onBackPressed() async {
    var status = await webViewController.canGoBack();
    if (status) {
      webViewController.goBack();
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 1,
              contentPadding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(
                'Flutter.dev Clone',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              content: Text(
                'Danger! You are now almost leaving this app. Are you sure you want to leave and exit the Flutter.dev clone?',
                textAlign: TextAlign.justify,
                maxLines: 8,
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontSize: 14),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text(
                    'No!'.toUpperCase(),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(color: Colors.lightBlue))),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text(
                    'Yes!'.toUpperCase(),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Colors.lightBlue,
                        fontSize: 14),
                  ),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(color: Colors.lightBlue))),
                  ),
                ),
              ],
            );
          });
    }
  }
}
