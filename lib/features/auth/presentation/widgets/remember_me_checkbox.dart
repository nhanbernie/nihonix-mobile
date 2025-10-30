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
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: Checkbox(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value ?? false;
              });
              widget.onChanged?.call(_isChecked);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          LocaleKeys.auth_remember_me.tr(),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
