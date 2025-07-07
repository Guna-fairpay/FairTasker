part of '../tasker_create_todo.dart';

class HeaderActions extends StatelessWidget {
  const HeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => Row(
      children: [
        IconButton(
            onPressed: () => context.read<AddToDoBloc>().add(AddAttachmentEvent()),
            icon: const Icon(Remix.arrow_up_line),
            color: AppC.white,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
        if (context.watch<AddToDoBloc>().hasAttachments)
        IconButton(
            onPressed: () => context.read<AddToDoBloc>().add(ViewAttachmentEvent()),
            icon: const Icon(Remix.eye_line),
            color: AppC.white,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
          10.spMin.width,
        GestureDetector(
          onTap: () => context.read<AddToDoBloc>().add(TimeSensitiveEvent()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              SizedBox(
                width: 10,
                child: Checkbox(
                  value: context.watch<AddToDoBloc>().isTimeSensitive,
                  checkColor: AppC.white,
                  // The color of the check mark
                  shape: ContinuousRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  side: BorderSide.none,
                  fillColor: WidgetStateProperty.resolveWith<Color>((states) => (states.contains(WidgetState.selected)) ? AppC.blue : AppC.white),
                  onChanged: (value) => context.read<AddToDoBloc>().add(TimeSensitiveEvent()),
                ),
              ),
              Utils.getText('Time Sensitive',
                  color: AppC.white, weight: FontWeight.bold)
            ],
          ),
        ),
        IconButton(onPressed: () => context.read<AddToDoBloc>().add(SubmitEvent()), icon: const Icon(Remix.save_3_fill), color: AppC.white, style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
        IconButton(onPressed: context.pop, icon: const Icon(Remix.close_line), color: AppC.white, style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
      ],
    ));
  }
}
