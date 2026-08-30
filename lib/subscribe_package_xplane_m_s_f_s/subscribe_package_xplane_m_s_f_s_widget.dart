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
            'Dual Sim Subscriptions',
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
                    monthlyPrice: valueOrDefault<String>(
                      revenue_cat.offerings!.current!
                          .getPackage('msfs_xplane_monthly')!
                          .storeProduct
                          .priceString,
                      '-',
                    ),
                    yearlyPrice: valueOrDefault<String>(
                      revenue_cat.offerings!.current!
                          .getPackage('msfs_xplane_yearly')!
                          .storeProduct
                          .priceString,
                      '-',
                    ),
                    lifetimePrice: valueOrDefault<String>(
                      revenue_cat.offerings!.current!
                          .getPackage('msfs_xplane_lifetime')!
                          .storeProduct
                          .priceString,
                      '-',
                    ),
                    onBuyMonthly: () async {
                      _model.mSFSandXplanemonthly = await revenue_cat
                          .purchasePackage('msfs_xplane_monthly');
                      if (_model.mSFSandXplanemonthly == true) {
                        _model.currentUserId7 =
                            await actions.getRevenueCatUserId();
                        _model.generateCodeXplaneandMSFSforbothSIMMonth1 =
                            await actions.generateNewLicenseMSFSforBothSIM(
                          '1_month',
                          _model.currentUserId7,
                        );
                        _model.generateCodeXplaneandMSFSforbothSIMMonthU =
                            await actions.generateNewLicenseXPlaneforothSIM(
                          '1_month',
                          _model.currentUserId7,
                        );
                        FFAppState().generateCodeMSFS =
                            _model.generateCodeXplaneandMSFSforbothSIMMonth1!;
                        FFAppState().generatedCode =
                            _model.generateCodeXplaneandMSFSforbothSIMMonthU!;
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
                                    'Thank you for purchasing the Ultimate Dual-Sim Pass! You now have full access to both simulators.Microsoft Flight Simulator Activation Code :  ${FFAppState().generateCodeMSFS}     And X-Plane Activation Code : ${FFAppState().generatedCode}Important Note: Please make sure to copy or save these Activation Codes (or take a screenshot) before closing this page!'),
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
                        _model.currentUserId8 =
                            await actions.getRevenueCatUserId();
                        _model.generateCodeXplaneandMSFSforbothsimYearKK =
                            await actions.generateNewLicenseXPlaneforothSIM(
                          '1_yearly',
                          _model.currentUserId8,
                        );
                        _model.generateCodeXplaneandMSFSforbothSIMYearF =
                            await actions.generateNewLicenseMSFSforBothSIM(
                          '1_yearly',
                          _model.currentUserId8,
                        );
                        FFAppState().generateCodeMSFS =
                            _model.generateCodeXplaneandMSFSforbothSIMYearF!;
                        FFAppState().generatedCode =
                            _model.generateCodeXplaneandMSFSforbothsimYearKK!;
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
                                    'Thank you for purchasing the Ultimate Dual-Sim Pass! You now have full access to both simulators.Microsoft Flight Simulator Activation Code:  ${FFAppState().generateCodeMSFS}     And X-Plane Activation Code : ${FFAppState().generatedCode}Thank you for purchasing the Ultimate Dual-Sim Pass! You now have full access to both simulators.'),
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
                      _model.currentUserId16 =
                          await actions.getRevenueCatUserId();
                      _model.existingLicenseXplane =
                          await actions.checkXPlaneUserLicense(
                        _model.currentUserId16,
                      );
                      _model.existingLicenseMSFS =
                          await actions.checkMSFSUserLicense(
                        _model.currentUserId16,
                      );
                      _model.licensePlanResultXplane16 =
                          await actions.checkXPlaneLicensePlan(
                        _model.existingLicenseXplane,
                      );
                      _model.licensePlanResultMSFS16 =
                          await actions.checkMSFSLicensePlan(
                        _model.existingLicenseMSFS,
                      );
                      _model.licenseSimTypeXplane16 =
                          await actions.checkXplaneSimType(
                        _model.existingLicenseXplane,
                      );
                      _model.licenseSimTypeResultMSFS16 =
                          await actions.checkMSFSLicenseSimType(
                        _model.existingLicenseMSFS,
                      );
                      if ((_model.existingLicenseXplane == 'NOT_FOUND') &&
                          (_model.licensePlanResultMSFS16 == 'Lifetime') &&
                          (_model.licenseSimTypeResultMSFS16 == 'BothSIM') &&
                          (_model.licensePlanResultXplane16 == 'Lifetime') &&
                          (_model.licenseSimTypeXplane16 == 'BothSIM')) {
                        _model.xplanelifetime99 = await revenue_cat
                            .purchasePackage('msfs_xplane_lifetime');
                        if (_model.xplanelifetime99 == true) {
                          _model.licensMSFSforBothSim =
                              await actions.generateNewLicenseMSFSforBothSIM(
                            'lifetime',
                            _model.currentUserId16,
                          );
                          _model.licenseXplaneforBothSim =
                              await actions.generateNewLicenseXPlaneforothSIM(
                            'lifetime',
                            _model.currentUserId16,
                          );
                          FFAppState().generateCodeMSFS =
                              _model.licensMSFSforBothSim!;
                          FFAppState().generatedCode =
                              _model.licenseXplaneforBothSim!;
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
                                  title: Text('Purchase Successful!'),
                                  content: Text(
                                      'Thank you for purchasing the Ultimate Dual-Sim Pass! You now have full access to both simulators.Microsoft Flight Simulator Activation Code:${FFAppState().generateCodeMSFS}     X-Plane Activation Code :${FFAppState().generatedCode}Important Note: Please make sure to copy or save these Activation Codes (or take a screenshot) before closing this page!'),
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
                                    'You already own an active license associated with this account!  Your License Key: ${_model.existingLicenseXplane}  If your code does not appear and you want to retrieve it: • For MSFS: Go to the MSFS In-App Purchase page and tap \'Restore Purchases\'. • For X-Plane: Go to the X-Plane In-App Purchase page and tap \'Restore Purchases\'.'),
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
                    onBuyBothSims: () async {},
                    onTermsOfUse: () async {},
                    onPrivacyPolicy: () async {},
                  ),
                ),
              ),
              if (responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
                tabletLandscape: false,
                desktop: false,
              ))
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
