import 'dart:developer';
import 'dart:io';
import 'package:date_time/date_time.dart';
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_bloc.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_states.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/feedback_comment_attachments.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'comments_add_ui.dart';
import 'comments_edit_ui.dart';

class FeedbackEditComments extends StatelessWidget {
  const FeedbackEditComments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FBEditBloc, FBEditStates>(
        buildWhen: (previous, current) =>
            current is FBFeedbackState || current is FBCommentState,
        builder: (context, state) => (state is FBCommentState)
            ? Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 12,
                      child:
                      ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var model = state.comments[index];
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) => context.read<FBEditBloc>().add(FBCommentDeleteEvent(model['id'])),
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppC.red,
                                    icon: Icons.delete_outline,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () => context.read<FBEditBloc>().add(FBCommentsEditEvent(model)),
                                child: Card.outlined(
                                  elevation: 3,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          minVerticalPadding: 0,
                                          leading: CircleAvatar(
                                            child: Center(
                                                child: Utils.getText(<String>[(model?['users']?['first_name'] ?? ''), (model?['users']?['last_name'] ?? '')].toInitial,
                                                    size: 16,
                                                    weight: FontWeight.bold,
                                                    color: AppC.white)),
                                          ),
                                          title: Text(
                                              "${model?['users']?['first_name'] ?? ''} ${model?['users']['last_name']}"),
                                          subtitle: Text(GetTimeAgo.parse(DateTime.tryParse(model?['created_at'] ?? "") ?? DateTime.now().toUtc())),
                                          trailing:
                                          // ((model?['attachments'] !=
                                          //     null) &&
                                          //     (model?['attachments']
                                          //     is List) &&
                                          //     (model?['attachments'] as List)
                                          //         .isNotEmpty)
                                          //     ? GestureDetector(
                                          //   onTap: () => context
                                          //       .read<FBEditBloc>()
                                          //       .add(FBFeedViewAttachmentEvent(
                                          //       null,
                                          //       (model?['attachments']
                                          //       as List)
                                          //           .where((element) =>
                                          //       element['path']
                                          //           .toString()
                                          //           .isNotEmpty)
                                          //           .map((e) => e[
                                          //       'path']
                                          //           .toString()
                                          //           .toAttachmentURL)
                                          //           .toList())),
                                          //   child: const Icon(Icons
                                          //       .attach_file_rounded),
                                          // )
                                          //     : null,
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 100),
                                            child: Row(
                                              spacing: 10,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                  child: (context.watch<FBEditBloc>().selectedCommentModel != model) ?
                                                  GestureDetector(
                                                      onTap: () => context.read<FBEditBloc>().add(FBCommentsEditEvent(model)),
                                                      child: Icon(Icons.edit_outlined, color:AppC.appColor)
                                                  ) :
                                                  GestureDetector(
                                                    onTap: ()=> context.read<FBEditBloc>().add(FBCommentsEditCancelEvent()),
                                                      child: Icon(Icons.cancel_outlined, color: AppC.red,)
                                                  ),
                                                ),
                                                if((model?['attachments'] != null) && (model?['attachments']is List) && (model?['attachments'] as List).isNotEmpty)...[
                                                  Flexible(
                                                    child: GestureDetector(
                                                        onTap: () => context.read<FBEditBloc>().add(FBFeedViewAttachmentEvent(
                                                            null,
                                                            (model?['attachments'] as List).where(
                                                                    (element) => element['path'].toString().isNotEmpty)
                                                                .map((e) => e['path'].toString().toAttachmentURL).toList())),
                                                      child: const Icon(Icons.attach_file_rounded),
                                                    ),
                                                  ),
                                                ] else...[
                                                  const SizedBox.shrink(),
                                                ]
                                              ],
                                            ),
                                          ),
                                          titleTextStyle: context
                                              .textTheme.labelLarge
                                              ?.copyWith(
                                                  fontFamily: "Lato",
                                                  fontWeight: FontWeight.bold),
                                          subtitleTextStyle: context
                                              .textTheme.labelSmall
                                              ?.copyWith(
                                                  fontFamily: "Lato",
                                                  fontWeight:
                                                      FontWeight.normal),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            "${model?['comment']}",
                                            style:
                                                context.textTheme.titleMedium,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => 5.height,
                          itemCount: state.comments.length
                      ),
                    ),
                    Column(
                      spacing: 5,
                      children: [
                        const FeedbackCommentAttachments(),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: context.read<FBEditBloc>().commentController,
                                textInputAction: TextInputAction.newline,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                enableIMEPersonalizedLearning: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  hintText: "Type here...",
                                  prefixIcon: GestureDetector(
                                    onTap: () => context.read<FBEditBloc>().add(FBCommentAddAttachmentEvent()),
                                    child:
                                        const Icon(Icons.attach_file_rounded),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () => context.read<FBEditBloc>().isEdit == false
                                    ? context.read<FBEditBloc>().add(FBCommentSubmitEvent())
                                    : context.read<FBEditBloc>().add(FBUpdateCommentEvent(context.read<FBEditBloc>().commentId, context.read<FBEditBloc>().commentController.text)),
                                style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    backgroundColor: WidgetStatePropertyAll(
                                        context.theme.colorScheme.primary),
                                    elevation: const WidgetStatePropertyAll(5),
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.white),
                                    padding:
                                        WidgetStatePropertyAll(14.padding)),
                                icon: const Icon(Icons.send)
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            : const SizedBox.shrink()
    );
  }
}

