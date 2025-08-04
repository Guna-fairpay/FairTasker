import 'package:audioplayers/audioplayers.dart';
import 'package:fairpytasker/Component/audio_player_widget.dart';
import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Component/video_player_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log/add_vehicle_log/add_vehicle_log_bloc/add_vehicle_log_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log/add_vehicle_log/add_vehicle_log_bloc/add_vehicle_log_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Edit%20Vehicle/vehicle_log/add_vehicle_log/add_vehicle_log_bloc/add_vehicle_log_states.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/record_audio/record_audio_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_player/video_player.dart';

class AddVehicleLogView extends StatelessWidget {
  final dynamic vin;
  final Widget? searchChild;
  const AddVehicleLogView({super.key, required this.vin, this.searchChild});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddVehicleLogBloc()..add(AddVehicleLogInitialEvent(vin)),
      child: BlocListener<AddVehicleLogBloc, AddVehicleLogState>(
        listener: (context, state) {
          if (state is AddVehicleLogLoadingState) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch (state) {
              case AddVehicleLogErrorState() : Toaster.showError(state.message); break;
              case AddVehicleLogSuccessState() : Toaster.showSuccess(state.message); break;
              case AddVehicleLogCompletedState() : Navigator.pop(context); break;
              case AddVehicleLogRecorderAudioState(): RecordAudioDialog.show(context, onRecorded: (file) => context.read<AddVehicleLogBloc>().add(AddVehicleLogAudioInsertEvent(file))); break;
              case AddVehicleLogDeleteAttachmentState(): AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete this attachment?", negativeText: "No", positiveText: "Yes", isReasonRequired: false, onPositivePressed: () => context.read<AddVehicleLogBloc>().add(AddVehicleLogDeleteAttachmentEvent(type: state.type, delete: true))); break;
            }
          }
        },
        child: SafeArea(child: _AddVehicleLogBodyView(searchChild: searchChild)),
      ),
    );
  }
}

class _AddVehicleLogBodyView extends StatelessWidget {
  final Widget? searchChild;
  const _AddVehicleLogBodyView({this.searchChild});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddVehicleLogBloc, AddVehicleLogState>(
        builder: (context, state) => ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Utils.getTextFormField(
                    "Title", context.read<AddVehicleLogBloc>().titleController,
                    inputAction: TextInputAction.done,
                    textType: TextInputType.text),
                10.height,
                ListTile(
                  tileColor: AppC.grey.shade200,
                  minTileHeight: 0,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  dense: true,
                  shape: ContinuousRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Num.borderRadiusLarge)),
                  leading: const Icon(
                    Icons.videocam_rounded,
                    color: AppC.appColor,
                  ),
                  title: const Text("Record Video"),
                  trailing: const Icon(
                    Icons.add_rounded,
                    color: AppC.appColor,
                  ),
                  onTap: () => context
                      .read<AddVehicleLogBloc>()
                      .add(AddVehicleLogRecordVideoEvent()),
                ),
                if (context.watch<AddVehicleLogBloc>().video != null)
                  ...[
                    10.height,
                    CloseBadge(
                      onTapDelete: () => context.read<AddVehicleLogBloc>().add(AddVehicleLogDeleteAttachmentEvent(type: "video")),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: context.height * 0.3,
                        child: VideoPlayerView(videoInput: context.watch<AddVehicleLogBloc>().video,autoPlay: false)
                      ),
                    ),
                  ],
                10.height,
                ListTile(
                  tileColor: AppC.grey.shade200,
                  minTileHeight: 0,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  dense: true,
                  shape: ContinuousRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Num.borderRadiusLarge)),
                  leading: const Icon(
                    Icons.audiotrack_rounded,
                    color: AppC.appColor,
                  ),
                  title: const Text("Record Audio"),
                  trailing: const Icon(
                    Icons.add_rounded,
                    color: AppC.appColor,
                  ),
                  onTap: () => context
                      .read<AddVehicleLogBloc>()
                      .add(AddVehicleLogRecordAudioEvent()),
                ),
                if (context.watch<AddVehicleLogBloc>().audio != null)
                  ...[
                    10.height,
                    CloseBadge(
                      onTapDelete: () => context.read<AddVehicleLogBloc>().add(AddVehicleLogDeleteAttachmentEvent(type: "audio")),
                      child: SizedBox(
                          width: double.maxFinite,
                          child: AudioPlayerWidget(source: DeviceFileSource(context.watch<AddVehicleLogBloc>().audio?.path ?? ""))
                      ),
                    ),
                  ],
                10.height,
                ListTile(
                  tileColor: AppC.grey.shade200,
                  minTileHeight: 0,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  dense: true,
                  shape: ContinuousRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Num.borderRadiusLarge)),
                  leading: const Icon(
                    Icons.image_rounded,
                    color: AppC.appColor,
                  ),
                  title: const Text("Upload Image"),
                  trailing: const Icon(
                    Icons.add_rounded,
                    color: AppC.appColor,
                  ),
                  onTap: () => context
                      .read<AddVehicleLogBloc>()
                      .add(AddVehicleLogUploadImageEvent()),
                ),
                if (context.watch<AddVehicleLogBloc>().image != null)
                  ...[
                    10.height,
                    CloseBadge(
                      onTapDelete: () => context.read<AddVehicleLogBloc>().add(AddVehicleLogDeleteAttachmentEvent(type: "image")),
                      child: SizedBox(
                          width: double.maxFinite,
                          height: context.height * 0.3,
                          child: ImageViewer(imageInput: context.watch<AddVehicleLogBloc>().image, fit: BoxFit.cover,)
                      ),
                    ),
                  ],
                10.height,
                Utils.getTextFormField(
                    "Notes", context.read<AddVehicleLogBloc>().notesController,
                    minLines: 3,
                    maxLines: 6,
                    textType: TextInputType.multiline,
                    inputAction: TextInputAction.done),
                10.height,
                Row(
                  spacing: 10,
                  children: [
                    SuccessButton(text: "Save", onPressed: () => context
                        .read<AddVehicleLogBloc>()
                        .add(AddVehicleLogSubmitEvent())),
                    const Spacer(flex: 1),
                    (searchChild ?? const SizedBox.shrink())
                  ],
                ),
              ],
            ));
  }
}
