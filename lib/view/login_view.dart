import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_snackbar.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/util/criptography.dart';
import 'package:evoz_web/view/menu/menu_navigation.dart';
import 'package:evoz_web/controller/login_controller.dart';
import 'package:evoz_web/util/Coloration.dart';
import 'package:mobx/mobx.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final _controller = LoginController();
  Coloration coloration = Coloration();

  @override
  Widget build(BuildContext context) {
    _controller.loadDataLogin();
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: _responsive("width", context),
                    height: _responsive("height", context),
                  child: Observer(
                    builder: (context) {
                      return Form(
                        key: _controller.formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 8,),
                              SizedBox(
                                // color: Colors.red,
                                  child: Image(
                                      image: AssetImage('assets/evoz-logo.png')
                                  ),
                                width: 320,
                              ),
                              SizedBox(height: 8,),
                              SingleChildScrollView(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: CustomTextField(
                                          tec: _controller.tecUser,
                                          label: "Email",
                                          border: OutlineInputBorder(),
                                          validator: true,
                                          onSubmitted: () async{
                                            await _doLogin(context);
                                          }
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: CustomTextField(
                                          tec: _controller.tecPassword,
                                          label: "Senha",
                                          border: OutlineInputBorder(),
                                          suffixIcon: IconButton(
                                              onPressed: (){
                                                _controller.showPassword();
                                              },
                                              icon: Icon(_controller.visibilyPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility)
                                          ),
                                          validator: true,
                                          password: !_controller.visibilyPassword,
                                          onSubmitted: () async{
                                            await _doLogin(context);
                                          }
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: CustomTextField(
                                          tec: _controller.tecIdEmpresa,
                                          label: "Id Empresa",
                                          border: OutlineInputBorder(),
                                          validator: true,
                                          onSubmitted: () async{
                                            await _doLogin(context);
                                          }
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: FilledButton(
                                                onPressed: () async {
                                                  await _doLogin(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: _controller.loading == true
                                                      ? CircularProgressIndicator(color: Colors.white,)
                                                      : Text("Entrar"),
                                                )
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                      );
                    }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  double _responsive(String type, dynamic context){
    double width = 0;
    double height = 0;
    MediaQuery.of(context).size.width < 650
        ? width = MediaQuery.of(context).size.width * 1
        : width = MediaQuery.of(context).size.width * 0.3;
     height = MediaQuery.of(context).size.width < 650
         ? MediaQuery.of(context).size.height * 1
         : MediaQuery.of(context).size.height * 0.8;
    return type == "width" ? width : height;
  }

  _doLogin(BuildContext context) async{
    if (_controller.formKey.currentState!.validate() ) {
      await _controller.doLogin(
          _controller.tecUser.text.toLowerCase(),
          _controller.tecPassword.text
      ) == true ?
      Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext) => MenuNavigation())
      )  : CustomSnackbar(
          message: "Dados incorretos. Tente Novamente",
          backgroundColor: Colors.red,
          textColor: Colors.white
      ).show(context);
    }
  }
}
