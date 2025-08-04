part of 'precheck_main_ui.dart';
class PrecheckListingUI extends StatelessWidget {
  const PrecheckListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrecheckBloc, PrecheckState>(
      builder: (context, state) => Column(
        children: [
          ...context.read<PrecheckBloc>().precheckList.map((e) => Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCheckboxListTile(
                title: CompactText(e['title']),
                onChanged: (v){},
                value:e['is_checked'] == 1,
                padding: 0.padding,
              ),
              Utils.getTextFormField(null, TextEditingController(), minLines: 3, maxLines: 3, inputAction: TextInputAction.done),
              SuccessButton(
                text: 'Create Task',
                onPressed: (){},
              ),
              5.spMin.height,
            ],
          ),
          ),
        ],
      ),
    );
  }
}
