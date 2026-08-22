import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'subscribe_model.dart';
export 'subscribe_model.dart';

class SubscribeWidget extends StatefulWidget {
  const SubscribeWidget({super.key});

  static String routeName = 'Subscribe';
  static String routePath = '/subscribe';

  @override
  State<SubscribeWidget> createState() => _SubscribeWidgetState();
}

class _SubscribeWidgetState extends State<SubscribeWidget> {
  late SubscribeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscribeModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFF14181B),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Subscription',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: custom_widgets.Bfmccheckout(
                    width: double.infinity,
                    height: double.infinity,
                    onPayPressed: () async {
                      _model.finalUrl = await actions.getFinalPaymobLink();
                      await launchURL(_model.finalUrl!);
                      _model.newCode = await actions.generateNewLicense();
                      FFAppState().generatedCode = _model.newCode!;
                      safeSetState(() {});

                      context.pushNamed(IPpageWidget.routeName);

                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return WebViewAware(
                            child: AlertDialog(
                              title: Text('subscription'),
                              content: Text(
                                  'Success! Your purchase is complete. Here is your license key, ${FFAppState().generatedCode} please keep it safe to activate your app.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: Text('Ok'),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                      safeSetState(() {});
                    },
                    onPrivacyPressed: () async {
                      context.pushNamed(PrivacyPolicyPageWidget.routeName);
                    },
                    onContactPressed: () async {
                      await launchUrl(Uri(
                        scheme: 'mailto',
                        path: 'osamanabel1999@gmail.com',
                      ));
                    },
                    onAboutPressed: () async {
                      context.pushNamed(AbouttWidget.routeName);
                    },
                    onRefundPressed: () async {
                      context.pushNamed(RefundWidget.routeName);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
