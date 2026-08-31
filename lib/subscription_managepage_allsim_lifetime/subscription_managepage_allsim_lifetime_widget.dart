import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'subscription_managepage_allsim_lifetime_model.dart';
export 'subscription_managepage_allsim_lifetime_model.dart';

class SubscriptionManagepageAllsimLifetimeWidget extends StatefulWidget {
  const SubscriptionManagepageAllsimLifetimeWidget({super.key});

  static String routeName = 'subscriptionManagepageAllsimLifetime';
  static String routePath = '/subscriptionManagepageAllsimLifetime';

  @override
  State<SubscriptionManagepageAllsimLifetimeWidget> createState() =>
      _SubscriptionManagepageAllsimLifetimeWidgetState();
}

class _SubscriptionManagepageAllsimLifetimeWidgetState
    extends State<SubscriptionManagepageAllsimLifetimeWidget> {
  late SubscriptionManagepageAllsimLifetimeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => SubscriptionManagepageAllsimLifetimeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.currentPlanTypeMSFS = await actions.getPlanTypeMSFS(
        FFAppState().generateCodeMSFS,
      );
      FFAppState().currentPlanTypeMSFS = FFAppState().currentPlanTypeMSFS;
      safeSetState(() {});
    });
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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
            'Subscription ',
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
                  child: custom_widgets.SmartSubscriptionWidget(
                    width: double.infinity,
                    height: double.infinity,
                    onRestorePressed: () async {},
                    onManageAppleSubscription: () async {},
                    onSupportPressed: () async {},
                    onPrivacyPolicyPressed: () async {},
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
