// Class for objects for visual presentation of Entries and Gallery

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/profile/presentation/info_body/info_body_adapter.dart';
import '../profile_body.dart';
import 'package:gymbro/features/profile/presentation/profile_configs.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(height: InfoWrapperConfig.ibSepHeight),
            ),
          ],
        ),
        InfoHeader(header),
        Divider(
          height: InfoWrapperConfig.divHeight,
          thickness: InfoWrapperConfig.divThickness,
        ),
        infoBody,
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

  final double _ihLeftPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData contextTheme = Theme.of(context);

    return SizedBox(
      child: Expanded(
        child: ColoredBox(
          color: contextTheme.colorScheme.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(_ihLeftPadding, 8.0, 8.0, 8.0),
                child: Text(
                  header,
                  style: contextTheme.textTheme.titleMedium?.copyWith(
                    color: contextTheme.colorScheme.onPrimary,
                  ),
                ),
              ),
              sideButton ?? SizedBox.shrink(),
            ],
          ),
        )
      ),
    );
  }
}

