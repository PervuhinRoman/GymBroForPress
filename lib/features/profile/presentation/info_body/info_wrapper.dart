// Class for objects for visual presentation of Entries and Gallery

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/profile/presentation/info_body/info_body_adapter.dart';
import '../profile_body.dart';
import 'package:gymbro/core/_dev/debug_tools.dart';

class InfoWrapper extends StatelessWidget {
  const InfoWrapper({
    super.key,
    required this.header,
    this.optionalButton,
    required this.infoBody,
  });

  final String header;
  final IconButton? optionalButton;
  final InfoBody infoBody;

  static const double _divHeight = 0.5;
  static const double _divThickness = 1;

  @override
  Widget build(BuildContext context) {
    final ibSepHeight = ProfileBody.ibSepHeight;
    return Column(
      children: [
        InfoSeparator(ibSepHeight: ibSepHeight),
        InfoHeader(header),
        Divider(
          height: _divHeight,
          thickness: _divThickness,
        ),
        infoBody,
      ],
    );
  }
}

class InfoSeparator extends StatelessWidget {
  const InfoSeparator({
    super.key,
    required this.ibSepHeight,
  });

  final double ibSepHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DebugBox(height: ibSepHeight),
        ),
      ],
    );
  }
}

class InfoHeader extends StatelessWidget {
  const InfoHeader(
    this.header,{
    super.key,
    this.sideButton,
  });

  final String header;
  final IconButton? sideButton;

  static const double _ihLeftPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData contextTheme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ColoredBox(
            color: contextTheme.colorScheme.primary,
            child: Padding(
              padding: EdgeInsets.fromLTRB(_ihLeftPadding, 8.0, 8.0, 8.0),
              child: Text(
                header,
                style: contextTheme.textTheme.bodyLarge?.copyWith(
                  color: contextTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          )
        ),
        sideButton ?? SizedBox.shrink(),
      ]
    );
  }
}

