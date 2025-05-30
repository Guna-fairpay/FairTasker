part of 'project_status_ui.dart';

class ProjectStatusHeader extends StatelessWidget {
  const ProjectStatusHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.cardColor,
      elevation: 5.spMin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.spMin)),
      child: Container(
        padding: 16.spMin.padding,
        width: double.maxFinite,
        child: Column(
          spacing: 10.spMin,
          children: [
            Row(
              spacing: 16.spMin,
              children: [
                Expanded(child: Material(
                    elevation: 1.spMin, borderRadius: BorderRadius.circular(30.spMin),
                    child: CompactSearchView(
                      filled: true,
                      prefixIcon: IntrinsicHeight(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(30.spMin))
                          ),
                          padding: 8.spMin.padding,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: SizedBox.fromSize(size: Size.fromRadius(10.spMin),child: SvgPicture.asset(Assets.searchIcon, clipBehavior: Clip.antiAliasWithSaveLayer, theme: const SvgTheme(currentColor: AppC.appColor))),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(30.spMin),
                    ))),
                CompactIconButton(elevation: 1.spMin, icon: Icons.filter_alt_outlined, shape: const WidgetStatePropertyAll(CircleBorder()) , backgroundColor: Colors.white, foregroundColor: AppC.appColor, onTapDown: (details) => Console.of.log(details.globalPosition))
              ],
            ),
            FittedBox(
              child: CompactSegmentedButton<int>(
                selectedValue: 0,
                items: [
                  ButtonSegments<int>(value: 0, title: "Milestone", icon:  Icon(Icons.sports_score_rounded)),
                  ButtonSegments<int>(value: 1, title: "Backlog", icon: Icon(Icons.checklist_rounded)),
                  ButtonSegments<int>(value: 2, title: "Roadmap", icon: SizedBox.fromSize(size: Size.fromRadius(10.spMin),child: SvgPicture.asset(Assets.roadMapIcon))),
                ],
                selectedColor: AppC.appColor,
                backgroundColor: AppC.lightsGrey,
                onValueChanged: (value) {

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
