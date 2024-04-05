import 'package:brasil_fields/brasil_fields.dart';
import 'package:evoz_web/controller/venda_controller.dart';
import 'package:evoz_web/model/Venda.dart';
import 'package:evoz_web/util/FormatDate.dart';
import 'package:evoz_web/util/global.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class VendaPdf{
  Venda venda;
  VendaPdf(this.venda,);

  Future generatePdf() async{
    final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat(297.0, 1000,marginLeft: 1,marginRight: 1),
          build: (pw.Context context) {
           return pw.Column(
             children: [
               _headerOfPdf(),
               pw.SizedBox(height: 8),
               _headerOfTablePdf(),
               _tableOfPdf()
             ]
           );
          }
      ),
        // pw.MultiPage(
        //     maxPages: 100,
        //     pageFormat: PdfPageFormat(width, height),
        //     header: (pw.Context context) {
        //       return _headerOfPdf();
        //     },
        //     build: (pw.Context context) => <pw.Widget>[
        //       _headerOfTablePdf(),
        //       _tableOfPdf()
        //     ]
        // )
    );
    await Printing.sharePdf(bytes: await pdf.save(), filename: '${venda.id}.pdf',);
  }

  _headerOfPdf(){
    return pw.Column(
        children: [
          pw.Text('Primeiro Cliente',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 14)
          ),
          pw.Text('** MESA teste **',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 16)
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Text(
                "Atendente: ${Global().usuario!.nome}",
              ),
            ]
          ),
          pw.Row(
            children: [
              pw.Text(
                "${FormatingDate.getDate(DateTime.now(), FormatingDate.formatDDMMYYYYHHMM)}",
              ),
            ]
          ),
          pw.Divider(),
        ]
    );
  }

  // _infoOfPdf(){
  //   return pw.Column(
  //     // mainAxisAlignment: pw.MainAxisAlignment.start,
  //     children: [
  //
  //     ]
  //   );
  // }

  _headerOfTablePdf() {
    return pw.Container(
      child: pw.Row(
        children: [
          _buildTableCell(pw.Text("qtd"), flex: 1),
          _buildTableCell(
              pw.Text("produto"),
              flex: 3
          ),
          _buildTableCell(
              pw.Text("und",),
              flex: 3,
          ),
          _buildTableCell(
              pw.Text("total",),
              flex: 7,
          ),
        ],
      ),
    );
  }

  _buildTableCell(pw.Widget text, {int flex = 1, bool isCentered = false, bool isLast = false}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Container(
        // padding: pw.EdgeInsets.only(left: isLast ? 3 : 0),
        alignment: isCentered ? pw.Alignment.center : pw.Alignment.centerLeft,
        child: text,
      ),
    );
  }

  _tableOfPdf(){
    return pw.ListView.builder(
      itemCount: venda.itens.length,
      itemBuilder: (context, index) {
        return pw.Container(
          // padding: pw.EdgeInsets.only(top: 4.0),
          child: pw.Row(
            children: [
              _buildTableCell(pw.Text("${venda.itens[index].quantidade}"), flex: 1),
              _buildTableCell(pw.Text("${venda.itens[index].produto?.nome}"), flex: 3),
              _buildTableCell(
                  pw.Row(
                    children: [
                      pw.Text("R\$ ",style: pw.TextStyle(fontSize: 10)),
                      pw.Text("${venda.itens[index].precoUnitario!.toStringAsFixed(2)}",)
                    ]
                  ),
                  flex: 3,
                  // isCentered: true
              ),
              _buildTableCell(
                  pw.Row(
                      children: [
                        pw.Text("R\$ ",style: pw.TextStyle(fontSize: 10)),
                        pw.Text("${venda.itens[index].preco!.toStringAsFixed(2)}",)
                      ]
                  ),
                  flex: 7,
                  isLast:  true
              ),
            ],
          ),
        );
      },
    );
  }
}