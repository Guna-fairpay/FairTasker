import 'dart:io';
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/custom_quill_editor.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Feedback/feedback_add/bloc/feedback_add_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_add/bloc/feedback_add_events.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Component/drawer_ui.dart';
import '../../Component/header.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'feedback_add/bloc/feedback_add_states.dart';

class FeedbackAddUI extends StatelessWidget {
  const FeedbackAddUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Feedback", textDirection: TextDirection.ltr, textAlign: TextAlign.start),
        elevation: 5,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        actions: [IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))],
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: AppC.appColor,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => FeedbackAddBloc(),
        child: BlocListener<FeedbackAddBloc, FeedbackAddState>(
          listener: (context, state) {
            if (state is FeedbackAddLoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              if (state is FeedbackAddCompletedState) {
                Navigator.pop(context);
              } else if (state is FeedbackAddCommonState) {
                Utils.dismissKeyboard(context);
              }
            }
          },
          child: const _FeedbackAddBodyUI(),
        ),
      ),
    );
  }
}

class _FeedbackAddBodyUI extends StatelessWidget {
  const _FeedbackAddBodyUI();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackAddBloc, FeedbackAddState>(
        builder: (context, state) => Form(
          key: context.read<FeedbackAddBloc>().formKey,
          child: ListView(
                shrinkWrap: true,
                padding: 10.padding,
                children: [
                  Utils.getTextFormField(
                    'Title',
                    context.read<FeedbackAddBloc>().titleController,
                    validator: (value) => value.isNullOrEmpty ? 'Please enter a title' : null,
                    label: Utils.getText('Title', color: AppC.grey),
                  ),
                  10.height,
                  Utils.buildDropdownButton(
                    'Select Priority',
                    context.read<FeedbackAddBloc>().priority,
                    context.watch<FeedbackAddBloc>().selectedPriority,
                    (value) => context.read<FeedbackAddBloc>().add(FeedbackSelectedPriorityEvent(value)),
                  ),
                  10.height,
                  CustomQuillEditor(
                      controller:
                          context.read<FeedbackAddBloc>().descriptionController,
                      hintText: "Description"),
                  ListTile(
                    title: const Text("Attachments"),
                    trailing: const Icon(Icons.add_rounded),
                    titleTextStyle: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.sp),
                    onTap: () => context
                        .read<FeedbackAddBloc>()
                        .add(FeedbackAddAttachmentEvent()),
                  ),
                  10.height,
                  GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.9,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        var model =
                            context.read<FeedbackAddBloc>().attachments[index];
                        return CloseBadge(
                            onTapDelete: () => context
                                .read<FeedbackAddBloc>()
                                .add(FeedbackDeleteAttachmentEvent(model)),
                            onTapView: () => context
                                .read<FeedbackAddBloc>()
                                .add(FeedbackViewAttachmentEvent(model)),
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.sizeOf(context).height,
                                minWidth: MediaQuery.sizeOf(context).width,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: AppC.grey.withValues(alpha: 0.2)),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: ImageViewer(
                                fit: BoxFit.cover,
                                imageInput: model,
                                isNotImage: !((model as Object).isImage),
                              ),
                            ));
                      },
                      shrinkWrap: true,
                      itemCount:
                          context.watch<FeedbackAddBloc>().attachments.length),
                  10.height,
                  Utils.getFilledButton("Save", () => context.read<FeedbackAddBloc>().add(FeedbackSubmitEvent())),
                ],
              ),
        ));
  }
}

class FeedbackAddUIState extends StatefulWidget {
  const FeedbackAddUIState({super.key});

  @override
  State<FeedbackAddUIState> createState() => _FeedbackAddUIState();
}

class _FeedbackAddUIState extends State<FeedbackAddUIState> {
  TextEditingController titleController = TextEditingController();
  List<String> priority = ['High', 'Medium', 'Low'];
  String? selectedPriority;
  final quill.QuillController descriptionController =
      quill.QuillController.basic();
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];

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

  void _save() {
    final richTextJson = descriptionController.document.toDelta().toJson();

    if (titleController.text.isEmpty || selectedPriority == null) {
      return Utils.showMobileToast('Please fill in all required fields');
    }

    final newFeedback = {
      'title': titleController.text,
      'priority': selectedPriority!,
      'des': richTextJson, // Convert richText to String if needed
      'imgurls': imagePaths.isNotEmpty ? List<String>.from(imagePaths) : [],
    };

    Navigator.of(context)
        .pop(newFeedback); // Make sure you handle the returned map correctly
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
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  Utils.getText('Add Feedback',
                      size: 20, weight: FontWeight.bold),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: Utils.getTextFormField(
                  '',
                  titleController,
                  label: Utils.getText('Title', color: AppC.grey),
                ),
              ),
              const SizedBox(height: 20),
              Utils.buildDropdownButton(
                'Select Priority',
                priority,
                selectedPriority,
                (value) {
                  setState(() {
                    selectedPriority = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 50,
                  child: quill.QuillToolbar.simple(
                    controller: descriptionController,
                    configurations: quill.QuillSimpleToolbarConfigurations(
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Utils.getText('Attachments',
                      weight: FontWeight.bold, size: 16),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: Utils.getOutlinedButton(
                        'Upload', _pickImages, // Call image picker
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
              const SizedBox(height: 20),
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
      drawer: const DrawerView(),
    );
  }
}
