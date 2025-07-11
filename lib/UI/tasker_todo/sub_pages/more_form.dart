part of '../tasker_create_todo.dart';

class MoreForm extends StatelessWidget {
  const MoreForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => Column(
      spacing: 10.spMin,
      children: [
        if (context.watch<AddToDoBloc>().hasAddress)
        AnimatedCrossFade(firstChild: CustomMultiSelectionChipsField<Map<String, dynamic>>(
            selectedPartsList: context.watch<AddToDoBloc>().selectedAddress,
            suggestionsList: context.watch<AddToDoBloc>().addresses,
            controller: context.read<AddToDoBloc>().addressController,
            labelText: "Address",
            showEmpty: false,
            itemAsString: (item) => item['address'] ?? "", onChanged: (isChecked, value) => context.read<AddToDoBloc>().add(AddressEvent(isChecked, value))), secondChild: const SizedBox.shrink(), crossFadeState: (context.watch<AddToDoBloc>().hasAddress) ? CrossFadeState.showFirst : CrossFadeState.showSecond, duration: Durations.long3),
        if (context.watch<AddToDoBloc>().showMore)
        AnimatedCrossFade(firstChild: Row(
          spacing: 10.spMin,
          children: [
            if (context.watch<AddToDoBloc>().isRentalTask)
              ...[
                Utils.getCircleCheckWidget(() => context.read<AddToDoBloc>().add(PartStatusEvent()), context.watch<AddToDoBloc>().showParts, 'Parts/Services'),
                Utils.getCircleCheckWidget(() => context.read<AddToDoBloc>().add(SupplyStatusEvent()), context.watch<AddToDoBloc>().showSupplies, 'Supplies'),
              ],
            if (context.watch<AddToDoBloc>().hasCleanCar)
              ...[
                IconButton(
                  onPressed: () => context.read<AddToDoBloc>().add(CleanCarEvent()),
                  icon: const Icon(Icons.local_car_wash_sharp),
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide()))),
                ),
                Flexible(
                    child: Utils.dropdownBox(
                        "",
                        ToDoConfig.cleanCarDurations,
                        initialSelection: context.watch<AddToDoBloc>().selectedClearDuration,
                            (value) => context.read<AddToDoBloc>().add(CleanCarDurationEvent(value)),
                        labelKey: "value"))
              ],
          ],
        ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: (context.watch<AddToDoBloc>().showMore) ? CrossFadeState.showFirst : CrossFadeState.showSecond, duration: Durations.long3),
        AnimatedCrossFade(firstChild: CustomMultiSelectionChipsField<Map<String, dynamic>>(
            selectedPartsList: context.watch<AddToDoBloc>().selectedParts,
            suggestionsList: context.watch<AddToDoBloc>().partsList,
            controller: context.read<AddToDoBloc>().partsController,
            labelText: "Parts",
            itemAsString: (item) => item['name'].toString(),
            onChanged: (isChecked, value) => context.read<AddToDoBloc>().add(PartsEvent(isChecked, value)),
            onEmptyTap: () => context.read<AddToDoBloc>().add(NewPartsEvent())), secondChild: const SizedBox.shrink(), crossFadeState: (context.watch<AddToDoBloc>().canShowParts) ? CrossFadeState.showFirst : CrossFadeState.showSecond, duration: Durations.long3),
        AnimatedCrossFade(firstChild: CustomMultiSelectionChipsField<Map<String, dynamic>>(
            selectedPartsList: context.watch<AddToDoBloc>().selectedSupplies,
            suggestionsList: context.watch<AddToDoBloc>().suppliesList,
            controller: context.read<AddToDoBloc>().suppliesController,
            labelText: "Supplies",
            itemAsString: (item) => item['name'].toString(),
            onChanged: (isChecked, value) => context.read<AddToDoBloc>().add(SuppliesEvent(isChecked, value)),
            onEmptyTap: () => context.read<AddToDoBloc>().add(NewSuppliesEvent())), secondChild: const SizedBox.shrink(), crossFadeState: (context.watch<AddToDoBloc>().canShowSupplies) ? CrossFadeState.showFirst : CrossFadeState.showSecond, duration: Durations.long3),
        AnimatedCrossFade(firstChild: Utils.getCircleCheckWidget(() => context.read<AddToDoBloc>().add(PlatformCheckEvent()), context.watch<AddToDoBloc>().isPlatformCheck, 'Platform Check'), secondChild: const SizedBox.shrink(), crossFadeState: (context.watch<AddToDoBloc>().hasPlatformCheck) ? CrossFadeState.showFirst : CrossFadeState.showSecond, duration: Durations.long3),
      ],
    ));
  }
}
