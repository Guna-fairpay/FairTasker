part of 'bouncie_main_ui.dart';

class BouncieListing extends StatelessWidget {
  const BouncieListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BouncieBloc, BouncieState>(
      builder: (context, state) => Padding(
        padding: 10.spMin.padding,
        child: Column(
          spacing: 10.spMin,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CompactText("TOTAL VEHICLES: ${context.watch<BouncieBloc>().lists?.length ?? 0}", fontWeight: FontWeight.bold,),
            Expanded(child: ListView.separated(
                shrinkWrap: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                separatorBuilder: (context, index) => 5.spMin.height,
                itemBuilder: (context, index) => BouncieVehicleItem(model: context.watch<BouncieBloc>().lists?[index], onTap: () => context.read<BouncieBloc>().add(ViewBouncieEvent(context.read<BouncieBloc>().lists?[index]))),
                itemCount: context.watch<BouncieBloc>().lists?.length ?? 0))
          ],
        ),
      ),
    );
  }
}
