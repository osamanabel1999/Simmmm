import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'terms_o_fuse_model.dart';
export 'terms_o_fuse_model.dart';

class TermsOFuseWidget extends StatefulWidget {
  const TermsOFuseWidget({super.key});

  static String routeName = 'TermsOFuse';
  static String routePath = '/termsOFuse';

  @override
  State<TermsOFuseWidget> createState() => _TermsOFuseWidgetState();
}

class _TermsOFuseWidgetState extends State<TermsOFuseWidget> {
  late TermsOFuseModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermsOFuseModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
            'Privacy Policy',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 10.0, 0.0),
                          child: Text(
                            '\nTerms of Use for Simulator Station\n\n\n\n1. Scope of Service\n\nSimulator Station provides a virtual cockpit interface and interactive voice-checklists specifically designed for the X-Plane Flight Simulator (developed by Laminar Research). \n\nThis application is a third-party tool and is not affiliated with, authorized, or endorsed by Laminar Research.\n\n\n2. \"For Simulation Use Only\" Disclaimer\n\n• This application is strictly for Entertainment and Simulation Purposes Only within the X-Plane environment.\n\n• It is NOT a flight training device or a real-world navigational tool.\n\n• The developer assumes no liability for any real-world incidents or misuse of the software.\n\n3. Licensing & Payments (Lifetime Access)\n• One-Time Purchase: Simulator Station offers a \"Lifetime License\" for a one-time fee.\n\n• Banner Ads: Purchasing a Lifetime License provides access to premium features but does not remove the banner advertisements.\n\n Ads support the ongoing maintenance of AI voice recognition services.\n\n\n4. Hardware & Connection Requirements\n\n• Software Compatibility: This app is \ndesigned to work exclusively with X-Plane 11 and X-Plane 12.\n\n• Network: The user must ensure that \"Data Output\" is enabled within X-Plane settings and that the PC and mobile device are on the same local network.\n\n\n5. Voice Recognition\n\nBy using the Voice Checklist feature, you acknowledge that your voice commands are processed via third-party AI services to facilitate the virtual co-pilot experience in X-Plane.\n',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
