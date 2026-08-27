import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'subscribe_m_s_f_s_model.dart';
export 'subscribe_m_s_f_s_model.dart';

class SubscribeMSFSWidget extends StatefulWidget {
  const SubscribeMSFSWidget({super.key});

  static String routeName = 'SubscribeMSFS';
  static String routePath = '/subscribeMSFS';

  @override
  State<SubscribeMSFSWidget> createState() => _SubscribeMSFSWidgetState();
}

class _SubscribeMSFSWidgetState extends State<SubscribeMSFSWidget> {
  late SubscribeMSFSModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscribeMSFSModel());
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
                  child: custom_widgets.Msfscheckout(
                    width: double.infinity,
                    height: double.infinity,
                    onBuyMonthly: () async {
                      _model.generateCodeMSFS1Month =
                          await actions.generateNewLicenseMSFS(
                        '1_month',
                      );
                      FFAppState().generateCodeMSFS =
                          _model.generateCodeMSFS1Month!;
                      safeSetState(() {});

                      context.pushNamed(IPpageMSFSWidget.routeName);

                      await Future.delayed(
                        Duration(
                          milliseconds: 1500,
                        ),
                      );
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return WebViewAware(
                            child: AlertDialog(
                              title: Text('Congratulations! '),
                              content: Text(
                                  'Here is your license key:${FFAppState().generateCodeMSFS} Keep it safe and enjoy full access!'),
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
                    onBuyYearly: () async {
                      _model.generateCodeMSFS1Year =
                          await actions.generateNewLicenseMSFS(
                        '1_year',
                      );
                      FFAppState().generateCodeMSFS =
                          _model.generateCodeMSFS1Year!;
                      safeSetState(() {});

                      context.pushNamed(IPpageMSFSWidget.routeName);

                      await Future.delayed(
                        Duration(
                          milliseconds: 1500,
                        ),
                      );
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return WebViewAware(
                            child: AlertDialog(
                              title: Text('Congratulations! '),
                              content: Text(
                                  'Here is your license key:${FFAppState().generateCodeMSFS} Keep it safe and enjoy full access!'),
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
                    onBuyLifetime: () async {
                      _model.generateCodeMSFSLifeTime =
                          await actions.generateNewLicenseMSFS(
                        'lifetime',
                      );
                      FFAppState().generateCodeMSFS =
                          _model.generateCodeMSFSLifeTime!;
                      safeSetState(() {});

                      context.pushNamed(IPpageMSFSWidget.routeName);

                      await Future.delayed(
                        Duration(
                          milliseconds: 1500,
                        ),
                      );
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return WebViewAware(
                            child: AlertDialog(
                              title: Text('Congratulations! '),
                              content: Text(
                                  'Here is your license key:${FFAppState().generateCodeMSFS} Keep it safe and enjoy full access!'),
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
                    onContactUs: () async {},
                    onBuyBothSims: () async {
                      context.pushNamed(
                          SubscribePackageXplaneMSFSWidget.routeName);
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
