import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final dynamic value;
  final List<DropdownMenuItem<dynamic>>? items;
  final Function(dynamic)? onChange;
  final bool? isExpanded;
  final String? hint;

  CustomDropDown({
    this.value,
    this.isExpanded,
    this.hint,
    required this.items,
    required this.onChange
  }) ;

  @override
  Widget build(BuildContext context) {
    return  DropdownButton(
      value: value,
      isExpanded: isExpanded??false,
      underline: Container(),
      hint: Text(hint??''),
      items: items,
      onChanged: (selectedValue) {
        onChange?.call(selectedValue); // Chama a função onChange com o valor selecionado
      },
    );
  }
}