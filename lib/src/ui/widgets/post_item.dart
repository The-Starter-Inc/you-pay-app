import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/Post.dart';
import '../../utils/map_util.dart';
import '../chat_page.dart';

class PostItem extends StatefulWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
              title: Text(widget.post.provider.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                      )),
              subtitle: Text("12/02/2023 04:01 PM",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black45,
                      )),
              leading: Image.asset(widget.post.provider.image.url,
                  width: 50, height: 50)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.type,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        ),
                        Text(
                          "Cash Out",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        )
                      ],
                    )),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.amount,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black45,
                            ),
                      ),
                      Text(
                        widget.post.amount.toString(),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                      )
                    ],
                  ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.percentage,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        ),
                        Text(
                          "${widget.post.percentage}%",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        )
                      ],
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.distance,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black45,
                            ),
                      ),
                      Text(
                        "${widget.post.distance}km",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                      )
                    ],
                  ))
            ],
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    MapUtils.openMap(widget.post.latLng.latitude,
                        widget.post.latLng.longitude);
                  },
                  child: Text(AppLocalizations.of(context)!.direction),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.contact,
                      style: const TextStyle(color: Colors.white)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
