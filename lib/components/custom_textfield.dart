import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController tec;
  final String label;
  final bool? enabled;
  final Function? onChanged;
  final bool? password;
  final Widget? suffixIcon;
  final bool? visible;
  final List<TextInputFormatter>? formatters;
  final InputBorder? border;
  final bool? validator;
  final int? size;
  final String? hint;
  final bool? onlyRead;
  final Function? onSubmitted;
  final dynamic unicValue;
  final TextInputType? keyboard;
  final int? maxLength;

  CustomTextField({
    required this.tec,
    required this.label,
    this.enabled,
    this.onChanged,
    this.password,
    this.suffixIcon,
    this.visible,
    this.formatters,
    this.border,
    this.validator,
    this.size,
    this.hint,
    this.onlyRead,
    this.onSubmitted,
    this.unicValue,
    this.keyboard,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: border,
        suffixIcon: suffixIcon,
      ),
      onFieldSubmitted: (value) {
        onSubmitted != null ? onSubmitted!() : null;
      },
      validator: (value) {
        if(validator??true){
          if(value == null || value.isEmpty){
            return "Campo obrigatório";
          } else {
            if(UtilBrasilFields.removeCaracteres(value).length < (size??0)){
              return "Dados incorretos";
            } else if (value == unicValue){
              return "Valor já existente";
            }
          }
        }
      },
      controller: tec,
      enabled: enabled??true,
      obscureText: password ?? false,
      readOnly: onlyRead??false,
      onChanged: (value) {
        onChanged != null ? onChanged!() : null;
      },
      inputFormatters: formatters,
      keyboardType: keyboard,
      maxLength: maxLength,
    );
  }
}
