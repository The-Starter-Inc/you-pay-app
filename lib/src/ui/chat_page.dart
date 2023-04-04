// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/blocs/post_bloc.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'package:p2p_pay/src/theme/color_theme.dart';
import 'package:p2p_pay/src/ui/widgets/chat_post_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/text_size.dart';
import '../utils/firebase_util.dart';
import '../utils/map_util.dart';
import 'feedbacks_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.room, required this.postId});

  final types.Room room;
  final int postId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  bool _isAttachmentUploading = false;
  final PostBloc postBloc = PostBloc();
  final ExchangeBloc exchangeBloc = ExchangeBloc();

  @override
  void initState() {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Chat Page");
    FirebaseUtil.updateUserOnline(
        widget.room.id, AppConstant.firebaseUser!.uid, true);
    FirebaseUtil.updatePostId(widget.room.id, "${widget.postId}");
    postBloc.fetchPostById(widget.postId);
    exchangeBloc.fetchExchagesByQuery(
        "ads_post_id:equal:${widget.postId}|room_id:equal:${widget.room.id}");
    super.initState();
  }

  @override
  void dispose() {
    FirebaseUtil.updateUserOnline(
        widget.room.id, AppConstant.firebaseUser!.uid, false);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseUtil.updateUserOnline(
          widget.room.id, AppConstant.firebaseUser!.uid, true);
    } else if (state == AppLifecycleState.inactive) {
      FirebaseUtil.updateUserOnline(
          widget.room.id, AppConstant.firebaseUser!.uid, false);
    } else if (state == AppLifecycleState.paused) {
      FirebaseUtil.updateUserOnline(
          widget.room.id, AppConstant.firebaseUser!.uid, false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: StreamBuilder(
              stream: exchangeBloc.exchange,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  var exchange = snapshot.data![0];
                  var user = AppConstant.firebaseUser!.uid == exchange.adsUserId
                      ? exchange.exUser
                      : exchange.adsUser;
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedbacksPage(user: user)),
                        );
                      },
                      child: Row(
                        children: [
                          // Container(
                          //     width: 40,
                          //     height: 40,
                          //     margin: const EdgeInsets.only(right: 16),
                          //     decoration: BoxDecoration(
                          //       color: Colors.yellow.shade200,
                          //       borderRadius:
                          //           const BorderRadius.all(Radius.circular(46)),
                          //     ),
                          //     child: Center(
                          //       child: Text(user!.name![0],
                          //           style: Theme.of(context)
                          //               .textTheme
                          //               .titleLarge!
                          //               .copyWith(color: Colors.black)),
                          //     )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user!.name!,
                                  style: TextSize.size14),
                              Text(user.phone!,
                                  style: TextSize.size12)
                            ],
                          )
                        ],
                      ));
                }
                return Container();
              }),
          actions: [
            StreamBuilder(
                stream: postBloc.getPostById,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return IconButton(
                      padding: const EdgeInsets.only(right: 16),
                      icon: const Icon(Icons.directions,
                          size: 28),
                      onPressed: () async {
                        MapUtils.openMap(snapshot.data!.latLng.latitude,
                            snapshot.data!.latLng.longitude);
                      },
                    );
                  }
                  return Container();
                }),
            StreamBuilder(
                stream: exchangeBloc.exchange,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    var exchange = snapshot.data![0];
                    var user =
                        AppConstant.firebaseUser!.uid == exchange.adsUserId
                            ? exchange.exUser
                            : exchange.adsUser;
                    return IconButton(
                      padding: const EdgeInsets.only(right: 16),
                      icon: const Icon(Icons.phone,
                          size: 26),
                      onPressed: () async {
                        if (await canLaunchUrl(
                            Uri.parse("tel://${user!.phone}"))) {
                          await launchUrl(Uri.parse("tel://${user.phone}"));
                        } else {
                          throw 'Could not call phone intent.';
                        }
                      },
                    );
                  }
                  return Container();
                })
          ]),
      body: Stack(children: [
        StreamBuilder<types.Room>(
          initialData: widget.room,
          stream: FirebaseChatCore.instance.room(widget.room.id),
          builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) => Chat(
              theme: const DefaultChatTheme(
                inputBackgroundColor: AppColor.primaryLight,
                primaryColor: AppColor.primaryColor,
              ),
              l10n: ChatL10nEn(
                emptyChatPlaceholder:
                    AppLocalizations.of(context)!.empty_chat_msg,
                inputPlaceholder: AppLocalizations.of(context)!.type_here,
              ),
              isAttachmentUploading: _isAttachmentUploading,
              messages: snapshot.data ?? [],
              onAttachmentPressed: _handleAtachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              user: types.User(
                id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
              ),
            ),
          ),
        ),
        StreamBuilder(
            stream: postBloc.getPostById,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: ChatPostItem(post: snapshot.data!));
              }
              return Container();
            })
      ]));

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 224,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.send_with_media,
                    style: TextSize.size16),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                title: Text(AppLocalizations.of(context)!.choose_photo,
                    style: TextSize.size16),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                title: Text(AppLocalizations.of(context)!.choose_file,
                    style: TextSize.size16),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                title: Text(AppLocalizations.of(context)!.cancel,
                    style: TextSize.size16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }
}
