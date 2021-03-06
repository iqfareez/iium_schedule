import 'package:albiruni/albiruni.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/kulliyyahs.dart';
import 'schedule_maker_data.dart';
import 'schedule_steps.dart';

class InputScope extends StatefulWidget {
  const InputScope({Key? key}) : super(key: key);

  @override
  State<InputScope> createState() => _InputScopeState();
}

class _InputScopeState extends State<InputScope>
    with AutomaticKeepAliveClientMixin<InputScope> {
  final GlobalKey dropdownKey = GlobalKey();
  String _session = "2022/2023";
  int _semester = 1;
  String? _selectedKulliyah;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButtonFormField(
                        items: Kuliyyahs.all
                            .map((e) => DropdownMenuItem(
                                  value: e.code,
                                  child: Text(e.fullName),
                                ))
                            .toList(),
                        key: dropdownKey,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        value: _selectedKulliyah,
                        selectedItemBuilder: (_) => Kuliyyahs.all
                            .map((e) => Text(e.shortName))
                            .toList(),
                        hint: const Text('Select kulliyyah'),
                        onChanged: (String? value) {
                          setState(() => _selectedKulliyah = value);
                        },
                      )),
                  const SizedBox(height: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoSegmentedControl(
                        groupValue: _session,
                        children: const {
                          "2021/2022": Text("2021/2022"),
                          "2022/2023": Text("2022/2023"),
                        },
                        onValueChanged: (String value) {
                          setState(() => _session = value);
                        }),
                  ),
                  const SizedBox(height: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoSegmentedControl(
                        groupValue: _semester - 1,
                        children: List.generate(
                          3,
                          (index) => Text("Sem ${index + 1}"),
                        ).asMap(),
                        onValueChanged: (int value) {
                          setState(() => _semester = value + 1);
                        }),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: MouseRegion(
                      cursor: _selectedKulliyah == null
                          ? SystemMouseCursors.forbidden
                          : SystemMouseCursors.click,
                      child: CupertinoButton.filled(
                        onPressed: _selectedKulliyah == null
                            ? null
                            : () {
                                // Redo the same thing as in onEditingComplete above. Just in case.
                                FocusScope.of(context).unfocus();

                                ScheduleSteps.of(context)
                                    .pageController
                                    .nextPage(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.bounceInOut);

                                Albiruni albiruni = Albiruni(
                                    semester: _semester, session: _session);

                                ScheduleMakerData.albiruni = albiruni;
                                ScheduleMakerData.kulliyah = _selectedKulliyah!;
                              },
                        child: const Text('Next'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
