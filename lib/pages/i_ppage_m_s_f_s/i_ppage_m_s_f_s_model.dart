import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'i_ppage_m_s_f_s_widget.dart' show IPpageMSFSWidget;
import 'package:flutter/material.dart';

class IPpageMSFSModel extends FlutterFlowModel<IPpageMSFSWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - restoreAllSubscriptions] action in IPpageMSFS widget.
  dynamic msfsPageRes;
  // State field(s) for TextFieldipPc widget.
  FocusNode? textFieldipPcFocusNode;
  TextEditingController? textFieldipPcTextController;
  String? Function(BuildContext, String?)? textFieldipPcTextControllerValidator;
  // State field(s) for TextFieldSimbreifID widget.
  FocusNode? textFieldSimbreifIDFocusNode;
  TextEditingController? textFieldSimbreifIDTextController;
  String? Function(BuildContext, String?)?
      textFieldSimbreifIDTextControllerValidator;
  // State field(s) for TextFieldIVAOid widget.
  FocusNode? textFieldIVAOidFocusNode;
  TextEditingController? textFieldIVAOidTextController;
  String? Function(BuildContext, String?)?
      textFieldIVAOidTextControllerValidator;
  // State field(s) for CodeLicenseMSFSS widget.
  FocusNode? codeLicenseMSFSSFocusNode;
  TextEditingController? codeLicenseMSFSSTextController;
  late bool codeLicenseMSFSSVisibility;
  String? Function(BuildContext, String?)?
      codeLicenseMSFSSTextControllerValidator;
  // Stores action output result for [Custom Action - restoreAllSubscriptions] action in RichTextSpan widget.
  dynamic restoreRes1;
  // Stores action output result for [Custom Action - extendLicenseMSFS] action in Button widget.
  String? extendResult1Month;

  @override
  void initState(BuildContext context) {
    codeLicenseMSFSSVisibility = false;
  }

  @override
  void dispose() {
    textFieldipPcFocusNode?.dispose();
    textFieldipPcTextController?.dispose();

    textFieldSimbreifIDFocusNode?.dispose();
    textFieldSimbreifIDTextController?.dispose();

    textFieldIVAOidFocusNode?.dispose();
    textFieldIVAOidTextController?.dispose();

    codeLicenseMSFSSFocusNode?.dispose();
    codeLicenseMSFSSTextController?.dispose();
  }
}
