import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './../blocs/provider_bloc.dart';
import '../models/post.dart';
import 'widgets/float_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ProviderBloc providerBloc = ProviderBloc();
  TextEditingController searchController = TextEditingController();
  late List<String> filterProviders = [];
  late List<String> filterTypes = ["1", "2"];
  @override
  void initState() {
    super.initState();
    providerBloc.fetchProviders();
  }

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
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.search_here,
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          isDense: true,
                        ),
                        onSubmitted: (_) {
                          Navigator.pop(context, [
                            searchController.text,
                            filterProviders,
                            filterTypes
                          ]);
                        },
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
                child: StreamBuilder<List<Provider>>(
                    stream: providerBloc.providers,
                    builder: (context, AsyncSnapshot<List<Provider>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: snapshot.data!
                              .map((type) => FloatButton(
                                    title: type.name,
                                    icon: type.icon.url,
                                    onSelected: (selected, value) {
                                      if (selected) {
                                        filterProviders
                                            .add(value.replaceAll("Pay", ""));
                                      } else {
                                        filterProviders.remove(
                                            value.replaceAll("Pay", ""));
                                      }
                                    },
                                  ))
                              .toList(),
                        );
                      }
                      return Container();
                    }),
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
                        onSelected: (selected, value) {
                          if (selected) {
                            filterTypes.add("1");
                          } else {
                            filterTypes.remove("1");
                          }
                        },
                      ),
                      FloatButton(
                        title: AppLocalizations.of(context)!.exchange_money,
                        selected: true,
                        onSelected: (selected, value) {
                          if (selected) {
                            filterTypes.add("2");
                          } else {
                            filterTypes.remove("2");
                          }
                        },
                      )
                    ]),
              ),
              /*Container(
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
              StreamBuilder(
                  stream: providerBloc.providers,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        textDirection: TextDirection.ltr,
                        direction: Axis.horizontal,
                        runSpacing: 8.0,
                        spacing: 8.0,
                        children: [
                          ...snapshot.data!
                              .map((type) => Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          105, 128, 223, 255),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            105, 128, 223, 255),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    height: 32,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
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
                        ],
                      );
                    }
                    return Container();
                  })*/
            ],
          ),
        )
      ]),
    );
  }
}
