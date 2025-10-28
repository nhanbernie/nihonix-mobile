import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/l10n/locale_keys.dart';

/// Remember me checkbox widget
class RememberMeCheckbox extends StatefulWidget {
  final bool initialValue;
  final Function(bool)? onChanged;

  const RememberMeCheckbox({
    super.key,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<RememberMeCheckbox> createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value ?? false;
            });
            widget.onChanged?.call(_isChecked);
          },
        ),
        Text(
          LocaleKeys.auth_remember_me.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
