import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/Post.dart';
import 'widgets/float_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Provider> types = [
    Provider(
        id: 1,
        image: ImageUrl(url: "assets/images/kbz-pay.png"),
        icon: ImageUrl(url: "assets/images/kbz-pay-circle.png"),
        marker: ImageUrl(url: "assets/images/kbz-marker.png"),
        name: "KBZ Pay"),
    Provider(
        id: 2,
        image: ImageUrl(url: "assets/images/cb-pay.png"),
        icon: ImageUrl(url: "assets/images/cb-pay-circle.png"),
        marker: ImageUrl(url: "assets/images/cb-marker.png"),
        name: "CB Pay"),
    Provider(
        id: 3,
        image: ImageUrl(url: "assets/images/wave-pay.png"),
        icon: ImageUrl(url: "assets/images/wave-pay-circle.png"),
        marker: ImageUrl(url: "assets/images/wave-marker.png"),
        name: "Wave Pay"),
    Provider(
        id: 4,
        image: ImageUrl(url: "assets/images/aya-pay.png"),
        icon: ImageUrl(url: "assets/images/aya-pay-circle.png"),
        marker: ImageUrl(url: "assets/images/aya-marker.png"),
        name: "Aya Pay")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 55, 16, 16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 2, right: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black45,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        height: 32,
                        width: 32,
                        margin: const EdgeInsets.only(left: 8),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black45,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.search_here,
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          isDense: true,
                        ),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: types
                      .map((type) => FloatButton(
                            title: type.name,
                            icon: type.icon.url,
                            onSelected: (selected) {},
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 55,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    children: [
                      FloatButton(
                        title: AppLocalizations.of(context)!.cash_out,
                        selected: true,
                        onSelected: (selected) {},
                      ),
                      FloatButton(
                        title: AppLocalizations.of(context)!.exchange_money,
                        selected: true,
                        onSelected: (selected) {},
                      )
                    ]),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(6, 16, 6, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.recent_search,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                textDirection: TextDirection.ltr,
                direction: Axis.horizontal,
                runSpacing: 8.0,
                spacing: 8.0,
                children: [
                  ...types
                      .map((type) => Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(105, 128, 223, 255),
                              border: Border.all(
                                color: const Color.fromARGB(105, 128, 223, 255),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            height: 32,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                type.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.black45,
                                    ),
                              ),
                            ),
                          ))
                      .toList(),
                  ...types
                      .map((type) => Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(105, 128, 223, 255),
                              border: Border.all(
                                color: const Color.fromARGB(105, 128, 223, 255),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            height: 32,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                type.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.black45,
                                    ),
                              ),
                            ),
                          ))
                      .toList()
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
