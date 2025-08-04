part of 'check_in_main_page.dart';

class CheckInPicturesListUI extends StatelessWidget {
  const CheckInPicturesListUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInBloc, CheckInState>(
      builder: (context, state) {
        return Column(
          spacing: 10,
          children: [
            TextWithAttachmentIcon(
              onCamera: ()=> context.read<CheckInBloc>().add(CapturedImageEvent(imageName: 'Internal_Picture')),
              onPreview: ()=> context.read<CheckInBloc>().add(ViewImageEvent(imageName: 'Internal_Picture')),
              onUploaded: ()=> context.read<CheckInBloc>().add(UploadImageEvent(imageName: 'Internal_Picture')),
              title: 'Internal Picture',
              attachments: context.watch<CheckInBloc>().internalPicture,
            ),
            TextWithAttachmentIcon(
              onCamera: ()=> context.read<CheckInBloc>().add(CapturedImageEvent(imageName: 'External_Picture')),
              onPreview: ()=> context.read<CheckInBloc>().add(ViewImageEvent(imageName: 'External_Picture')),
              onUploaded: ()=> context.read<CheckInBloc>().add(UploadImageEvent(imageName: 'External_Picture')),
              title: 'External Picture',
              attachments: context.watch<CheckInBloc>().externalPicture,
            ),
            TextWithAttachmentIcon(
              onCamera: ()=> context.read<CheckInBloc>().add(CapturedImageEvent(imageName: 'Registration_Sticker_Image')),
              onPreview: ()=> context.read<CheckInBloc>().add(ViewImageEvent(imageName: 'Registration_Sticker_Image')),
              onUploaded: ()=> context.read<CheckInBloc>().add(UploadImageEvent(imageName: 'Registration_Sticker_Image')),
              title: 'Registration Sticker Images',
              showCheckBox: true,
              checkBoxValue: context.watch<CheckInBloc>().showRegistrationSticker,
              onChanged: (v)=> context.read<CheckInBloc>().add(ShowImageUploadEvent(checkBoxName: 'Registration_Sticker_Image')),
              attachments: context.watch<CheckInBloc>().registrationPicture,
            ),
            TextWithAttachmentIcon(
              onCamera: ()=> context.read<CheckInBloc>().add(CapturedImageEvent(imageName: 'Toll_Images')),
              onPreview: ()=> context.read<CheckInBloc>().add(ViewImageEvent(imageName: 'Toll_Images')),
              onUploaded: ()=> context.read<CheckInBloc>().add(UploadImageEvent(imageName: 'Toll_Images')),
              title: 'Toll Images',
              showCheckBox: true,
              checkBoxValue: context.watch<CheckInBloc>().showTollSticker,
              onChanged: (v)=> context.read<CheckInBloc>().add(ShowImageUploadEvent(checkBoxName: 'Toll_Images')),
              attachments: context.watch<CheckInBloc>().tollPicture,
            ),
            TextWithAttachmentIcon(
              onCamera: ()=> context.read<CheckInBloc>().add(CapturedImageEvent(imageName: 'Odometer_Images')),
              onPreview: ()=> context.read<CheckInBloc>().add(ViewImageEvent(imageName: 'Odometer_Images')),
              onUploaded: ()=> context.read<CheckInBloc>().add(UploadImageEvent(imageName: 'Odometer_Images')),
              title: 'Odometer Images',
              attachments: context.watch<CheckInBloc>().odometerPicture,
            ),
            TextWithAttachmentIcon(
              onCamera: ()=> context.read<CheckInBloc>().add(CapturedImageEvent(imageName: 'Oil_Change_Sticker_Picture')),
              onPreview: ()=> context.read<CheckInBloc>().add(ViewImageEvent(imageName: 'Oil_Change_Sticker_Picture')),
              onUploaded: ()=> context.read<CheckInBloc>().add(UploadImageEvent(imageName: 'Oil_Change_Sticker_Picture')),
              title: 'Oil Change Sticker Picture',
              attachments: context.watch<CheckInBloc>().oilChangePicture,
            ),
            TextWithAttachmentIcon(
              onCamera: ()=> context.read<CheckInBloc>().add(CapturedImageEvent(imageName: 'Spare_Tyre_Picture')),
              onPreview: ()=> context.read<CheckInBloc>().add(ViewImageEvent(imageName: 'Spare_Tyre_Picture')),
              onUploaded: ()=> context.read<CheckInBloc>().add(UploadImageEvent(imageName: 'Spare_Tyre_Picture')),
              title: 'Spare Tyre Picture',
              showCheckBox: true,
              checkBoxValue: context.watch<CheckInBloc>().showSpareTyreSticker,
              onChanged: (v)=> context.read<CheckInBloc>().add(ShowImageUploadEvent(checkBoxName: 'Spare_Tyre_Picture')),
              attachments: context.watch<CheckInBloc>().spareTyrePicture,
            ),
            TextWithAttachmentIcon(
              onCamera: ()=> context.read<CheckInBloc>().add(CapturedImageEvent(imageName: 'Spare_Key_Picture')),
              onPreview: ()=> context.read<CheckInBloc>().add(ViewImageEvent(imageName: 'Spare_Key_Picture')),
              onUploaded: ()=> context.read<CheckInBloc>().add(UploadImageEvent(imageName: 'Spare_Key_Picture')),
              title: 'Spare Key Picture',
              showCheckBox: true,
              checkBoxValue: context.watch<CheckInBloc>().showSpareKeySticker,
              onChanged: (v)=> context.read<CheckInBloc>().add(ShowImageUploadEvent(checkBoxName: 'Spare_Key_Picture')),
              attachments: context.watch<CheckInBloc>().spareKeyPicture,
            ),
            TextWithAttachmentIcon(
              onCamera: ()=> context.read<CheckInBloc>().add(CapturedImageEvent(imageName: 'Underhood_Picture')),
              onPreview: ()=> context.read<CheckInBloc>().add(ViewImageEvent(imageName: 'Underhood_Picture')),
              onUploaded: ()=> context.read<CheckInBloc>().add(UploadImageEvent(imageName: 'Underhood_Picture')),
              title: 'Underhood Picture',
              attachments: context.watch<CheckInBloc>().underhoodPicture,
            ),
          ],
        );
      }
    );
  }
}
