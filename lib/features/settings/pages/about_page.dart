import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const _kGitHubUrl = 'https://github.com/nanhaizhiyun/renew-harmonyos';
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
      if (mounted) {
        AppSnackbar.action(
          context,
          context.l10n.link_open_failed,
          label: context.l10n.copy_link,
          onPressed: () => Clipboard.setData(ClipboardData(text: url)),
        );
      }
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
              child: _SourceLine(onTap: () => _open(_kGitHubUrl)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceLine extends StatelessWidget {
  const _SourceLine({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final text = context.l10n.made_by;
    final handle = context.l10n.dev_handle;
    final start = handle.isEmpty ? -1 : text.indexOf(handle);
    final source = context.l10n.view_source;
    final base = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: scheme.onSurface.withValues(alpha: 0.85),
    );
    final linkStyle = TextStyle(
      color: scheme.primary,
      fontWeight: FontWeight.w700,
    );
    final spans = <InlineSpan>[
      if (start < 0)
        TextSpan(text: text)
      else ...[
        if (start > 0) TextSpan(text: text.substring(0, start)),
        TextSpan(text: handle, style: linkStyle),
        TextSpan(text: text.substring(start + handle.length)),
      ],
      const TextSpan(text: ' · '),
      TextSpan(
        text: source,
        style: linkStyle.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: scheme.primary.withValues(alpha: 0.4),
        ),
      ),
    ];

    return Semantics(
      link: true,
      label: '$text · $source',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          // vertical 14 keeps the single-line row at ~44px, the minimum touch target
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text.rich(
              TextSpan(children: spans),
              maxLines: 1,
              style: base,
            ),
          ),
        ),
      ),
    );
  }
}
