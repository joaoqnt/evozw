import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_dropdown.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/config_controller.dart';
import 'package:evoz_web/model/Config.dart';
import 'package:evoz_web/model/Usuario.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:evoz_web/util/criptography.dart';

class DialogUsuario{
  show(BuildContext context, ConfigController controller, {Usuario? usuario}){
    List<Widget> pages = [_page1(controller), _page2(controller)];
    if(usuario != null){
      controller.tecId.text = usuario.id.toString();
      controller.tecNome.text = usuario.nome!;
      controller.tecEmail.text = usuario.email!;
      controller.tecTelefone.text = UtilBrasilFields.obterTelefone(usuario.telefone!);
      controller.tecDataRegistro.text = FormatingDate.getDate(usuario.dataCadastro, FormatingDate.formatDDMMYYYYHHMM);
      controller.tecSenha.text = usuario.senha!;//Criptography().decryptPassword(usuario.senha!);
      controller.perfis.forEach((element) {
        if(usuario.perfil == element.perfil){
          controller.perfilSelected = element;
        }
      });
    } else{
      controller.tecId.text = "Automático";
      controller.tecNome.text = "";
      controller.tecEmail.text = "";
      controller.tecTelefone.text = "";
      controller.tecDataRegistro.text = "";
      controller.perfilSelected = null;
    }
    showDialog(context: context, builder: (context) {
      return Observer(
        builder: (context) {
          return AlertDialog(
            title: Text("Usuário"),
            content: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _containerPage("Dados", 0, controller,context),
                        _containerPage("Permissões", 1, controller,context),
                      ],
                    ),
                    Divider(),
                    pages[controller.pageSelected]
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar")
                  ),
                  controller.isLoading == true
                      ? CircularProgressIndicator(color: Colors.white) : TextButton(
                      onPressed: (){
                        if(controller.formKey.currentState!.validate()){
                          usuario != null ? controller.updateUsuario(usuario) : controller.createUsuario();
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Salvar")
                  ),
                ],
              )
            ],
          );
        }
      );
    },);
  }

  Widget _containerPage(String page, int pageIndex, ConfigController controller, BuildContext context){
    return InkWell(
      onTap: () {
        controller.setPage(pageIndex);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        // color: pageIndex == controller.pageSelected ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
        child: Text(page, style: TextStyle(fontWeight: pageIndex == controller.pageSelected ? FontWeight.bold : null)),
      ),
    );
  }

  Widget _page1(ConfigController controller){
    return Observer(
      builder: (context) {
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 90,
                  child: CustomTextField(tec: controller.tecId, label: "Código",enabled: false,),
                ),
                SizedBox(width: 8,),
                Expanded(
                    child: CustomTextField(tec: controller.tecNome, label: "Nome",validator: true,)
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      tec: controller.tecTelefone,
                      label: "Telefone",
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter()
                      ],
                      validator: true,
                      size: 11
                  ),
                ),
                SizedBox(width: 8,),
                Container(
                  width: 140,
                  child: CustomTextField(
                    tec: controller.tecDataRegistro,
                    label: "Dt Registro",
                    validator: false,
                    enabled: false,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      DataInputFormatter()
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: CustomTextField(
                        tec: controller.tecEmail,
                        label: "Email",
                        validator: true)
                ),
                SizedBox(width: 8,),
                Container(
                  width: 140,
                  child: CustomTextField(
                    tec: controller.tecSenha,
                    label: "Senha",
                    password: controller.hidePassword,
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.showPassword();
                        },
                        icon: Icon(!controller.hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined)
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _page2(ConfigController controller){
    return SingleChildScrollView(
      child: Observer(
        builder: (context) {
          return Column(
            children: [
              CustomDropDown(
                value: controller.perfilSelected,
                isExpanded: true,
                items:controller.perfis.map((e) {
                  return DropdownMenuItem(
                      value: e,
                      child: Text("${e.perfil}")
                  );
                }).toList(),
                onChange: (selectedValue) {
                  controller.setPerfil(selectedValue as Config);
                },
              ),
              Row(
                children: [
                  Expanded(
                      child: Text("Cadastro de Clientes")
                  ),
                  CupertinoSwitch(
                    value: controller.perfilSelected?.permCadCliente??false,
                    onChanged: (value) {},
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(
                      child: Text("Cadastro de Produtos")
                  ),
                  CupertinoSwitch(
                    value: controller.perfilSelected?.permCadProduto??false,
                    onChanged: (value) {},
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(
                      child: Text("Visualização de Relatórios")
                  ),
                  SizedBox(width: 8,),
                  CupertinoSwitch(
                    value: controller.perfilSelected?.permVisRelator??false,
                    onChanged: (value) {},
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(
                      child: Text("Visualização de Total de Vendas")
                  ),
                  SizedBox(width: 8,),
                  CupertinoSwitch(
                    value: controller.perfilSelected?.permVisVendas??false,
                    onChanged: (value) {},
                  ),
                ],
              )
            ]
          );
        }
      ),
    );
  }
}