import 'package:flutter/material.dart';
import 'package:evoz_web/util/Coloration.dart';

class CustomButtonOptions extends StatelessWidget{
  final int valueButton;
  final int valueCurrent;
  final String text;
  final Function function;

  CustomButtonOptions(this.valueButton, this.valueCurrent, this.text, this.function);

  @override
  Widget build(BuildContext context){
    return Material(
      color: valueCurrent != valueButton
          ? Theme.of(context).brightness == Brightness.dark ? Colors.blue.shade400 : Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        // hoverColor: Colors.blue.shade200,
        child: Container(
            padding: EdgeInsets.all(8),
            child: Text(text,
                style: TextStyle(
                    fontWeight: valueCurrent == valueButton ? FontWeight.bold : FontWeight.w500,
                  color: valueCurrent != valueButton
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onPrimaryContainer
                )
            )
        ),
        onTap: () {
          function();
        },
      ),
    );
  }
}