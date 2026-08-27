import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'i_ppage_m_s_f_s_widget.dart' show IPpageMSFSWidget;
import 'package:flutter/material.dart';

class IPpageMSFSModel extends FlutterFlowModel<IPpageMSFSWidget> {
  ///  State fields for stateful widgets in this page.

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
  // State field(s) for CodeLicenseMSFS widget.
  FocusNode? codeLicenseMSFSFocusNode;
  TextEditingController? codeLicenseMSFSTextController;
  late bool codeLicenseMSFSVisibility;
  String? Function(BuildContext, String?)?
      codeLicenseMSFSTextControllerValidator;
  // Stores action output result for [Custom Action - activateLicenseMSFS] action in Button widget.
  String? statusMSFS;

  @override
  void initState(BuildContext context) {
    codeLicenseMSFSVisibility = false;
  }

  @override
  void dispose() {
    textFieldipPcFocusNode?.dispose();
    textFieldipPcTextController?.dispose();

    textFieldSimbreifIDFocusNode?.dispose();
    textFieldSimbreifIDTextController?.dispose();

    textFieldIVAOidFocusNode?.dispose();
    textFieldIVAOidTextController?.dispose();

    codeLicenseMSFSFocusNode?.dispose();
    codeLicenseMSFSTextController?.dispose();
  }
}
