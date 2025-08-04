import 'dart:io';

import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class CommentsAddUI extends StatefulWidget {
  const CommentsAddUI({super.key});

  @override
  State<CommentsAddUI> createState() => _CommentsAddUIState();
}

class _CommentsAddUIState extends State<CommentsAddUI> {
  final quill.QuillController commentsController =
      quill.QuillController.basic();
  PageController pageController = PageController();
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectImage() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    setState(() {
      // Avoid adding duplicates
      for (var file in pickedFiles) {
        if (!imagePaths.contains(file.path)) {
          imagePaths.add(file.path);
        }
      }
    });
  }

  // In CommentsAddUI
  void _save() {
    final richText = commentsController.document.toDelta().toJson();
    final newComment = {
      'name': 'User', // Or get this value from user input
      'comment': richText,
      'timestamp': DateTime.now().toString(),
      'img': imagePaths.isNotEmpty ? List<String>.from(imagePaths) : [],
    };

    Navigator.pop(context, newComment);
  }

  void _removeImage(int index) {
    setState(() {
      imagePaths.removeAt(index);
    });
  }

  void _showImageDialog(List<String> imageUrls, int initialIndex) {
    if (imageUrls.isEmpty) {
      print('No images to show');
      return;
    }
    PageController pageController = PageController(initialPage: initialIndex);

    print('Showing images dialog with ${imageUrls.length} images');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppC.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  color: AppC.white,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: PageView.builder(
                    itemCount: imageUrls.length,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      final imagePath = imageUrls[index];
                      print('Displaying image: $imagePath');
                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: imagePath.startsWith('assets/')
                            ? Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                      child:
                                          Icon(Icons.error, color: Colors.red));
                                },
                              )
                            : Image.file(
                                File(imagePath),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                      child:
                                          Icon(Icons.error, color: Colors.red));
                                },
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SmoothPageIndicator(
                  controller: pageController,
                  count: imageUrls.length,
                  effect: const JumpingDotEffect(
                    spacing: 8.0,
                    radius: 8.0,
                    dotWidth: 10.0,
                    dotHeight: 10.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        leading: Container(),
        leadingWidth: 0,
        title: Text("Add Comments"),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(color: Colors.white, fontFamily: "Lato", fontWeight: FontWeight.w600),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, color: Colors.white,)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            /*Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                Utils.getText('Add Comment', size: 20, weight: FontWeight.bold),
              ],
            ),*/
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        child: quill.QuillSimpleToolbar(
                          controller: commentsController,
                          config:
                              quill.QuillSimpleToolbarConfig(
                                  showSmallButton: false,
                                  showSearchButton: false,
                                  showClipboardCopy: false,
                                  showClipboardCut: false,
                                  showClipboardPaste: false,
                                  color: AppC.inProgress,
                                  toolbarIconAlignment: WrapAlignment.start,
                                  showFontFamily: false,
                                  showFontSize: false,
                                  showHeaderStyle: false),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: quill.QuillEditor(
                    controller: commentsController,
                    scrollController: ScrollController(),
                    focusNode: FocusNode(),
                    config: const quill.QuillEditorConfig(
                      placeholder: 'Add a comment...',
                      floatingCursorDisabled: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Image selection and comment submission row
            Row(
              children: [
                Utils.getText('Add Images', weight: FontWeight.bold, size: 16),
                const SizedBox(width: 40),
                SizedBox(
                  height: 40,
                  child: Utils.getOutlinedButton('Select Image', _selectImage,
                      iconData: const Icon(Icons.cloud_upload,
                          color: AppC.white, size: 15),
                      verticalPadding: 0,
                      radius: BorderRadius.circular(8),
                      bgColor: AppC.appColor,
                      borderColor: AppC.trans,
                      textColor: AppC.white),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (imagePaths.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    final imagePath = imagePaths[index];
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showImageDialog(imagePaths, index);
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                              image: DecorationImage(
                                image: FileImage(File(imagePath)),
                                fit: BoxFit.cover,
                                onError: (error, stackTrace) {
                                  // Handle image loading errors if needed
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -5,
                          top: -8,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              color: Colors
                                  .transparent, // Ensure icon is clickable
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const Divider(),
            // Add Comment Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  child: Utils.getFilledButton(
                    'Add',
                    _save,
                    verticalPadding: 0,
                    textColor: AppC.white,
                    bgColor: AppC.appColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // drawer: const DrawerView(),
    );
  }
}
