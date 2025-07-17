part of 'archived_task_main_ui.dart';

class ArchivedTaskListingUI extends StatelessWidget {
  const ArchivedTaskListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchivedBloc, ArchivedState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: DateRangePicker(
                      padding: 10.padding,
                      selectedDateRange: context.watch<ArchivedBloc>().selectedDateRange,
                      onDateRangeSelected: (value)=> context.read<ArchivedBloc>().add(DateRangePickerEvent(value)),),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CompactText(
                      "Selected: 1",
                      fontWeight: FontWeight.bold,
                    ),
                    CustomCheckboxListTile(
                      title: const Text('Select All'),
                      isCheckboxOnRight: true,
                      value: context.watch<ArchivedBloc>().isSelectAll,
                      onChanged: (v)=> context.read<ArchivedBloc>().add(SelectAllEvent()),
                      padding: 0.padding,
                      borderColor: AppC.appColor,
                      radius: 14.spMin,
                      useExpand: false,
                    )
                  ],
                ),
                const CompactText('UNARCHIVE')
              ],
            ),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(height: 0.5),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return SafeArea(
                    minimum: 10.verticalPadding,
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CompactText('Private Rental Checkout', fontWeight: FontWeight.bold, color: AppC.appColor,overflow: TextOverflow.ellipsis,),
                                CompactText('2015 Chevrolet Sonic',overflow: TextOverflow.ellipsis,),
                                CompactText('(C/O 07-17-25 21:00 )', color: AppC.grey, overflow: TextOverflow.ellipsis,),
                              ]),
                        ),
                        Expanded(
                          child: Column(
                              spacing: 5,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const CompactText('07-17 09:15 PM', overflow: TextOverflow.visible,),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  spacing: 10,
                                  children: [
                                    const Flexible(child: CompactText('IA,DB,ZA', fontWeight: FontWeight.bold, color: AppC.black, overflow: TextOverflow.ellipsis,)),
                                    FittedBox(
                                      child: SizedBox.fromSize(
                                        size:  Size.fromRadius(14.spMin),
                                        child:  Checkbox(
                                          activeColor: AppC.appColor,
                                          value: (false),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          side: const BorderSide(width: 0.8, color: AppC.appColor),
                                          onChanged: (v){},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        );
      }
    );
  }
}
