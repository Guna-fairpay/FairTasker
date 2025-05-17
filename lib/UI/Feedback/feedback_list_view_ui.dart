import 'dart:io';

import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';
import 'Comments/feedback_comments_ui.dart';

class FeedbackListViewUI extends StatefulWidget {
  final Map<String, dynamic> feedbacks;
  final String status;

  const FeedbackListViewUI(
      {super.key, required this.feedbacks, required this.status});

  @override
  State<FeedbackListViewUI> createState() => _FeedbackListViewUIState();
}

class _FeedbackListViewUIState extends State<FeedbackListViewUI> {
  TextEditingController titleController = TextEditingController();
  List<String> priority = ['High', 'Medium', 'Low'];
  String? selectedPriority;
  quill.QuillController descriptionController = quill.QuillController.basic();
  PageController pageController = PageController(initialPage: 0);
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.feedbacks['title'] ?? '';
    selectedPriority = widget.feedbacks['priority'] ?? '';
    descriptionController = quill.QuillController(
      document: quill.Document.fromJson(widget.feedbacks['des']),
      selection: const TextSelection.collapsed(offset: 0),
    );
    imagePaths = List<String>.from(widget.feedbacks['imgurls'] ?? []);
  }

  void _navigateToEditViewUI() async {
    // final updateFeedback = await Navigator.push<Map<String, dynamic>>(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FeedbackEditViewUI(
    //       // feedbacks: widget.feedbacks,
    //       // status: widget.status,
    //     ),
    //   ),
    // );
    // if (updateFeedback != null) {
      // final updateFeedback = {
      //   'title': widget.feedbacks['title'],  // You might allow editing the name if needed
      //   'des': descriptionController.document.toDelta().toJson(),
      //   'priority':selectedPriority!,
      //   'timestamp': DateTime.now().toString(),
      //   'img': imagePaths.isNotEmpty ? List<String>.from(imagePaths) : [],
      // };
      // setState(() {
      //   widget.feedbacks.addAll(updateFeedback);
      // });
    // }
  }

  void _closeFeedback() {
    setState(() {
      widget.feedbacks['status'] = 'Closed';
    });
    Navigator.pop(context, widget.feedbacks);
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
                                  print('Error loading asset image: $error');
                                  return const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              )
                            : Image.file(
                                File(imagePath),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading file image: $error');
                                  return const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
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
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: AppBar(
          backgroundColor: AppC.appColor,
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          title: const Text("Selected title"),
          titleTextStyle: context.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.white,)),
          ],
        ),
        body: Column(
          spacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  tabs: const [
                    Tab(text: 'Feedback', height: 40),
                    Tab(text: 'Comments', height: 40),
                  ],
                  dividerColor: AppC.trans,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  labelColor: AppC.white,
                  unselectedLabelColor: AppC.appColor,
                  indicator: BoxDecoration(
                    color: AppC.appColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(8),
                            color: Colors.blue[50],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Utils.getText(titleController.text,
                                        weight: FontWeight.bold)),
                                if (widget.status != 'Closed')
                                  GestureDetector(
                                    onTap: () {
                                      _closeFeedback();
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: AppC.completed,
                                    ),
                                  ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: selectedPriority == 'High'
                                        ? Colors.red
                                        : selectedPriority == 'Medium'
                                            ? Colors.blue
                                            : selectedPriority == 'Low'
                                                ? Colors.grey
                                                : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  width: 20,
                                  child: Center(
                                    child: Utils.getText(
                                      selectedPriority == 'High'
                                          ? 'H'
                                          : selectedPriority == 'Medium'
                                              ? 'M'
                                              : selectedPriority == 'Low'
                                                  ? 'L'
                                                  : 'N',
                                      weight: FontWeight.bold,
                                      color: AppC.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 8),
                                    child: Utils.getText(widget.status,
                                        color: AppC.red, weight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: _navigateToEditViewUI,
                                  child: const Icon(Icons.edit_rounded,
                                      color: AppC.appColor, size: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: quill.QuillEditor(
                                controller: quill.QuillController(
                                  document: descriptionController.document,
                                  selection: const TextSelection.collapsed(offset: 0),
                                  readOnly: true,
                                ),
                                scrollController: ScrollController(),
                                focusNode: FocusNode(),
                                configurations: const quill.QuillEditorConfigurations(
                                  floatingCursorDisabled: false,
                                  showCursor: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (imagePaths.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Utils.getText('Images:',
                                  size: 16, weight: FontWeight.bold),
                            ],
                          ),
                        if (imagePaths.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: imagePaths.map<Widget>((img) {
                                  return GestureDetector(
                                    onTap: () {
                                      int index = imagePaths.indexOf(img);
                                      _showImageDialog(imagePaths, index);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: img.startsWith('assets/')
                                          ? Image.asset(
                                              img,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(Icons.error);
                                              },
                                            )
                                          : Image.file(
                                              File(img),
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(Icons.error);
                                              },
                                            ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CommentsUI(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
