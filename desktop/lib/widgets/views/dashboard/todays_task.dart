import 'package:flutter/material.dart';
import 'package:lb_planner/ui.dart';

class DashboardTodaysTasksItem extends StatelessWidget {
  DashboardTodaysTasksItem({Key? key, required this.id, this.margin = true}) : super(key: key);

  final int id;
  final bool margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(bottom: margin ? NcSpacing.smallSpacing : 0),
      width: 400,
      height: 40,
      decoration: BoxDecoration(
        color: NcThemes.current.secondaryColor,
        borderRadius: BorderRadius.circular(ncRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NcTag(
            fontSize: 18,
            height: 27,
            text: 'AM',
            //TODO:text: DB.courses[DB.modules[id]!.course]!.tag,
            backgroundColor: NcThemes.current.accentColor,
            //width: 40,
          ),
          NcSpacing.xs(),
          Expanded(
            child: NcCaptionText(
              //TODO:DB.modules[id]!.name,
              'Hallddddddddddddddddddddddddddddddo',
              textAlign: TextAlign.center,
              fontSize: 20,
            ),
          ),
          NcSpacing.xs(),
          NcCheckBox(
            interactable: false,
            radius: 6.5,
            onChanged: (_) {},
            width: 20,
            height: 20,
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}
