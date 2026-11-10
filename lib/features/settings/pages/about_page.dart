import 'package:flutter/material.dart';
import 'package:streak/app/theme/app_theme.dart';
import 'package:streak/app/theme/app_tokens.dart';
import 'package:streak/core/extensions/inset_extensions.dart';
import 'package:streak/core/i18n/l10n.dart';
import 'package:streak/core/utils/app_snackbar.dart';
import 'package:streak/core/widgets/entrance.dart';
import 'package:streak/core/widgets/typewriter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:streak/core/express/express_page.dart';
import 'package:provider/provider.dart';
import 'package:streak/features/settings/state/settings_controller.dart';
import 'package:streak/core/express/express_type.dart';
import 'package:streak/core/minimal/minimal_type.dart';

const _kGitHubUrl = 'https://github.com/InlitX/streak';
const _kForkUrl = 'https://github.com/nanhaizhiyun/renew-harmonyos';
const _base = Duration(milliseconds: 340);

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Future<void> _open(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) AppSnackbar.error(context, url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final muted = context.tokens.muted;

    final style = context.watch<SettingsController>().appStyle;
    final express = style == 2;

    final nameStyle = switch (style) {
      2 => ExpressType.display.at(
          48,
          height: 1,
          spacing: -0.6,
          color: scheme.onSurface,
        ),
      1 => MinimalType.display(46, color: scheme.onSurface, height: 1),
      _ => TextStyle(
          fontFamily: AppTheme.classicFont,
          fontSize: 46,
          fontWeight: FontWeight.w800,
          height: 1.0,
          letterSpacing: -1,
          color: scheme.onSurface,
        ),
    };

    final subtitleStyle = switch (style) {
      2 => ExpressType.headline.at(18, height: 1.35, weight: 700, color: muted),
      1 => MinimalType.body(18, height: 1.35, color: muted, weight: 500),
      _ => TextStyle(
          fontFamily: AppTheme.classicFont,
          fontWeight: FontWeight.w500,
          fontSize: 18,
          height: 1.3,
          color: muted,
        ),
    };

    return Scaffold(
      appBar: express
          ? expressBar()
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
      body: ListView(
        padding: context.pagePadding(24, 8, 24, 40),
        children: [
          Entrance(
            delay: _base,
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.88, end: 1),
                duration: const Duration(milliseconds: 620),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.28),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/icon.png',
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Entrance(
            index: 1,
            delay: _base,
            child: Typewriter(
              text: context.l10n.brandName,
              duration: const Duration(milliseconds: 640),
              delay: const Duration(milliseconds: 120),
              style: nameStyle,
            ),
          ),
          const SizedBox(height: 10),
          Entrance(
            index: 2,
            delay: _base,
            child: Typewriter(
              text: context.l10n.about_subtitle,
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 380),
              style: subtitleStyle,
            ),
          ),
          const SizedBox(height: 30),
          Entrance(
            index: 3,
            delay: _base,
            child: Center(
              child: _MadeBy(onTap: () => _open(_kGitHubUrl)),
            ),
          ),
          const SizedBox(height: 12),
          Entrance(
            index: 4,
            delay: _base,
            child: Center(
              child: _ViewSource(onTap: () => _open(_kForkUrl)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MadeBy extends StatelessWidget {
  const _MadeBy({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final text = context.l10n.made_by;
    final handle = context.l10n.dev_handle;
    final start = handle.isEmpty ? -1 : text.indexOf(handle);
    final style = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: scheme.onSurface.withValues(alpha: 0.85),
    );

    if (start < 0) {
      return Text(text, textAlign: TextAlign.center, style: style);
    }

    return Semantics(
      link: true,
      label: handle,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: text.substring(0, start)),
                TextSpan(
                  text: handle,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: text.substring(start + handle.length)),
              ],
            ),
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
      ),
    );
  }
}

class _ViewSource extends StatelessWidget {
  const _ViewSource({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Semantics(
      link: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            context.l10n.view_source,
            style: TextStyle(
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
