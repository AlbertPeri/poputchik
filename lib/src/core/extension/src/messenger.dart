import 'dart:io';

import 'package:companion/src/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension Messenger on ScaffoldMessengerState {
  void showMessage(String? text, {Duration? duration}) => this
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          text ?? context.localized.error,
          style: const TextStyle(height: 1.4),
        ),
        duration: duration ?? const Duration(milliseconds: 4000),
      ),
    );

  /// Показать диалог действия
  void showAlertDialog(
    BuildContext context, {
    required String title,
    String? acceptLabel,
    String? cancelLabel,
    String? content,
    VoidCallback? onAccept,
    Color? acceptLabelColor,
    bool barrierDismissible = true,
  }) =>
      !Platform.isIOS
          ? showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                actionsPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                title: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
                content: content != null
                    ? Text(
                        content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      )
                    : null,
                alignment: Alignment.center,
                scrollable: true,
                actionsOverflowAlignment: OverflowBarAlignment.center,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  SizedBox(
                    width: context.mediaQuery.size.width,
                    child: acceptLabelColor != null
                        ? Column(
                            children: [
                              SizedBox(
                                height: 40,
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: Navigator.maybeOf(context)?.pop,
                                  child: Text(
                                    cancelLabel ??
                                        MaterialLocalizations.of(context)
                                            .cancelButtonLabel,
                                    style: TextStyle(
                                      color: acceptLabelColor,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      child: Text(
                                        acceptLabel ??
                                            MaterialLocalizations.of(context)
                                                .okButtonLabel,
                                      ),
                                      onPressed: () {
                                        onAccept?.call();
                                        Navigator.maybeOf(context)?.pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: (acceptLabel != null)
                                        ? OutlinedButton(
                                            onPressed: () {
                                              onAccept?.call();
                                              Navigator.maybeOf(context)?.pop();
                                            },
                                            child: Text(
                                              MaterialLocalizations.of(context)
                                                  .okButtonLabel,
                                              style: TextStyle(
                                                color: acceptLabelColor,
                                              ),
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: () {
                                              onAccept?.call();
                                              Navigator.maybeOf(context)?.pop();
                                            },
                                            child: Text(
                                              MaterialLocalizations.of(
                                                context,
                                              ).okButtonLabel,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              if (acceptLabel != null)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 40,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed:
                                            Navigator.maybeOf(context)?.pop,
                                        child: Text(
                                          cancelLabel ??
                                              MaterialLocalizations.of(context)
                                                  .cancelButtonLabel,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            )
          : showCupertinoDialog<void>(
              barrierDismissible: barrierDismissible,
              context: context,
              builder: (context) => Theme(
                data: context.theme.copyWith(
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    primaryColor: Colors.white,
                  ),
                ),
                child: CupertinoAlertDialog(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(title),
                  ),
                  content: content != null ? Text(content) : null,
                  actions: acceptLabelColor != null
                      ? <CupertinoDialogAction>[
                          if (acceptLabel != null)
                            CupertinoDialogAction(
                              onPressed: Navigator.maybeOf(context)?.pop,
                              child: Text(
                                cancelLabel ??
                                    MaterialLocalizations.of(context)
                                        .cancelButtonLabel
                                        .capitalize(),
                              ),
                            ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () {
                              onAccept?.call();
                              Navigator.maybeOf(context)?.pop();
                            },
                            child: Text(
                              acceptLabel ??
                                  MaterialLocalizations.of(context)
                                      .okButtonLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: acceptLabelColor,
                              ),
                            ),
                          ),
                        ]
                      : <CupertinoDialogAction>[
                          if (acceptLabel != null)
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: Navigator.maybeOf(context)?.pop,
                              child: Text(
                                cancelLabel ??
                                    MaterialLocalizations.of(context)
                                        .cancelButtonLabel
                                        .capitalize(),
                              ),
                            ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              onAccept?.call();
                              Navigator.maybeOf(context)?.pop();
                            },
                            child: Text(
                              acceptLabel ??
                                  MaterialLocalizations.of(context)
                                      .okButtonLabel,
                              style: TextStyle(
                                color: acceptLabelColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                ),
              ),
            );
}
