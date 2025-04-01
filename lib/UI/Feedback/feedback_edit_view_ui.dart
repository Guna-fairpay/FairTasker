import 'dart:io';
import 'package:fairpytasker/Component/feedback_tab_button.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_states.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/feedback_edit_form.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/feedback_edit_header.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/main_bloc/feedback_edit_main_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/main_bloc/feedback_edit_main_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/main_bloc/feedback_main_state.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';
import 'Comments/feedback_comments_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FeedbackEditViewUI extends StatelessWidget {
  final dynamic feedBackId;
  const FeedbackEditViewUI({super.key, required this.feedBackId});

  @override
  Widget build(BuildContext _) {
    return BlocProvider<FBEditBloc>(
      create: (context) => FBEditBloc()..add(FBInitialEvent(feedBackId)),
      child: BlocListener<FBEditBloc, FBEditStates>(
        listener: (context, state) {
          Utils.dismissKeyboard(context);
          if (state is FBLoadingState) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is FBErrorState) {
              Utils.showMobileToast(state.message);
            } else if (state is FBSuccessState) {
              Utils.showMobileToast(state.message);
            } else if (state is FBFeedViewAttachmentState) {
              ShowAttachmentsDialog.of.show(context, attachments: state.attachments, title: "", currentAttachment: state.attachment);
            }
          }
        },
        child: BlocBuilder<FBEditBloc, FBEditStates>(
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              title: Utils.getText("${context.read<FBEditBloc>().pageTitle}",
                  weight: FontWeight.bold, color: Colors.white),
              backgroundColor: const Color(0xFF364290).withValues(alpha: 0.95),
              foregroundColor: Colors.white,
              actions: (context.read<FBEditBloc>().pageId != 0)
                  ? []
                  : [
                IconButton(
                  onPressed: () => context
                      .read<FeedBackEditMainBloc>()
                      .add(FeedBackEditMainSaveEvent()),
                  icon: const Icon(Icons.save_rounded),
                ),
              ],
            ),
            body: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    spacing: 5,
                    children: [
                      FeedBackEditHeader(),
                      FeedbackEditForm(),
                      FeedbackEditComments(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class FeedbackEditViewUi extends StatefulWidget {
  final Map<String, dynamic> feedbacks;
  final String status;

  const FeedbackEditViewUi(
      {super.key, required this.feedbacks, required this.status});

  @override
  State<FeedbackEditViewUi> createState() => _FeedbackEditViewUIState();
}

class _FeedbackEditViewUIState extends State<FeedbackEditViewUi> {
  quill.QuillController descriptionController = quill.QuillController.basic();
  late TextEditingController titleController;
  PageController pageController = PageController(initialPage: 0);
  final ImagePicker _picker = ImagePicker();
  List<dynamic> imagePaths = [];
  final List<String> priority = ['High', 'Medium', 'Low'];
  String? selectedPriority;
  final List<String> status = [
    'Pending',
    'In Progress',
    'Review',
    'Closed',
    'Feature',
    'Archive'
  ];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.feedbacks['title']);
    descriptionController = quill.QuillController(
      document: quill.Document.fromHtml("${widget.feedbacks['description']}"),
      selection: const TextSelection.collapsed(offset: 0),
    );
    imagePaths =
        widget.feedbacks?["attachments"]?.map((e) => e['path']).toList() ?? [];
    selectedPriority = widget.feedbacks['priority'];
    selectedStatus = widget.status;
  }

  void _save() {
    if (titleController.text.isEmpty || selectedPriority == null) {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final updateFeedback = {
      'title': titleController.text,
      'priority': selectedPriority!,
      'des':
          descriptionController.document.toDelta().toJson(), // Save description
      'status': selectedStatus!,
      'img': imagePaths.isNotEmpty ? List<String>.from(imagePaths) : [],
    };
    Navigator.of(context).pop(updateFeedback);
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

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    setState(() {
      for (var file in pickedFiles) {
        if (!imagePaths.contains(file.path)) {
          imagePaths.add(file.path);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Column(
            children: [
              const HeaderView(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      Tab(text: 'Feedback', height: 30),
                      Tab(text: 'Comments', height: 30),
                    ],
                    dividerColor: AppC.trans,
                    labelStyle: const TextStyle(fontSize: 16),
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Utils.getText('Edit Feedback',
                                size: 20, weight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.remove_red_eye,
                              color: AppC.appColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: Utils.getTextFormField(
                        '',
                        titleController,
                        label: Utils.getText('Title'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Utils.buildDropdownButton(
                    //   'Select Priority',
                    //   priority,
                    //   selectedPriority,
                    //   (value) {
                    //     setState(() {
                    //       selectedPriority = value;
                    //     });
                    //   },
                    // ),
                    const SizedBox(
                      height: 4,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: 50,
                        child: quill.QuillToolbar.simple(
                          controller: descriptionController,
                          configurations:
                              quill.QuillSimpleToolbarConfigurations(
                            showSmallButton: false,
                            showSearchButton: false,
                            showClipboardCopy: false,
                            showClipboardCut: false,
                            showClipboardPaste: false,
                            color: AppC.inProgress,
                            toolbarIconAlignment: WrapAlignment.start,
                            showFontFamily: false,
                            showFontSize: false,
                            showHeaderStyle: false,
                          ),
                        ),
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
                        controller: descriptionController,
                        scrollController: ScrollController(),
                        focusNode: FocusNode(),
                        configurations: const quill.QuillEditorConfigurations(
                          placeholder: 'Add a comment...',
                          floatingCursorDisabled: false,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    /*Utils.buildDropdownButton(
                      'Select Status', // Changed from 'Select Priority' to 'Select Status'
                      status,
                      selectedStatus,
                      (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),*/
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Utils.getText('Attachments',
                            weight: FontWeight.bold, size: 16),
                        const SizedBox(width: 20),
                        SizedBox(
                          height: 35,
                          child: Utils.getOutlinedButton('Upload', () {
                            _pickImages();
                          },
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
                    if (imagePaths.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imagePaths.map<Widget>((img) {
                              int index = imagePaths.indexOf(img);
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showImageDialog(
                                          imagePaths as List<String>, index);
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
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: -10,
                                    child: IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          imagePaths.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton('Submit', () {
                            _save();
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CommentsUI(),
            ),
          ],
        ),
        drawer: const DrawerView(),
      ),
    );
  }
}
