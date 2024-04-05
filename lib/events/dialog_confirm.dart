import 'package:flutter/material.dart';
import 'package:evoz_web/components/custom_snackbar.dart';

class DialogConfirm {
  void show(BuildContext context, String title, bool isLoading, Function function) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text("Ao deletar, a operação não poderá ser desfeita.",
            style: TextStyle(
              fontStyle: FontStyle.italic
            ),
          ),
          actions: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    function();
                    CustomSnackbar(
                        message: "Exclusão realizada com sucesso!",
                        backgroundColor: Colors.green,
                        textColor: Colors.white
                    ).show(context);
                    Navigator.pop(context);
                  },
                  child: Text("Sim"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Não"),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
