// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/post_bloc.dart';
import '../../models/feedback.dart' as types;

class FeedbackItem extends StatefulWidget {
  final types.Feedback feedback;
  const FeedbackItem({super.key, required this.feedback});

  @override
  State<FeedbackItem> createState() => _FeedbackItemState();
}

class _FeedbackItemState extends State<FeedbackItem> {
  final PostBloc postBloc = PostBloc();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
              title: Text(
                  "${widget.feedback.exUser.name} ${widget.feedback.response == 'positive' ? AppLocalizations.of(context)!.is_positive_feedback : AppLocalizations.of(context)!.is_negative_feedback}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black45)),
              trailing: widget.feedback.response == 'positive'
                  ? const Icon(Icons.sentiment_satisfied_alt,
                      size: 32, color: Colors.green)
                  : const Icon(Icons.sentiment_dissatisfied_outlined,
                      size: 32, color: Colors.green))),
    );
  }
}
