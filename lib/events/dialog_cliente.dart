import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/controller/cliente_controller.dart';
import 'package:evoz_web/model/Cliente.dart';
import 'package:evoz_web/util/FormatDate.dart';

class DialogCliente{

  show(BuildContext context, ClienteController controller,{Cliente? cliente}){
    if (cliente != null) {
      controller.tecId.text = cliente.id.toString();
      controller.tecNome.text = cliente.nome!;
      try {
        controller.tecCpf.text = UtilBrasilFields.obterCpf(cliente.cpf!);
      } catch(e){
        controller.tecCpf.text = cliente.cpf!;
      }
      controller.tecTelefone.text = UtilBrasilFields.obterTelefone(cliente.telefone!);
      controller.tecDataNasc.text = FormatingDate.getDate(cliente.dataNascimento!, FormatingDate.formatDDMMYYYY);
      controller.tecCep.text = UtilBrasilFields.obterCep(cliente.cep!);
      controller.tecCidade.text = cliente.cidade!;
      controller.tecUf.text = cliente.uf!;
      controller.tecBairro.text = cliente.bairro!;
      controller.tecRua.text = cliente.rua!;
      controller.tecEmail.text = cliente.email!;
      controller.tecNumero.text = cliente.numero.toString();
    } else {
      controller.tecId.text = "Automático";
      controller.tecNome.clear();
      controller.tecCpf.clear();
      controller.tecTelefone.clear();
      controller.tecDataNasc.clear();
      controller.tecCep.clear();
      controller.tecCidade.clear();
      controller.tecUf.clear();
      controller.tecBairro.clear();
      controller.tecRua.clear();
      controller.tecEmail.clear();
      controller.tecNumero.clear();
    }
    showDialog(context: context, builder: (context) {
      return Observer(
        builder: (context) {
          return AlertDialog(
            title: Text("Cliente"),
            content: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
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
                          Container(
                            width: 120,
                            child: CustomTextField(
                                tec: controller.tecCpf,
                                label: "CPF",
                                formatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CpfInputFormatter()
                                ],
                                validator: true,
                                size: 11
                            ),
                          ),
                          SizedBox(width: 8,),
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
                              )
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: CustomTextField(tec: controller.tecEmail, label: "Email",validator: true)),
                          SizedBox(width: 8,),
                          Container(
                            width: 100,
                            child: CustomTextField(
                                tec: controller.tecDataNasc,
                                label: "Dt Nasc",
                                validator: true,
                                formatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  DataInputFormatter()
                                ],
                                size: 8
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: CustomTextField(
                                tec: controller.tecCep,
                                label: "Cep",
                                onChanged: () async{
                                  if(UtilBrasilFields.removeCaracteres(controller.tecCep.text).length == 8){
                                    await controller.getEndereco();
                                  }
                                },
                                formatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CepInputFormatter()
                                ],
                                validator: true,
                                size: 8
                            ),
                          ),
                          SizedBox(width: 8,),
                          Expanded(
                              child: CustomTextField(tec: controller.tecCidade, label: "Cidade",validator: true)
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 30,
                            child: CustomTextField(tec: controller.tecUf, label: "UF",validator: true),
                          ),
                          SizedBox(width: 8,),
                          Expanded(child: CustomTextField(tec: controller.tecBairro, label: "Bairro",validator: true))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: CustomTextField(tec: controller.tecRua, label: "Logradouro",validator: true)),
                          SizedBox(width: 8,),
                          Container(
                            width: 80,
                            child: CustomTextField(
                                tec: controller.tecNumero,
                                label: "Número",
                                validator: true,
                                formatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ]
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar"),
                  ),
                  controller.isLoading
                      ? CircularProgressIndicator()
                      : TextButton(
                    onPressed: () async {
                      if (controller.formKey.currentState!.validate()) {
                        if(cliente != null) {
                          await controller.updateCliente(cliente);
                        } else {
                          await controller.createCliente();
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Salvar"),
                  ),
                ],
              ),
            ],
          );
        }
      );
    },);
  }
}