import 'dart:typed_data';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/components/custom_textfield.dart';
import 'package:evoz_web/components/custom_title.dart';
import 'package:evoz_web/controller/loja_controller.dart';
import 'package:evoz_web/events/tooltip_custom.dart';
import 'package:evoz_web/util/global.dart';
import 'package:evoz_web/util/responsive.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:url_launcher/url_launcher.dart';

class LojaView extends StatefulWidget {

  LojaView({Key? key}) : super(key: key);

  @override
  State<LojaView> createState() => _LojaViewState();
}

class _LojaViewState extends State<LojaView> {
  final _controller = LojaController();

  @override
  initState() {
    super.initState();
    _controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          return SingleChildScrollView(
            child: Form(
              key: _controller.formKey,
              child: Column(
                children: [
                  CustomTitle(
                      title: "Loja Online",
                      widget: FilledButton(
                        onPressed: () async{
                          if (await canLaunch(Global().empresa?.urlLoja??'')) {
                            await launch(Global().empresa?.urlLoja??'');
                          } else {
                            print('Erro ao tentar abrir o WhatsApp.');
                          }
                        }, 
                        child: Text("Visualizar Loja")
                      )
                  ),
                  Divider(),
                  Row(
                    children: [
                      SizedBox(
                          width: Responsive.isDesktop(context) ? 600 : 200,
                          child: CustomTextField(tec: _controller.tecEmpresa, label: "Nome Empresa")
                      ),
                      SizedBox(width: 8,),
                      Expanded(child: CustomTextField(tec: _controller.tecEmail, label: "Email"))
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: CustomTextField(
                              tec: _controller.tecWhatsApp,
                              label: "WhatsApp",
                              formatters: [
                                TelefoneInputFormatter(),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            keyboard: TextInputType.number,
                          )
                      ),
                      SizedBox(width: 8,),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: CustomTextField(tec: _controller.tecInstagram, label: "Instagram")
                      ),
                      SizedBox(width: 8,),
                      Expanded(child: CustomTextField(tec: _controller.tecFacebook, label: "Facebook",validator: false,))
                    ],
                  ),
                  SizedBox(height: 8),
                  CustomTextField(tec: _controller.tecDescricao, label: "Sobre a Empresa",maxLength: 250,),
                  SizedBox(height: 8),
                  Responsive.isDesktop(context) ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _cardImage(true, context),
                      _cardImage(false, context),
                    ],
                  ) : Column(
                    children: [
                      _cardImage(true, context),
                      _cardImage(false, context),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      const Tooltip(
                          message: "Cor que definirá principais elementos do layout, como botões e cabeçalho.",
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                          child: Text("Cor primária: ")
                      ),
                      ColorIndicator(
                        color: _controller.colorMain??Theme.of(context).colorScheme.primary,
                        height: 25,
                        width: 25,
                        borderRadius: 100,
                        onSelect: () async {
                          await colorPickerDialog(_controller.colorMain);
                        },
                      ),
                      SizedBox(width: 16),
                      const Tooltip(
                          message: "Cor que definirá o conteúdo dos principais elementos.",
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                          child: Text("Cor conteúdo primário: ")
                      ),
                      ColorIndicator(
                        color: _controller.colorOnMain??Theme.of(context).colorScheme.onPrimary,
                        height: 25,
                        width: 25,
                        borderRadius: 100,
                        onSelect: () async {
                          await colorPickerDialog(_controller.colorOnMain);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      !_controller.isLoading ? FilledButton(
                          onPressed: () async{
                            if(_controller.formKey.currentState!.validate()){
                              await _controller.saveEmpresa();
                            }
                          },
                          child: Text("Salvar")
                      ) : CircularProgressIndicator()
                    ],
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Future<bool> colorPickerDialog(Color? colorTheme) async {
    return ColorPicker(
      color: Colors.black12,
      onColorChanged: (Color color) {
        _controller.setColor(colorTheme, color);
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Selecione a cor',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Selecione a cor',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selecione a cor',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      // customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints:
      const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }

  Widget _cardImage(bool logo, BuildContext context){
    Uint8List? bytes = logo ? _controller.bytesImageLogo : _controller.bytesImageBanner;
    String text = logo ? 'Loja sem logo cadastrada' : 'Loja sem banner cadastrado';
    String? url = logo ? Global().empresa?.urlLogo : Global().empresa?.urlBanner;
    return InkWell(
      onTap: () async{
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
        if(bytesFromPicker != null){
          logo ? _controller.setImageLogo(bytesFromPicker) : _controller.setImageBanner(bytesFromPicker);
        }
      },
      child: Column(
        children: [
          Text("${logo ? "Logo" : "Banner"}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              )
          ),
          SizedBox(height: 8,),
          Card(
            elevation: 4,
            child: Container(
              height: !Responsive.isDesktop(context) ? 400 : 250,
              width: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.48 : MediaQuery.of(context).size.width * 0.9,
              child: bytes != null
                  ? Image.memory(bytes)
                  :  url != null
                  ? Image.network(url)
                  : Column( mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Icon(Icons.image_not_supported_outlined,size: 50),
                  SizedBox(height: 8,),
                  Text(text)
                ],
              ),
            ),
          ),
          SizedBox(height: 8,),
        ],
      ),
    );
  }
}
