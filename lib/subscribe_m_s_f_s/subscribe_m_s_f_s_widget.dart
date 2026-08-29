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
                    monthlyPrice: revenue_cat.offerings!.current!
                        .getPackage('\$rc_monthly')!
                        .storeProduct
                        .priceString,
                    yearlyPrice: revenue_cat.offerings!.current!
                        .getPackage('\$rc_annual')!
                        .storeProduct
                        .priceString,
                    lifetimePrice: revenue_cat.offerings!.current!
                        .getPackage('\$rc_lifetime')!
                        .storeProduct
                        .priceString,
                    onBuyMonthly: () async {
                      _model.mSFSmonthly =
                          await revenue_cat.purchasePackage('\$rc_monthly');
                      if (_model.mSFSmonthly == true) {
                        _model.getRevenueCatUserId3 =
                            await actions.getRevenueCatUserId();
                        _model.generateCodeMSFS1Month =
                            await actions.generateNewLicenseMSFS(
                          '1_month',
                          _model.getRevenueCatUserId3,
                        );
                        FFAppState().generateCodeMSFS =
                            _model.generateCodeMSFS1Month!;
                        safeSetState(() {});

                        context.pushNamed(IPpageMSFSWidget.routeName);

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
                      _model.mSFSyearly =
                          await revenue_cat.purchasePackage('\$rc_annual');
                      if (_model.mSFSyearly == true) {
                        _model.currentUserId5 =
                            await actions.getRevenueCatUserId();
                        _model.generateCodeMSFS1Year =
                            await actions.generateNewLicenseMSFS(
                          '1_year',
                          _model.currentUserId5,
                        );
                        FFAppState().generateCodeMSFS =
                            _model.generateCodeMSFS1Year!;
                        safeSetState(() {});

                        context.pushNamed(IPpageMSFSWidget.routeName);

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
                      _model.currentUserId11 =
                          await actions.getRevenueCatUserId();
                      _model.existingLicense1 =
                          await actions.checkXPlaneUserLicense(
                        _model.currentUserId11,
                      );
                      _model.licensePlanResultMSFSuu =
                          await actions.checkMSFSLicensePlan(
                        _model.existingLicense1,
                      );
                      _model.licenseSimTypeResultMSFSuu =
                          await actions.checkMSFSLicenseSimType(
                        valueOrDefault<String>(
                          FFAppState().generateCodeMSFS,
                          '-',
                        ),
                      );
                      if ((_model.existingLicense1 == 'NOT_FOUND') &&
                          (_model.licensePlanResultMSFSuu == 'Lifetime') &&
                          (_model.licenseSimTypeResultMSFSuu == 'MSFS')) {
                        _model.xplanelifetime8 = await revenue_cat
                            .purchasePackage('xplane_lifetime');
                        if (_model.xplanelifetime8 == true) {
                          _model.generateCodeMSFSLifeTime =
                              await actions.generateNewLicenseMSFS(
                            'lifetime',
                            _model.currentUserId11,
                          );
                          FFAppState().generateCodeMSFS =
                              _model.generateCodeMSFSLifeTime!;
                          safeSetState(() {});

                          context.pushNamed(IPpageMSFSWidget.routeName);

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
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Payment failed or was cancelled. Please try again.',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                          );
                        }
                      } else {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return WebViewAware(
                              child: AlertDialog(
                                title: Text('License Already Active'),
                                content: Text(
                                    'You already own a lifetime license associated with this account!  Your License Key: ${_model.existingLicense1}  If your code does not appear, please tap \'Restore Purchases\' on the main screen.'),
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

                        context.pushNamed(IPpageMSFSWidget.routeName);
                      }

                      safeSetState(() {});
                    },
                    onContactUs: () async {
                      await launchURL('https://discord.gg/3jJkuQeKaz');
                    },
                    onBuyBothSims: () async {
                      context.pushNamed(
                          SubscribePackageXplaneMSFSWidget.routeName);
                    },
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
