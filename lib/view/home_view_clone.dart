// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:evoz_web/controller/balcao_controller.dart';
// import 'package:evoz_web/util/Coloration.dart';
// import 'package:evoz_web/widget/home/chatListWidget.dart';
// import 'package:evoz_web/widget/home/headerChatListWidget.dart';
// import 'package:evoz_web/widget/home/headerChatWidget.dart';
//
// class HomeView extends StatefulWidget {
//   const HomeView({Key? key}) : super(key: key);
//
//   @override
//   State<HomeView> createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//
//   final HomeController _controller = HomeController();
//   final Coloration _coloration = Coloration();
//   final ChatListWidget _chatListWidget = ChatListWidget();
//   final HeaderChatWidget _headerChat = HeaderChatWidget();
//   final HeaderChatListWidget _headerChatList = HeaderChatListWidget();
//
//   void initState() {
//     init();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _coloration.lightGreen,
//       body: Observer(
//         builder: (context) {
//           return Container(
//             // padding: EdgeInsets.only(left: 20,top: 20),
//             child: Row(
//               children: [
//                 Container(
//                   width: 350,
//                   color: Colors.white,
//                   child: Column(
//                     children: [
//                       _headerChatList.headerLeft(),
//                       _chatListWidget.Widget(context, _controller)
//                     ],
//                   ),
//                 ),
//                 Container(color: Colors.white,child: VerticalDivider()),
//                 Expanded(
//                   child: Container(
//                     color: Colors.white,
//                     child: Column(
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: _controller.contatoSelected == null
//                           ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
//                       children: [
//                         _headerChat.mainHeader(_controller),
//                         _mainContainer(),
//                       ],
//                     ),
//                 ))
//               ],
//             ),
//           );
//         }
//       ),
//     );
//   }
//
//   Future init() async{
//     await _controller.getContatos();
//   }
//
//   // Widget _headerLeft(){
//   //   return Row(
//   //     children: [
//   //       Expanded(
//   //         child: Container(
//   //           // height: 20,
//   //             padding: EdgeInsets.all(12),
//   //             child: Row(
//   //               children: [
//   //                 Expanded(child: Text("Conversas",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),
//   //                 IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
//   //               ],
//   //             )),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//
//   // Widget _mainHeader(){
//   //   return _controller.contatoSelected == null ? Container() : Container(
//   //     padding: EdgeInsets.all(12),
//   //     child: Column(
//   //       children: [
//   //         Row(
//   //           children: [
//   //             CircleAvatar(
//   //               backgroundColor: _coloration.lightGrey,
//   //               child: Text(
//   //                 _controller.contatoSelected!.nome!.substring(0,1),
//   //                 style: TextStyle(fontSize: 18.0, color: _coloration.darkGrey),
//   //               ),
//   //             ),
//   //             Padding(
//   //               padding: const EdgeInsets.only(left: 8.0),
//   //               child: Text('${_controller.contatoSelected!.nome}',style: TextStyle(fontWeight: FontWeight.w800),),
//   //             )
//   //           ],
//   //         ),
//   //         Divider()
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Widget _mainContainer(){
//     return _controller.contatoSelected != null ?
//     Column(
//       children: [
//         Container(color: _coloration.lightGrey,),
//         Divider(),
//         TextFormField(decoration: InputDecoration(labelText: "Mensagem"),)
//       ],
//     ) :
//     Column(
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(bottom: 8.0),
//           child: Icon(Icons.smart_toy_outlined,size: 60,color: Colors.grey,),
//         ),
//         const Padding(
//           padding: EdgeInsets.only(bottom: 8.0),
//           child: Text("MigsChat",style: TextStyle(fontSize: 20),),
//         ),
//         Text("Com nossa integração com o WhatsApp, você pode enviar e receber mensagens.",style: TextStyle(color: _coloration.darkGrey),)
//       ],
//     );
//   }
// }
