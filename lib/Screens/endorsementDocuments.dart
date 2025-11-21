// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable, avoid_web_libraries_in_flutter, unnecessary_import

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:secure_app/Screens/dashboard.dart';
import 'package:secure_app/Widgets/DocumentFunctions.dart';
import 'package:secure_app/Widgets/NavBar.dart';
import 'package:secure_app/Widgets/Style.dart';
import 'package:secure_app/Widgets/isLoading.dart';
import 'package:secure_app/Utility/customProvider.dart';
import 'package:secure_app/Utility/dioSingleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProposalDocuments extends StatefulWidget {
  final Map inwardData;
  final inwardType;
  final Map? ckycData;
  final FormData? ckycDocuments;
  final isEdit;
  final isView;

  ProposalDocuments(
      {super.key,
      required this.inwardData,
      required this.inwardType,
      required this.ckycData,
      required this.ckycDocuments,
      this.isEdit = false,
      this.isView = false});

  @override
  State<ProposalDocuments> createState() => _ProposalDocumentsState();
}

class _ProposalDocumentsState extends State<ProposalDocuments> {
  File? galleryFile;
  Map<String, List> documents = {
    'proposalDocuments': [],
    'otherDocuments': ['', '']
  };
  Map<String, List> documentsLoader = {
    'proposalDocuments': [],
    'otherDocuments': [false, false]
  };
  Map<String, List> edittedDocuments = {
    'proposalDocuments': [],
    'otherDocuments': ['', '']
  };

  Map<String, List> oldFileNames = {
    'proposalDocuments': [],
    'otherDocuments': [null, null]
  };
  int inwardId = 0;
  Dio dio = DioSingleton.dio;
  final picker = ImagePicker();
  bool isSubmitted = false;
  bool isLoading = false;
  bool loadingDoc = false;
  final ValueNotifier<MouseCursor> _cursorNotifier =
      ValueNotifier<MouseCursor>(SystemMouseCursors.basic);

  int proposal_doc_count = 4;
  String status = '';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void initState() {
    super.initState();
    print(widget.inwardData);

    getDocumentCountProposal();
    final appState = Provider.of<AppState>(context, listen: false);

    setState(() {
      inwardId = appState.proposalId;
    });
  }

  createBlobUrl(Uint8List fileData, String mimetype) {
    var blob = html.Blob([fileData], mimetype);
    final blobUrl = html.Url.createObjectUrlFromBlob(blob);
    return blobUrl;
  }

