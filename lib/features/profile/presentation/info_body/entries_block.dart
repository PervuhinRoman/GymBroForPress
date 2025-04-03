import 'package:flutter/material.dart';
import 'package:gymbro/core/_dev/debug_tools.dart';
import 'package:gymbro/features/profile/presentation/info_body/info_body_adapter.dart';
import 'info_wrapper.dart';
import 'package:gymbro/core/widgets/double_text.dart';

class InfoClause {
  const InfoClause(
    this.label,
    this.info,
  );

  final String info;
  final String label;
}

class Entries extends StatelessWidget implements InfoBody {
  const Entries({
    super.key,
    required this.infoClauses,
  });

  final List<InfoClause> infoClauses;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        for(var clause in infoClauses) 
          InfoEntry(
            infoClause: clause,
          ),
        ]
      );
  }
}

class InfoEntry extends StatelessWidget {
  const InfoEntry({
    super.key,
    required this.infoClause,
  });

  final InfoClause infoClause;

  static const double _ibLeftPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData contextTheme = Theme.of(context);

    return Column(
      children: [
        ColoredBox(
          color: contextTheme.colorScheme.secondary,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: _ibLeftPadding),
                    child: DoubleTextDisplay(
                      topText: infoClause.info,
                      topColor: contextTheme.colorScheme.onSecondary,

                      bottomText: infoClause.label,
                      bottomColor: Color.lerp(contextTheme.colorScheme.onSecondary, Colors.grey, 0.3),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]
    );
  }
}

