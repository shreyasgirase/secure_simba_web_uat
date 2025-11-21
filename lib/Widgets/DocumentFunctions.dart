// ignore_for_file: unused_local_variable, avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'dart:html' as html;

// import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DocumentCommonFunctions {
  static Widget uploadDocument(
    BuildContext context,
    int index,
    String type,
    docs,
    bool view,
    bool edit,
    pickedFile,
    deleted,
    uploading,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Wrap(
          children: [
            Container(
              height: 30.0,
              width: 350.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: const Color.fromRGBO(176, 34, 204, 1), width: 1)),
              // child: uploading[type][index]
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           const Text('Loading Document...',
              //               style: TextStyle(
              //                 decoration: TextDecoration.none,
              //                 fontSize: 11,
              //                 fontWeight: FontWeight.w600,
              //                 color: Color.fromARGB(255, 39, 39, 39),
              //               )),
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           LoadingAnimationWidget.threeArchedCircle(
              //             color: Color.fromARGB(255, 39, 39, 39),
              //             size: 13,
              //           ),
              //         ],
              //       )
              // :
              child: (docs != '')
                  ? Center(
                      child: Text(
                      docs['file_name'],
                      style: const TextStyle(fontSize: 11),
                    ))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(6, 5, 5, 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                              side: const BorderSide(
                                  color: Colors.black54, width: 0.5)),
                          surfaceTintColor:
                              const Color.fromRGBO(95, 84, 84, 0.747),
                          // backgroundColor:
                          //     const Color.fromRGBO(235, 234, 234, 0.663)
                        ),
                        onPressed: pickedFile,
                        child: const Text(
                          'Choose File',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
            ),
            docs != ''
                ? SizedBox(
                    width: 250,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // if (edit) {
                            openFile(docs['url']);
                            // }
                          },
                          child: const Text(
                            'View',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        if (edit)
                          TextButton(
                            onPressed: () {
                              // if (edit) {
                              downloadFile(docs['url'], docs['file_name']);
                              // }
                            },
                            child: const Text(
                              'Download',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        if (view == false)
                          TextButton(
                            onPressed: deleted,
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: 250)
          ],
        ),
      ],
    );
  }

  static void openFile(String url) {
    html.window.open(url, "");
  }

  static void downloadFile(String url, String fileName) {
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