  fetchFilePath(String filename) async {
    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> headers = {"Authorization": appState.accessToken};

    var proposalId = appState.proposalId;

    try {
      final response = await dio.get(
        'https://uatcld.sbigeneral.in/SecureApp/proposalDocument/$proposalId/$filename',
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
        ),
      );

      String? contentType = response.headers.value('content-type');

      final fileBytes = response.data as List<int>;

      final fileBlob = html.Blob([Uint8List.fromList(fileBytes)], contentType);

      final fileUrl = html.Url.createObjectUrlFromBlob(fileBlob);

      return {"url": fileUrl, "fileType": contentType, "file_name": filename};
    } catch (e) {
      return null;
    }
  }

  // void openFile(String url) {
  //   print(url);
  //   print('hereee');
  //   html.window.open(url, "");
  // }

  // void downloadFile(String url, String fileName) {
  //   final anchor = html.AnchorElement(href: url)
  //     ..target = 'blank'
  //     ..download = fileName
  //     ..click();

  //   html.Url.revokeObjectUrl(url);
  // }
  // html.Url.revokeObjectUrl(url);

  Future<String> getDocuments(nofetch) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await _prefs;
    var token = prefs.getString('token') ?? '';
    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      var proposalId = appState.proposalId;
      print(proposalId);
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/proposalDocuments',
          data: {"proposal_id": proposalId},
          options: Options(headers: headers));
      var data = List.from(jsonDecode(response.data));
      print(data);

      var proposalList =
          data.where((dat) => dat['doc_type'] == 'proposal').toList();
      var otherList = data.where((dat) => dat['doc_type'] == 'other').toList();
      print(proposalList);
      print(otherList);
      for (var i = 0; i < proposalList.length; i++) {
        var filePage = int.parse(
                proposalList[i]['file_name'].split('.')[0].split('-')[1]) -
            1;
        if (nofetch == false) {
          documents['proposalDocuments']![filePage] =
              await fetchFilePath(proposalList[i]['file_name']);
        }

        if (widget.isEdit) {
          oldFileNames['proposalDocuments']![filePage] = {
            'file_name': proposalList[i]['file_name'],
            'version': proposalList[i]['version']
          };
        }
      }
      for (var i = 0; i < otherList.length; i++) {
        var filePage =
            int.parse(otherList[i]['file_name'].split('.')[0].split('-')[1]) -
                1;
        if (nofetch == false) {
          documents['otherDocuments']![filePage] =
              await fetchFilePath(otherList[i]['file_name']);
        }
        if (widget.isEdit) {
          oldFileNames['otherDocuments']![filePage] = {
            'file_name': otherList[i]['file_name'],
            'version': otherList[i]['version']
          };
        }
      }
      setState(() {
        // proposalList.map((d) async {
        //   print(d['file_name'].split('.')[0].split('-')[1]);
        //   documents['proposalDocuments']![
        //           int.parse(d['file_name'].split('.')[0].split('-')[1])] =
        //       await fetchFilePath(d['file_name']);
        // });
        // otherList.map((d) async {
        //   documents['otherDocuments']![d['file_name']
        //       .split('.')[0]
        //       .split('-')[1]] = await fetchFilePath(d['file_name']);
        // });
        isLoading = false;
      });
      print(documents);
      // var proposalList = data.where((dat) => dat['doctype'] == 'proposal');
      // var otherList = data.where((dat) => dat['doctype'] == 'other');

      // proposalList.map((d){
      //   documents['proposalDocuments']![d['file_name'].split('.')[0].split('-')[1]] = File(d['file_name']);
      // });
      // otherList.map((d){
      //   documents['otherDocuments']![d['file_name'].split('.')[0].split('-')[1]] = File(d['file_name']);
      // });
      return "Documents Fetched";
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
      return "";
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: const Text("Technical Error!"),
      //     action: SnackBarAction(
      //       label: ' Cancel',
      //       onPressed: () {},
      //     )));
    }
  }

  getDocumentCountProposal() async {
    print(widget.inwardData["product"]);
    setState(() {
      isLoading = true;
    });

    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> headers = {"Authorization": appState.accessToken};

    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/inwardProducts/productDetails',
          data: {"productName": widget.inwardData["product"]},
          options: Options(headers: headers));
      var data = jsonDecode(response.data);
      print(data);
      if (data['proposal_doc_count'] == null) {
        documents['proposalDocuments']!.add('');
        documents['proposalDocuments']!.add('');
        documentsLoader['proposalDocuments']!.add(false);
        documentsLoader['proposalDocuments']!.add(false);
        if (widget.isEdit) {
          edittedDocuments['proposalDocuments']!.add('');
          edittedDocuments['proposalDocuments']!.add('');
          oldFileNames['proposalDocuments']!.add(null);
          oldFileNames['proposalDocuments']!.add(null);
        }
      } else {
        for (int i = 0; i < data['proposal_doc_count']; i++) {
          if (widget.isEdit) {
            edittedDocuments['proposalDocuments']!.add('');
            oldFileNames['proposalDocuments']!.add(null);
          }
          documentsLoader['proposalDocuments']!.add(false);
          documents['proposalDocuments']!.add('');
        }
      }
      setState(() {
        proposal_doc_count = data['proposal_doc_count'] ?? 2;
        isLoading = false;
      });
      print(documents);

      print(widget.isEdit);
      if (widget.isView || widget.isEdit) {
        await getDocuments(false);
      }
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> uploadProposalDocuments(
      proposalId, fileArray, String docType, String documentType) async {
    if (documents[documentType]!.every((element) => element == '')) {
      return null;
    }

    final appState = Provider.of<AppState>(context, listen: false);
    // Map<String, String> headers = {"Authorization": appState.accessToken};
    var formData = html.FormData();
    formData.append('proposal_id', proposalId);
    formData.append('doc_type', docType);

    for (var i = 0; i < fileArray.length; i++) {
      if (fileArray[i] != '') {
        print(fileArray[i]);

        formData.appendBlob('files', fileArray[i]['file'],
            '${docType}page-${i + 1}.${fileArray[i]['file'].name.split('.').last}');
      }
    }

    String route = 'proposalDocument';
    if (widget.isEdit) {
      route = 'updateProposalDocument';
    }
    print(route);

    String? returnString = null;
    final completer = Completer<String?>();
    final request = html.HttpRequest();
    request
      ..open('POST', 'https://uatcld.sbigeneral.in/SecureApp/$route')
      ..setRequestHeader('Authorization', appState.accessToken)
      ..onLoadEnd.listen((e) {
        if (request.status == 200) {
          print("Upload successful");
          completer.complete(null);
        } else {
          print('Upload failed');
          completer.complete("Endorsement Documents not Submitted");
        }
      })
      ..send(formData);

    returnString = await completer.future;
    return returnString;
  }

  editProposal() async {
    var emptyProposalDocuments = documents['proposalDocuments']!.every((data) {
      return data == '';
    });
    var emptyOtherDocuments = documents['otherDocuments']!.every((data) {
      return data == '';
    });
    print(widget.inwardType);
    if (widget.inwardData['submission_mode'] == "Digital" ||
        widget.inwardData['submission_mode'] == "online" ||
        widget.inwardType == 'endorsement') {
      var proposalList = documents['proposalDocuments']!.where((data) {
        return data == '';
      }).toList();

      if (proposal_doc_count - proposalList.length < 1) {
        print(proposal_doc_count - proposalList.length);
        Style.showAlertDialog(
            context, 'Upload Atleast 1 Endorsement Document.');

        return;
      }
      // if (widget.inwardType == "Replenishment" && emptyOtherDocuments) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: const Text("Upload at least one Other Document"),
      //       action: SnackBarAction(
      //         label: ' Cancel',
      //         onPressed: () {},
      //       )));
      //   return;
      // }
    }
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      List<String?> results = await Future.wait([
        uploadEdittedDocuments(
            appState.proposalId, 'proposal', 'proposalDocuments'),
        uploadEdittedDocuments(appState.proposalId, 'other', 'otherDocuments'),
      ]);
      print(results[0]);
      print(results[1]);
      if (results[0] != null || results[1] != null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Documents not uploaded. Please try again!"),
            action: SnackBarAction(
              label: ' Cancel',
              onPressed: () {},
            )));
        return;
      }
      String resText = "";
      if (!emptyProposalDocuments || !emptyOtherDocuments) {
        resText = await verifyDocsUpload();
      }
      if (resText != "") {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Documents not uploaded!"),
            action: SnackBarAction(
              label: ' Cancel',
              onPressed: () {},
            )));
        return;
      }
      await updateStatus();
      String getDocumentsError = await getDocuments(true);
      if (getDocumentsError == "") {}
      setState(() {
        isLoading = false;
        status = 'discrepancy';
      });
      setState(() {
        isSubmitted = true;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Documents not editted. Try again!"),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
    }
  }

  uploadProposal() async {
    var emptyProposalDocuments = documents['proposalDocuments']!.every((data) {
      return data == '';
    });
    var emptyOtherDocuments = documents['otherDocuments']!.every((data) {
      return data == '';
    });
    print(widget.inwardData['submission_mode']);
    if (widget.inwardData['submission_mode'] == "Digital" ||
        widget.inwardData['submission_mode'] == "online" ||
        widget.inwardType == 'endorsement') {
      var proposalList = documents['proposalDocuments']!.where((data) {
        return data == '';
      }).toList();

      if (proposal_doc_count - proposalList.length < 1) {
        Style.showAlertDialog(
            context, 'Upload Atleast 1 Endorsement Document.');
        print(proposal_doc_count - proposalList.length);

        return;
      }
    }

    final appState = Provider.of<AppState>(context, listen: false);

    print(widget.inwardData);
    setState(() {
      isLoading = true;
    });

    try {
      List<String?> results = await Future.wait([
        uploadProposalDocuments(appState.proposalId.toString(),
            documents['proposalDocuments']!, 'proposal', 'proposalDocuments'),
        uploadProposalDocuments(appState.proposalId.toString(),
            documents['otherDocuments']!, 'other', 'otherDocuments'),
        // uploadCkycDocuments(appState.proposalId.toString())
      ]);

      if (results[0] != null || results[1] != null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Documents not uploaded. Please try again!"),
            action: SnackBarAction(
              label: ' Cancel',
              onPressed: () {},
            )));
        return;
      }
      String resText = "";
      if (!emptyProposalDocuments || !emptyOtherDocuments) {
        resText = await verifyDocsUpload();
      }
      print(resText);
      if (resText != "") {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Documents not uploaded. Try again!"),
            action: SnackBarAction(
              label: ' Cancel',
              onPressed: () {},
            )));
        return;
      }
      await updateStatus();
      setState(() {
        isLoading = false;
      });
      setState(() {
        isSubmitted = true;
      });

      // print(results);
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Documents not submitted. Try again!"),
          action: SnackBarAction(
            label: ' Cancel',
            onPressed: () {},
          )));
    }
    // await uploadProposalDocuments(data['proposal']['id'].toString(),
    //     documents['proposalDocuments']!, 'proposal');
    // await uploadProposalDocuments(data['proposal']['id'].toString(),
    //     documents['otherDocuments']!, 'other');
    // if (widget.ckycDocuments != null) {
    //   await uploadCkycDocuments(data['proposal']['id'].toString());
    // }
  }

  Future<String> verifyDocsUpload() async {
    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> postData = {
      'proposal_id': appState.proposalId.toString(),
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };

    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/verifyDocuments',
          data: postData,
          options: Options(headers: headers));
      print(response.data);

      return "";
    } on DioException catch (error) {
      print(error);
      return "Documents not verified";
    }
  }

  Future<String?> uploadEdittedDocuments(
      proposalId, docType, documentType) async {
    print(docType);
    print("ggggggggggggggggggggggggggggggggggggggggggg");
    print(edittedDocuments[documentType]);
    if (edittedDocuments[documentType]!.every((element) => element == '')) {
      return null;
    }

    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> headers = {"Authorization": appState.accessToken};

    var docs = edittedDocuments[documentType];
    String? returnString = null;
    final completer = Completer<String?>();
    for (var i = 0; i < docs!.length; i++) {
      print(docs[i]);
      print(oldFileNames[documentType]![i]);
      if (docs[i] != '') {
        String fileExtension = docs[i]['file'].name.split('.').last;
        String fileName = '${docType}page-${i + 1}.$fileExtension';
        double newVersion = 1.0;
        String oldFileName = '';
        print(oldFileNames[documentType]![i] != '');
        if (oldFileNames[documentType]![i] != null) {
          oldFileName = oldFileNames[documentType]![i]['file_name'];
          newVersion =
              double.parse(oldFileNames[documentType]![i]['version']) + 0.1;
          List oldFileNameArr = oldFileName.split('_');

          oldFileNameArr[2] = 'V${newVersion.toString().split('.')[0]}';
          oldFileNameArr[3] = newVersion.toStringAsFixed(1).split('.')[1];
          print(oldFileNameArr);
          fileName = '${oldFileNameArr.join('_').split('.')[0]}.$fileExtension';
        }

        var formData = html.FormData();
        print(oldFileName);
        // var formData = html.FormData({
        //   'proposal_id': proposalId.toString(),
        //   'doc_type': docType,
        //   'oldFileName': oldFileName,
        //   'version': newVersion.toString(),
        //   'file': await MultipartFile.fromFile(docs[i].path, filename: fileName)
        // });
        formData.append('proposal_id', proposalId.toString());
        formData.append('doc_type', docType);
        formData.append('oldFileName', oldFileName);
        formData.append('version', newVersion.toString());
        formData.appendBlob('file', docs[i]['file'], fileName);

        print('donee');
        print(formData);
        // formData.fields.add(MapEntry('proposal_id', proposalId.toString()));
        // formData.fields.add(MapEntry('doc_type', docType));
        // formData.fields.add(MapEntry("oldFileName",
        //     oldFileNames['proposalDocuments']![i]['file_name']));
        // formData.fields.add(MapEntry("version", newVersion.toString()));
        // formData.files.add(MapEntry(
        //     'file',
        //     await MultipartFile.fromFile(docs[i].path,
        //         filename: oldFileNameArr.join('_'))));

        final request = html.HttpRequest();
        request
          ..open('POST',
              'https://uatcld.sbigeneral.in/SecureApp/singleProposalDocument')
          ..setRequestHeader('Authorization', appState.accessToken)
          ..onLoadEnd.listen((e) {
            if (request.status == 200) {
              print("Upload successful");
              // completer.complete(null);
            } else {
              print('Upload failed');
              completer.complete("Endorsement Documents not Submitted");
            }
          })
          ..send(formData);
      }
    }
    completer.complete(null);
    returnString = await completer.future;
    return returnString;
  }

  Future<String?> deleteDocuments(proposalId, fileName) async {
    print("deleted");
    setState(() {
      loadingDoc = true;
    });

    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> headers = {"Authorization": appState.accessToken};

    final completer = Completer<String?>();
    var formData = html.FormData();
    formData.append('proposal_id', proposalId.toString());
    formData.append('oldFileName', fileName);
    formData.append('file_inactive', '1');

    print('donee');
    print(formData);

    final request = html.HttpRequest();
    request
      ..open('POST',
          'https://uatcld.sbigeneral.in/SecureApp/singleProposalDocument')
      ..setRequestHeader('Authorization', appState.accessToken)
      ..onLoadEnd.listen((e) {
        if (request.status == 200) {
          print("Upload successful");
          setState(() {
            loadingDoc = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document deleted!')),
          );
          // completer.complete(null);
        } else {
          print('Upload failed');
          completer.complete("Endorsement Document is not Deleted");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Endorsement Document not Deleted!')),
          );
          setState(() {
            loadingDoc = false;
          });

          getDocuments(false);
        }
      })
      ..send(formData);
  }

  updateStatus() async {
    final appState = Provider.of<AppState>(context, listen: false);
    Map<String, String> postData = {
      'proposal_id': appState.proposalId.toString(),
      'user_id': appState.userId.toString(),
      "status": widget.isEdit ? 'discrepancy' : ''
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": "application/json",
      "Authorization": appState.accessToken
    };

    try {
      final response = await dio.post(
          'https://uatcld.sbigeneral.in/SecureApp/inwardComplete',
          data: postData,
          options: Options(headers: headers));
      print(response);
    } on DioException catch (error) {
      print(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return MouseRegion(
      cursor:
          loadingDoc ? SystemMouseCursors.progress : SystemMouseCursors.basic,
      child: Stack(
        children: [
          Scaffold(
              appBar: NavBar.appBar(),
              body: Stack(
                children: [
                  Style.background(context),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        NavBar.header(
                          context,
                          'Previous',
                          () {
                            Navigator.pop(context);
                          },
                        ),
                        Style.formContainer(
                            context,
                            widget.isView || widget.isEdit
                                ? 'Endorsement Documents (Inward No: ${appState.proposalId}) :'
                                : 'Endorsement Documents:',
                            [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Style.requiredFieldLabel(
                                        'Upload Endorsement Documents (Atleast 1 document mandatory):',
                                        13),
                                    heightGap(),
                                    Wrap(
                                      spacing: 20,
                                      runSpacing: 15,
                                      children: List.generate(
                                          documents['proposalDocuments']!
                                              .length, (index) {
                                        return _uploadDocument(
                                            'Upload Endorsement Document',
                                            index,
                                            'proposalDocuments');
                                      }),
                                    ),
                                    documents['otherDocuments']!.every(
                                                        (element) =>
                                                            element == '') ==
                                                    false &&
                                                widget.isView == true ||
                                            widget.isEdit ||
                                            widget.isEdit == false &&
                                                widget.isView == false
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              heightGap(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Style.notRequiredFieldLabel(
                                                      'Upload Other Documents: ',
                                                      13),
                                                  widget.isView == false &&
                                                          widget.inwardType !=
                                                              'Replenishment'
                                                      ? TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              if (documents[
                                                                          'otherDocuments']!
                                                                      .length <
                                                                  12) {
                                                                documents[
                                                                        'otherDocuments']!
                                                                    .add('');
                                                              }
                                                            });
                                                          },
                                                          child: const Text(
                                                            '+',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        11,
                                                                        133,
                                                                        163,
                                                                        1),
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    heightGap(),
                                    Wrap(
                                      spacing: 20,
                                      runSpacing: 15,
                                      children: List.generate(
                                          documents['otherDocuments']!.length,
                                          (index) {
                                        return _uploadDocument(
                                            'Upload Other Document',
                                            index,
                                            'otherDocuments');
                                      }),
                                    ),
                                    heightGap(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color.fromRGBO(
                                                        130, 25, 151, 1),
                                                    Color.fromRGBO(
                                                        14, 64, 139, 1),
                                                  ])),
                                          child: TextButton(
                                              onPressed: () {
                                                if (loadingDoc == false) {
                                                  print('submit');
                                                  print(widget.isEdit);
                                                  if (widget.isEdit) {
                                                    print('editing');
                                                    editProposal();
                                                  } else if (widget.isView) {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const InwardStatus2()));
                                                  } else {
                                                    uploadProposal();
                                                  }
                                                }
                                              },
                                              child: Text(
                                                widget.isEdit
                                                    ? 'Update Inward'
                                                    : widget.isView
                                                        ? 'Close'
                                                        : 'Submit Inward',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ],
              )),
          isLoading
              ? const LoadingPage(
                  label: "Loading",
                )
              : Container(),
          isSubmitted
              ? Positioned(
                  // left: 20,
                  // right: 20,
                  // top: 40,
                  // bottom: 40,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(color: Colors.black38),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(40, 160, 40, 160),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color:
                                      //  Color.fromRGBO(231, 181, 229, 0.9),
                                      Color.fromRGBO(15, 5, 158, 0.4),
                                  blurRadius: 5.0, // soften the shadow
                                  spreadRadius: 2.0, //extend the shadow
                                  offset: Offset(
                                    3.0, // Move to right 5  horizontally
                                    3.0, // Move to bottom 5 Vertically
                                  ),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(13, 154, 189, 0.4),
                                  width: 4)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Form Submitted Succcessfully!',
                                maxLines: 3,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    decoration: TextDecoration.none),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Inward No: $inwardId',
                                maxLines: 3,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    decoration: TextDecoration.none),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(38, 173, 20, 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          //  Color.fromRGBO(231, 181, 229, 0.9),
                                          Color.fromRGBO(15, 5, 158, 0.4),
                                      blurRadius: 5.0, // soften the shadow
                                      spreadRadius: 2.0, //extend the shadow
                                      offset: Offset(
                                        3.0, // Move to right 5  horizontally
                                        3.0, // Move to bottom 5 Vertically
                                      ),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 70,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const InwardStatus2())),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<Response> fetchBlob(String blobUrl) async {
    final dio = Dio();
    return await dio.get(blobUrl,
        options: Options(responseType: ResponseType.bytes));
  }

  _uploadDocument(String label, int index, String type) {
    final appState = Provider.of<AppState>(context, listen: false);
    if (widget.isView &&
        (documents[type]![index] == null || documents[type]![index] == '')) {
      return Container();
    }
    return DocumentCommonFunctions.uploadDocument(
      context,
      index,
      type,
      documents[type]![index],
      widget.isView,
      widget.isEdit,
      () {
        if (widget.isView == false) {
          _pickFile(type, index);
        }
      },
      () {
        if (widget.isEdit) {
          if (edittedDocuments[type]![index] != null &&
              edittedDocuments[type]![index].isNotEmpty) {
            html.Url.revokeObjectUrl(edittedDocuments[type]![index]['url']);
          }
        }
        if (documents[type]![index] != null &&
            documents[type]![index].isNotEmpty) {
          html.Url.revokeObjectUrl(documents[type]![index]['url']);
        }
        setState(() {
          if (widget.isEdit) {
            edittedDocuments[type]![index] = '';
          }
          documents[type]![index] = '';
          if (widget.isEdit && oldFileNames[type]![index] != null) {
            deleteDocuments(
                appState.proposalId, oldFileNames[type]![index]['file_name']);
          }
        });
      },
      documentsLoader,
    );
  }

  // Future<void> _pickFile(String type, int index) async {
  //   setState(() {
  //     documentsLoader[type]![index] = true;
  //   });

  //   html.FileUploadInputElement inputElement = html.FileUploadInputElement();
  //   inputElement.multiple = false;
  //   inputElement.accept = '.pdf,.jpg,.jpeg,.png';

  //   inputElement.click();

  //   // Listen for file selection or cancellation
  //   inputElement.onChange.listen((e) {
  //     final files = inputElement.files;

  //     // Check if no file was selected
  //     if (files == null || files.isEmpty) {
  //       setState(() {
  //         documentsLoader[type]![index] = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('No document selected')),
  //       );
  //       return; // Exit the function early if no file was selected
  //     }

  //     // If file is selected, proceed with processing the file
  //     final reader = html.FileReader();

  //     reader.readAsArrayBuffer(files[0]);
  //     reader.onLoadEnd.listen((e) {
  //       final file = files[0];
  //       final fileName = file.name;
  //       final fileType = file.type;

  //       final blob = html.Blob([reader.result as List<int>], fileType);
  //       final url = html.Url.createObjectUrlFromBlob(blob);

  //       setState(() {
  //         if (documents[type]![index] != null &&
  //             documents[type]![index].isNotEmpty) {
  //           html.Url.revokeObjectUrl(documents[type]![index]);
  //         }
  //         documents[type]![index] = {
  //           "url": url,
  //           "fileType": fileType,
  //           "file_name": fileName,
  //           "file": file
  //         };
  //         if (widget.isEdit) {
  //           edittedDocuments[type]![index] = {
  //             "url": url,
  //             "fileType": fileType,
  //             "file_name": fileName,
  //             "file": file,
  //           };
  //         }
  //       });
  //       setState(() {
  //         documentsLoader[type]![index] = false;
  //       });
  //     });
  //   });

  //   // Handle cancel event
  //   inputElement.onTouchCancel.listen((e) {
  //     setState(() {
  //       documentsLoader[type]![index] = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No document selected')),
  //     );
  //   });
  // }

  Future<void> _pickFile(String type, int index) async {
    try {
      html.FileUploadInputElement inputElement = html.FileUploadInputElement();
      inputElement.multiple = false;
      inputElement.accept = '.pdf,.jpg,.jpeg,.png';

      inputElement.click();

      inputElement.onChange.listen((e) async {
        print((e.target as html.FileUploadInputElement).files);
        final files = inputElement.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final fileSize = file.size;
          final fileType = file.type;

          if ((fileType == 'application/pdf' && fileSize > 2 * 1024 * 1024)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File size exceeds 2mb')),
            );

            return;
          }
          // _cursorNotifier.value = SystemMouseCursors.progress;
          setState(() {
            loadingDoc = true;
          });
          Uint8List? compressedData;
          if (fileType.startsWith('image/') && fileSize > 3 * 1024 * 1024) {
            final reader = html.FileReader();
            reader.readAsArrayBuffer(file);
            await reader.onLoadEnd.first;

            final originalData = reader.result as Uint8List;
            final image = img.decodeImage(originalData);
            if (image != null) {
              final resizedImage = img.copyResize(image, width: 800);
              compressedData =
                  Uint8List.fromList(img.encodeJpg(resizedImage, quality: 70));
            }
          }

          final reader = html.FileReader();

          reader.readAsArrayBuffer(files[0]);
          reader.onLoadEnd.listen((e) {
            final file = files[0];
            final fileName = files[0].name;
            final fileType = files[0].type;

            final blob = html.Blob(
                [compressedData ?? reader.result as List<int>], fileType);
            final url = html.Url.createObjectUrlFromBlob(blob);

            setState(() {
              if (documents[type]![index] != null &&
                  documents[type]![index].isNotEmpty) {
                html.Url.revokeObjectUrl(documents[type]![index]);
              }
              documents[type]![index] = {
                "url": url,
                "fileType": fileType,
                "file_name": fileName,
                "file": file
              };
              print(documents);
              if (widget.isEdit) {
                edittedDocuments[type]![index] = {
                  "url": url,
                  "fileType": fileType,
                  "file_name": fileName,
                  "file": file,
                };
              }
            });
            setState(() {
              loadingDoc = false;
            });
            // setState(() {
            //   documentsLoader[type]![index] = false;
            // });
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No document selected')),
          );
        }
      });
      inputElement.onTouchCancel.listen((e) {
        setState(() {
          loadingDoc = false;
        });
        // setState(() {
        //   documentsLoader[type]![index] = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No document selected')),
        );
        return;
      });
    } catch (e) {
      setState(() {
        loadingDoc = false;
      });
      print(e);
    }
  }
}
