import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'i_ppage_xplane_widget.dart' show IPpageXplaneWidget;
import 'package:flutter/material.dart';

class IPpageXplaneModel extends FlutterFlowModel<IPpageXplaneWidget> {
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
  // State field(s) for Code widget.
  FocusNode? codeFocusNode;
  TextEditingController? codeTextController;
  late bool codeVisibility;
  String? Function(BuildContext, String?)? codeTextControllerValidator;
  // Stores action output result for [Custom Action - activateLicenseXPlane] action in Button widget.
  String? statusXplane;
  // Stores action output result for [Custom Action - restoreLicenseXPlane] action in RichTextSpan widget.
  String? restoredCodeXPlane;

  @override
  void initState(BuildContext context) {
    codeVisibility = false;
  }

  @override
  void dispose() {
    textFieldipPcFocusNode?.dispose();
    textFieldipPcTextController?.dispose();

    textFieldSimbreifIDFocusNode?.dispose();
    textFieldSimbreifIDTextController?.dispose();

    textFieldIVAOidFocusNode?.dispose();
    textFieldIVAOidTextController?.dispose();

    codeFocusNode?.dispose();
    codeTextController?.dispose();
  }
}
