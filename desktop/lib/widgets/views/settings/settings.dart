import 'package:desktop/dialogs/confirm_clear_cache.dart';
import 'package:desktop/dialogs/confirm_delete_profile.dart';
import 'package:desktop/version.dart';
import 'package:desktop/widgets/course_selection/course_selection.dart';
import 'package:desktop/widgets/views/dashboard/dashboard.dart';
import 'package:desktop/widgets/views/settings/credits.dart';
import 'package:desktop/widgets/views/settings/feedback.dart';
import 'package:desktop/widgets/views/settings/general.dart';
import 'package:desktop/widgets/views/settings/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lb_planner/ui.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  SettingsState state = SettingsState.Settings;

  _showSettings() {
    setState(() {
      state = SettingsState.Settings;
    });
  }

  _showCredits() {
    setState(() {
      state = SettingsState.Credits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NcView(
      builder: (context, route(Widget view), pop()) => NcView.route(
        title: "Settings",
        content: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: NcContainer(
                            label: NcCaptionText(
                              "General",
                              fontSize: Dashboard.titleSize,
                            ),
                            body: ListView(
                              children: [
                                SettingsGeneralItem(
                                  text: version,
                                  icon: Icons.update,
                                  onTap: () {
                                    // TODO: Check for updates
                                    NcSnackBar.showBottomRightMessage(
                                      context,
                                      prefixIcon: Icon(
                                        Icons.update,
                                        color: NcThemes.current.textColor,
                                      ),
                                      message: "You already are up to date!",
                                    );
                                  },
                                ),
                                NcSpacing.small(),
                                SettingsGeneralItem(
                                  text: "Clear Cache",
                                  icon: Icons.arrow_forward_ios,
                                  onTap: () {
                                    showConfirmClearCache(context);
                                  },
                                ),
                                NcSpacing.small(),
                                SettingsGeneralItem(
                                  text: "Delete Profile",
                                  icon: Feather.trash_2,
                                  onTap: () {
                                    showDeleteProfileDialog(context);
                                    // TODO: Check for updates
                                  },
                                ),
                                NcSpacing.small(),
                                SettingsGeneralItem(
                                  text: "Credits",
                                  icon: Icons.info_outline,
                                  onTap: route(Credits(goBack: pop)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        NcSpacing.large(),
                        Expanded(
                          flex: 3,
                          child: NcContainer(
                            label: NcCaptionText(
                              "Themes",
                              fontSize: Dashboard.titleSize,
                            ),
                            body: NcGridView(
                              spacing: NcSpacing.xlSpacing,
                              children: [
                                // TODO: for (var theme in User.current.themes) ThemeItem(theme: theme),
                                for (var theme in NcThemes.all.keys) ThemeItem(theme: theme),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  NcSpacing.large(),
                  Expanded(
                    flex: 2,
                    child: CourseSelection(),
                  )
                ],
              ),
            ),
            NcSpacing.large(),
            Expanded(
              child: NcContainer(
                label: NcCaptionText(
                  "Feedback",
                  fontSize: Dashboard.titleSize,
                ),
                body: SettingsFeedback(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SettingsState { Settings, Credits }