class CommentsUI extends StatefulWidget {
  const CommentsUI({super.key});

  @override
  State<CommentsUI> createState() => _CommentsUIState();
}

class _CommentsUIState extends State<CommentsUI> {
  final quill.QuillController commentsController =
      quill.QuillController.basic();
  List<Map<String, dynamic>> commands = [];
  List<Map<String, dynamic>> addCommands = [];
  PageController pageController = PageController();
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    commands = [
      {
        'name': 'Admin',
        'comment': quill.Document.fromJson([
          {
            "insert":
                "In the ListView.builder, the way comments are displayed could be more structured...\n"
          }
        ]).toDelta().toJson(),
        'timestamp':
            DateTime.now().subtract(const Duration(minutes: 1)).toString(),
        'img': [
          'assets/images/ic_introduction.png',
          'assets/images/ic_email_benner.png'
        ],
      },
      {
        'name': 'Lingeshwaran T',
        'comment': quill.Document.fromJson([
          {
            "insert":
                "In the ListView.builder, the way comments are displayed could be more structured...\n"
          }
        ]).toDelta().toJson(),
        'timestamp':
            DateTime.now().subtract(const Duration(hours: 2)).toString(),
        'img': [
          'assets/images/ic_app_dev.png',
          'assets/images/ic_email_benner.png'
        ],
      },
      {
        'name': 'Test 7',
        'comment': quill.Document.fromJson([
          {
            "insert":
                "In the ListView.builder, the way comments are displayed could be more structured...\n"
          }
        ]).toDelta().toJson(),
        'timestamp':
            DateTime.now().subtract(const Duration(hours: 2)).toString(),
        'img': ['assets/images/splash_bg.png'],
      },
      {
        'name': 'Admin',
        'comment': quill.Document.fromJson([
          {
            "insert":
                "In the ListView.builder, the way comments are displayed could be more structured...\n"
          }
        ]).toDelta().toJson(),
        'timestamp':
            DateTime.now().subtract(const Duration(minutes: 1)).toString(),
        'img': [
          'assets/images/ic_introduction.png',
          'assets/images/ic_email_benner.png'
        ],
      },
    ];

    addCommands = commands;
  }

  void _addNewComment() async {
    final newComment = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CommentsAddUI(), fullscreenDialog: true),
    );

    if (newComment != null) {
      setState(() {
        addCommands.add(newComment);
      });
    }
  }

  void _editComment(int index) async {
    final editedComment = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsEditUI(
          initialComment: addCommands[index],
        ),
      ),
    );

    if (editedComment != null) {
      setState(() {
        addCommands[index] = editedComment;
      });
    }
  }

  void _showImageDialog(List<String> imageUrls, int index) {
    if (imageUrls.isEmpty) {
      print('No images to show');
      return;
    }

    PageController pageController = PageController();

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
                  children: [
                    Expanded(
                      child: Utils.getText(
                        addCommands[index]['name'],
                        color: AppC().base,
                        size: 15,
                        weight: FontWeight.w600,
                      ),
                    ),
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
    return Scaffold(
      backgroundColor: AppC.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: addCommands.length,
                itemBuilder: (context, index) {
                  final commentData = addCommands[index];
                  final timestamp = DateTime.parse(commentData['timestamp']);
                  final formattedTimeAgo = _getTimeAgo(timestamp);
                  final initials = _getInitials(commentData['name']);

                  return Slidable(
                    key: Key(index.toString()),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              addCommands.removeAt(index);
                            });
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: AppC.red,
                          icon: Icons.delete_outline,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _editComment(index);
                      },
                      child: Card(
                        elevation: 3,
                        color: AppC.white,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppC.appColor,
                                    ),
                                    child: Center(
                                        child: Utils.getText(initials,
                                            size: 16,
                                            weight: FontWeight.bold,
                                            color: AppC.white)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Utils.getText(commentData['name'],
                                            weight: FontWeight.bold, size: 14),
                                        const SizedBox(height: 5),
                                        Text(
                                          formattedTimeAgo,
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  if (commentData['img'] != null &&
                                      commentData['img'].isNotEmpty)
                                    SizedBox(
                                      child: GestureDetector(
                                        onTap: () => _showImageDialog(
                                            commentData['img'], index),
                                        child: Icon(
                                          Icons.image_outlined,
                                          color: Colors.deepOrangeAccent[100],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              quill.QuillEditor(
                                controller: quill.QuillController(
                                  document: quill.Document.fromJson(
                                      commentData['comment']),
                                  selection:
                                      const TextSelection.collapsed(offset: 0),
                                  readOnly: true,
                                ),
                                scrollController: ScrollController(),
                                focusNode: FocusNode(),
                                config:
                                    const quill.QuillEditorConfig(
                                  scrollable: false,
                                  autoFocus: false,
                                  expands: false,
                                  showCursor: false,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(8, -8), // Adjust vertical position
        child: FloatingActionButton(
          onPressed: _addNewComment,
          backgroundColor: AppC.appColor,
          child: const Icon(
            Icons.edit_rounded,
            color: AppC.white,
          ),
        ),
      ),
      drawer: const DrawerView(),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = "";
    for (var i = 0; i < names.length; i++) {
      initials += names[i][0].toUpperCase();
    }
    return initials;
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
