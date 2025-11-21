// ignore_for_file: avoid_print, prefer_final_fields, unused_field, prefer_typing_uninitialized_variables, unused_element, override_on_non_overriding_member
import 'dart:html' as html;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secure_app/Encryption-Decryption/AES-CBC.dart';
import 'package:secure_app/Widgets/NavBar.dart';
import 'package:secure_app/Widgets/Style.dart';
import 'package:secure_app/Widgets/isLoading.dart';
import 'package:secure_app/Utility/customProvider.dart';
import 'package:secure_app/Utility/dioSingleton.dart';
import 'package:secure_app/Screens/endorsementForm.dart';
// import 'package:secure_app/Screens/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'dart:typed_data';

class InwardStatus2 extends StatefulWidget {
  const InwardStatus2({super.key});

  @override
  State<InwardStatus2> createState() => _InwardStatus2State();
}

class _InwardStatus2State extends State<InwardStatus2> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _currentIndex1 = 0;
  var queryData;
  var widgetArray = [];
  List proposalData = [];
  Map status = {
    "Proposal Sourced": 0,
    "Discrepancy": 0,
    "Declined": 0,
    "Completed": 0,
    "totalCount": 6
  };
  String proposalID = '';
  String statusOfID = '';
  bool _isSearching = false;
  final _controller = SearchController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Dio dio = DioSingleton.dio;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProposalDetails();
    setState(() {
      widgetArray = [];
    });
  }

  int _selectedIndex = 0;

  List _searchResult = [];

  void _search(String query) {
    _searchResult.clear();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }
    final String lowerCaseQuery = query.toLowerCase();
    _searchResult = proposalData.where((proposalData) {
      return proposalData['id']
              .toString()
              .toLowerCase()
              .contains(lowerCaseQuery) ||
          proposalData['customer_name']
              .toLowerCase()
              .contains(lowerCaseQuery) ||
          proposalData['status'].toLowerCase().contains(lowerCaseQuery);
    }).toList();
    setState(() {});
  }

  getProposalDetails() async {
    setState(() {
      isLoading = true;
    });
    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };

    try {
      final response2 = await dio.get(
          'https://uatcld.sbigeneral.in/SecureApp/proposalDetails',
          options: Options(headers: headers));
      print(response2.data);
      String decryptedData = aesCbcDecryptJson(response2.data);
      print(decryptedData);

      var data = jsonDecode(decryptedData);
      print(data);
      setState(() {
        proposalData = data['proposalDetails'].reversed.toList();
      });
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Technical Error!"),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
    }
  }

  static void downloadFile(String url, String fileName) {
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final EndorsementDataSource dataSource = EndorsementDataSource(
        _isSearching ? _searchResult : proposalData, context);
    return Stack(
      children: [
        Scaffold(
          appBar: NavBar.appBar(),
          body: Stack(
            children: [
              Style.background(context),
              SingleChildScrollView(
                child: Column(
                  children: [
                    NavBar.header(context, "", () => {}),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Wrap(
                              runSpacing: 15,
                              alignment: WrapAlignment.spaceBetween,
                              runAlignment: WrapAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 1050,
                                  height: 40,
                                  child: SearchBar(
                                      controller: _controller,
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Set border radius for rectangular shape
                                        ),
                                      ),
                                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                                          EdgeInsets.symmetric(
                                              horizontal: 15.0)),
                                      hintText: 'Inward No/Customer Name',
                                      hintStyle:
                                          const MaterialStatePropertyAll<TextStyle>(
                                              TextStyle(fontSize: 13)),
                                      elevation:
                                          const MaterialStatePropertyAll(15),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255)),
                                      surfaceTintColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255)),
                                      // onTap: () {
                                      //   _controller.openView();
                                      // },
                                      onChanged: (query) {
                                        // _controller.openView();
                                        setState(() {
                                          _isSearching = true;
                                        });

                                        _search(query);
                                      },
                                      trailing: <Widget>[
                                        IconButton(
                                            onPressed: () {},
                                            icon: ShaderMask(
                                              shaderCallback: _linearGradient,
                                              child: const Icon(
                                                Icons.search,
                                                size: 24,
                                              ),
                                            ))
                                      ]),
                                ),
                                // SizedBox(
                                //   width: MediaQuery.of(context).size.width * 0.01,
                                // ),
                                Container(
                                  width: 230,
                                  height: 40,
                                  // margin: const EdgeInsets.only(right: 15),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          elevation:
                                              const MaterialStatePropertyAll(
                                                  15),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255, 255, 255, 255)),
                                          surfaceTintColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255, 255, 255, 255)),
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  10), // Set border radius for rectangular shape
                                            ),
                                          )),
                                      onPressed: () {
                                        // Navigator.pushNamed(
                                        //     context, '/createForm');
                                        // Navigator.of(context)
                                        //     .push(_createRoute(const MyForm()));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyForm()),
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ShaderMask(
                                            shaderCallback: _linearGradient,
                                            child: const Icon(
                                              Icons.library_add,
                                              size: 16,
                                            ),
                                          ),
                                          const Wrap(children: [
                                            Text('Add Inward',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        176, 34, 204, 1),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                          ])
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                          _height(),
                          _height(),
                          Container(
                            height: 400,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      //  Color.fromRGBO(231, 181, 229, 0.9),
                                      Color.fromRGBO(16, 47, 184, 0.25),
                                  blurRadius: 5.0, // soften the shadow
                                  spreadRadius: 1.0, //extend the shadow
                                  offset: Offset(
                                    5.0, // Move to right 5  horizontally
                                    5.0, // Move to bottom 5 Vertically
                                  ),
                                ),
                              ],
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Theme(
                              data: ThemeData(
                                  cardTheme: CardTheme(
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                // shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                // elevation: 15
                              )),
                              child: PaginatedDataTable(
                                rowsPerPage: 6, // Number of rows per page
                                onPageChanged: (startIndex) {
                                  print(
                                      "Showing data starting from index $startIndex");
                                  // getProposalDetails(startIndex);
                                },
                                dataRowHeight: 42,
                                // headingRowColor: MaterialStateProperty.all(
                                //   const Color.fromRGBO(176, 34, 204, 0.6),
                                // ),

                                columns: [
                                  DataColumn(label: _gradientText('Inward No')),
                                  DataColumn(
                                      label: _gradientText('Customer Name')),

                                  DataColumn(label: _gradientText('Product')),
                                  // DataColumn(
                                  //     label: _gradientText('Request Type')),

                                  // DataColumn(
                                  //     label: _gradientText('Premium Amount')),
                                  DataColumn(
                                      label: _gradientText('Payment Status')),
                                  // DataColumn(label: _gradientText('Inward Type')),
                                  DataColumn(
                                      label: _gradientText('Form Status')),
                                  DataColumn(label: _gradientText('Actions')),
                                ],
                                source: dataSource,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        isLoading
            ? const LoadingPage(
                label: "Loading Data",
              )
            : Container()
      ],
    );
  }

  _height() {
    return const SizedBox(
      height: 15,
    );
  }

  Shader _linearGradient(Rect bounds) {
    return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.purpleAccent,
          Colors.blueAccent,
        ]).createShader(bounds);
  }

  _gradientText(text) {
    return GradientText(
      text,
      colors: const [
        Color.fromRGBO(143, 19, 168, 1),
        Color.fromRGBO(143, 19, 168, 1),
      ],
      gradientType: GradientType.linear,
      gradientDirection: GradientDirection.ltr,
      style: const TextStyle(
        letterSpacing: 1,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

Route _createRoute(screenName) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screenName,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);

      var end = Offset.zero;

      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class Endorsement {
  final String name;
  final String role;
  final int age;

  Endorsement({required this.name, required this.role, required this.age});
}

// 2. Define a custom DataTableSource subclass to manage the data
class EndorsementDataSource extends DataTableSource {
  final List proposalData;
  final BuildContext context;
  int _selectedCount = 0;
  Dio dio = DioSingleton.dio;

  EndorsementDataSource(this.proposalData, this.context);

  @override
  int get rowCount => proposalData.length;

  @override
  bool get hasMoreRows => false;

  @override
  int get selectedRowCount => _selectedCount;

  Future<void> downloadFileFromApi(Map<String, dynamic> body) async {
    print('downloding');
    final appState = Provider.of<AppState>(context, listen: false);
    print(appState.accessToken);
    try {
      final response = await dio.post(
        "https://uatcld.sbigeneral.in/SecureApp/endorsementDocSearchXml",
        data: body,
        options: Options(
          headers: {
            'Authorization': appState.accessToken,
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        final contentDisposition =
            response.headers['content-disposition']?.first;
        String? fileName;
        if (contentDisposition != null) {
          final filenameRegex = RegExp(r'filename="?([^\";]*)"?');
          final match = filenameRegex.firstMatch(contentDisposition);
          if (match != null) {
            fileName = match.group(1);
          }
        }

        fileName ??= 'downloaded_file.pdf';
        print('Extracted filename: $fileName');

        final fileData = Uint8List.fromList(response.data);

        final blob = html.Blob([fileData]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        print('Failed to download file: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Failed to download file"),
            action: SnackBarAction(
              label: ' Cancel',
              onPressed: () {},
            )));
      }
    } on DioException catch (error) {
      print('Error: $error');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No data found"),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
    }
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);

    if (index >= proposalData.length) {
      // ignore: null_check_always_fails
      return null!;
    }
    final data = proposalData[index];

    return DataRow.byIndex(
      // color: MaterialStateProperty.all(Colors.grey[300]),
      index: index,
      selected: false,
      cells: [
        DataCell(TextButton(
          child: Text(
            data['id'].toString(),
            softWrap: false,
            maxLines: 3,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                // decoration: TextDecoration.underline,
                fontSize: 14,
                // fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(10, 4, 92, 1)),
          ),
          onPressed: () {
            print(' new form status ${proposalData[index]['new_form_status']}');
            print(' form status ${proposalData[index]['status']}');
            Navigator.of(context).push(_createRoute(MyForm(
                proposalId: proposalData[index]['id'].toString(),
                isView: ((data['payment_status'] == 'created' ||
                            data['payment_status'] == 'expired' ||
                            data['payment_status'] == 'cancelled') &&
                        data['status'] == 'discrepancy') ||
                    data['status'] != 'discrepancy',
                isEdit: (data['payment_status'] == 'paid' ||
                        data['payment_status'] == null) &&
                    data['status'] == 'discrepancy',
                formStatus: data['status'])));
          },
        )),
        DataCell(
            SizedBox(width: 100, child: Text(data['customer_name'] ?? 'Test'))),
        DataCell(SizedBox(
          width: 100,
          child: Text(
            data['product'] ?? 'Aarogya Sanjeevani',
            maxLines: 2,
          ),
        )),
        DataCell(Text(data['payment_status'] == 'created'
            ? 'Payment Link Created'
            : data['payment_status'] == 'expired'
                ? 'Payment Link Expired'
                : data['payment_status'] == 'paid'
                    ? 'Paid'
                    : data['payment_status'] == 'cancelled'
                        ? 'Cancelled'
                        : 'Not Applicable')),
        DataCell(
          SizedBox(
            width: 100,
            child: Text(
              data['payment_status'] == 'paid' || data['payment_status'] == null
                  ? "${data['status']}"
                  : 'sent_payment_link',
              softWrap: false,
              maxLines: 3,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: (proposalData[index]['status'] == 'declined')
                    ? Colors.red
                    : proposalData[index]['status'] == 'completed'
                        ? Colors.green
                        : proposalData[index]['status'] == 'discrepancy' &&
                                (proposalData[index]['new_form_status'] !=
                                        'sent_payment_link' ||
                                    proposalData[index]['new_form_status'] !=
                                        null)
                            ? Colors.orangeAccent
                            : Colors.grey,
              ),
            ),
          ),
          //   ),
          // ),
        ),
        DataCell(IconButton(
            onPressed: () {
              if (data['status'] == 'issued') {
                downloadFileFromApi({"proposal_id": "${data['id']}"});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Form Status of Inward No.${data['id']} is not Issued.Please try once the form is issued."),
                    action: SnackBarAction(
                      label: ' Cancel',
                      onPressed: () {},
                    )));
              }
            },
            icon: const Icon(
              Icons.file_download_outlined,
              color: Color.fromRGBO(10, 4, 92, 1),
              size: 27,
              shadows: [
                BoxShadow(
                  color:
                      //  Color.fromRGBO(231, 181, 229, 0.9),
                      Color.fromRGBO(16, 47, 184, 0.123),
                  blurRadius: 3.0, // soften the shadow
                  spreadRadius: 1.0,
                  blurStyle: BlurStyle.outer, //extend the shadow
                  offset: Offset(
                    5.0, // Move to right 5  horizontally
                    5.0, // Move to bottom 5 Vertically
                  ),
                )
              ],
            )))
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
}
