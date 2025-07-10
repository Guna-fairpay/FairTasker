part of '../tasker_create_todo.dart';

class CustomForm extends StatelessWidget {
  const CustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => Column(
      spacing: 10.spMin,
      children: [
        Row(
          spacing: 10.spMin,
          children: [
            if ((!context.watch<AddToDoBloc>().isNextTask) && context.watch<AddToDoBloc>().isRentalTask)
            Expanded(
              child: GestureDetector(
                onTap: () => context.read<AddToDoBloc>().add(MoreEvent()),
                child: CompactText('${context.watch<AddToDoBloc>().showMore ? "Less" : "More"}...', color: Colors.lightBlue.shade800),
              ),
            ),
            if (context.watch<AddToDoBloc>().isRentalOnlyTask)
            Flexible(
              flex: 2,
              child: CompactDropDown<Map<String, dynamic>>(
              items: ToDoConfig.customOptions,
              initialSelection: context.watch<AddToDoBloc>().selectedCustom,
              itemAsString: (item) => item['label'] ?? "",
              onChanged: (value) => context.read<AddToDoBloc>().add(CustomEvent(value)),
            )),
          ],
        ),
        if (context.watch<AddToDoBloc>().showReservation && context.watch<AddToDoBloc>().isRentalOnlyTask)
          ...[
            Utils.getTextFormField("${context.watch<AddToDoBloc>().selectedCustom['label']}",
                context.read<AddToDoBloc>().customLinkController,
                inputAction: TextInputAction.done,
                isDense: true,
                borderRadius: Num.borderRadius,
                contentPadding: 10.padding,
                labelStyle: context.textTheme.labelMedium
                    ?.copyWith(color: context.theme.hintColor),
                style:
                context.textTheme.labelLarge?.copyWith(fontFamily: "Lato")),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ValueListenableBuilder(
                valueListenable: context.read<AddToDoBloc>().customLinkController,
                builder: (context, value, child) => value.text.isEmpty
                    ? const SizedBox.shrink()
                    : Text.rich(
                  TextSpan(
                      text:
                      "${context.watch<AddToDoBloc>().selectedCustom['label'].toString().isCustomLink ? "Link" : "Reservation No"} - ${value.text}",
                      recognizer: TapGestureRecognizer()..onTap = () => context.read<AddToDoBloc>().add(OpenCustomLinkEvent())),
                  textAlign: TextAlign.end,
                  style: context.textTheme.labelLarge?.copyWith(
                      color: context.watch<AddToDoBloc>().reservationColor,
                      decoration: TextDecoration.underline,
                      decorationColor: AppC.appColor),
                ),
              ),
            )
          ]
      ],
    ));
  }
}