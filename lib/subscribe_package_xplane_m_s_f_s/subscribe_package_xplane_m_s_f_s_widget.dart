import '/flutter_flow/flutter_flow_ad_banner.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'subscribe_package_xplane_m_s_f_s_model.dart';
export 'subscribe_package_xplane_m_s_f_s_model.dart';

class SubscribePackageXplaneMSFSWidget extends StatefulWidget {
  const SubscribePackageXplaneMSFSWidget({super.key});

  static String routeName = 'SubscribePackageXplaneMSFS';
  static String routePath = '/subscribePackageXplaneMSFS';

  @override
  State<SubscribePackageXplaneMSFSWidget> createState() =>
      _SubscribePackageXplaneMSFSWidgetState();
}

class _SubscribePackageXplaneMSFSWidgetState
    extends State<SubscribePackageXplaneMSFSWidget> {
  late SubscribePackageXplaneMSFSModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscribePackageXplaneMSFSModel());
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
                  child: custom_widgets.UltimateBundleCheckout(
                    width: double.infinity,
                    height: double.infinity,
                    monthlyPrice: revenue_cat.offerings!.current!
                        .getPackage('msfs_xplane_monthly')!
                        .storeProduct
                        .priceString,
                    yearlyPrice: revenue_cat.offerings!.current!
                        .getPackage('msfs_xplane_yearly')!
                        .storeProduct
                        .priceString,
                    lifetimePrice: revenue_cat.offerings!.current!
                        .getPackage('msfs_xplane_yearly')!
                        .storeProduct
                        .priceString,
                    onBuyMonthly: () async {
                      _model.mSFSandXplanemonthly = await revenue_cat
                          .purchasePackage('msfs_xplane_monthly');
                      if (_model.mSFSandXplanemonthly == true) {
                        _model.generateCodeXplaneandMSFS1Month1 =
                            await actions.generateNewLicenseMSFS(
                          '1_month',
                        );
                        _model.generateCodeXplaneandMSFS1Month2 =
                            await actions.generateNewLicenseXPlane(
                          '1_month',
                        );
                        FFAppState().generateCodeMSFS =
                            _model.generateCodeXplaneandMSFS1Month1!;
                        FFAppState().generatedCode =
                            _model.generateCodeXplaneandMSFS1Month2!;
                        safeSetState(() {});

                        context.pushNamed(HomeMenuWidget.routeName);

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
                                    'Thank you for purchasing the Ultimate Dual-Sim Pass! You now have full access to both simulators.Your Activation License Keys:Microsoft Flight Simulator:  ${FFAppState().generateCodeMSFS}     And X-Plane License: ${FFAppState().generatedCode} Important Note: Please make sure to copy or save these keys (or take a screenshot) before closing this page!'),
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Payment failed or was cancelled. Please try again.',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                        );
                      }

                      safeSetState(() {});
                    },
                    onBuyYearly: () async {
                      _model.mSFSandXplaneyearly1 = await revenue_cat
                          .purchasePackage('msfs_xplane_yearly');
                      if (_model.mSFSandXplaneyearly1 == true) {
                        _model.generateCodeXplaneandMSFS1Year2 =
                            await actions.generateNewLicenseXPlane(
                          '1_yearly',
                        );
                        _model.generateCodeXplaneandMSFS1Year1 =
                            await actions.generateNewLicenseMSFS(
                          '1_yearly',
                        );
                        FFAppState().generateCodeMSFS =
                            _model.generateCodeXplaneandMSFS1Year1!;
                        FFAppState().generatedCode =
                            _model.generateCodeXplaneandMSFS1Month2!;
                        safeSetState(() {});

                        context.pushNamed(HomeMenuWidget.routeName);

                        await Future.delayed(
                          Duration(
                            milliseconds: 500,
                          ),
                        );
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return WebViewAware(
                              child: AlertDialog(
                                title: Text('Congratulations! '),
                                content: Text(
                                    'Thank you for purchasing the Ultimate Dual-Sim Pass! You now have full access to both simulators.Your Activation License Keys:Microsoft Flight Simulator:  ${FFAppState().generateCodeMSFS}     And X-Plane License: ${FFAppState().generatedCode} Important Note: Please make sure to copy or save these keys (or take a screenshot) before closing this page!'),
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Payment failed or was cancelled. Please try again.',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                        );
                      }

                      safeSetState(() {});
                    },
                    onBuyLifetime: () async {
                      _model.mSFSandXplanelifetime = await revenue_cat
                          .purchasePackage('msfs_xplane_lifetime');
                      if (_model.mSFSandXplaneyearly1 == true) {
                        _model.generateCodeXplaneandMSFSlifetime2 =
                            await actions.generateNewLicenseXPlane(
                          'lifetime',
                        );
                        _model.generateCodeXplaneandMSFSlifetime1 =
                            await actions.generateNewLicenseMSFS(
                          'lifetime',
                        );
                        FFAppState().generateCodeMSFS =
                            _model.generateCodeXplaneandMSFSlifetime1!;
                        FFAppState().generatedCode =
                            _model.generateCodeXplaneandMSFS1Month2!;
                        safeSetState(() {});

                        context.pushNamed(HomeMenuWidget.routeName);

                        await Future.delayed(
                          Duration(
                            milliseconds: 500,
                          ),
                        );
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return WebViewAware(
                              child: AlertDialog(
                                title: Text('Congratulations! '),
                                content: Text(
                                    'Thank you for purchasing the Ultimate Dual-Sim Pass! You now have full access to both simulators.Your Activation License Keys:Microsoft Flight Simulator:  ${FFAppState().generateCodeMSFS}     And X-Plane License: ${FFAppState().generatedCode} Important Note: Please make sure to copy or save these keys (or take a screenshot) before closing this page!'),
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Payment failed or was cancelled. Please try again.',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                        );
                      }

                      safeSetState(() {});
                    },
                    onContactUs: () async {},
                    onBuyBothSims: () async {},
                  ),
                ),
              ),
              FlutterFlowAdBanner(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 50.0,
                showsTestAd: false,
                iOSAdUnitID: 'ca-app-pub-7880697829268273/6177072322',
                androidAdUnitID: 'ca-app-pub-7880697829268273/5581116466',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
