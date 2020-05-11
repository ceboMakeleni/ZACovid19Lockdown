import 'dart:convert';

import 'package:CovidLockdownAlert/models/covid19zatimeline.dart';
import 'package:CovidLockdownAlert/models/regulation.dart';
import 'package:CovidLockdownAlert/models/regulationrule.dart';
import 'package:CovidLockdownAlert/models/subplacelookup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:random_color/random_color.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';

void main() => runApp(RootAppPage());

List<SettingsItemModel> suburbItems = [];
List<SubPlaceLookup> litems = [];
List<Covid19ZATimeline> lCovid19ZATimeline = [];
List<ProvincialCumulativeTimeline> lProvincialCumulativeTimeline = [];
RandomColor randColor = RandomColor();

class RootAppPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: SplashScreen.navigate(
        name: 'assets/flares/Loading.flr',
        next: (context) => DashboardPage(),
        until: () => Future.delayed(Duration(seconds: 5)),
        startAnimation: 'Alarm',
        fit: BoxFit.scaleDown,
        backgroundColor: Colors.black54,
        ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPage createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadCovid19ZATimeline(await parseJsonFromUrl(
          'https://covidlockdownalert.azurewebsites.net/api/GetCovidTimeline'));
      await loadProvincialCumulativeTimeline(await parseJsonFromUrl(
          'https://covidlockdownalert.azurewebsites.net/api/GetProvincialCumulativeTimeline'));

      setState(() {});
    });
  }

  Future<dynamic> parseJsonFromUrl(String url) async {
    Response response = await get(url);
    return jsonDecode(response.body);
  }

  Future<void> loadCovid19ZATimeline(dynamic dmap) async {
    for (final e in dmap) {
      var covid19ZATimeline = Covid19ZATimeline.fromJson(e);
      lCovid19ZATimeline.add(covid19ZATimeline);
    }
  }

  Future<void> loadProvincialCumulativeTimeline(dynamic dmap) async {
    for (final e in dmap) {
      var provincialCumulativeTimeline =
          ProvincialCumulativeTimeline.fromJson(e);
      lProvincialCumulativeTimeline.add(provincialCumulativeTimeline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ({Widget child}) => Styled.widget(child: child)
        .padding(vertical: 10, horizontal: 10)
        .constrained(minHeight: MediaQuery.of(context).size.height - (2 * 30))
        .scrollable();

    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
        ),
        body: <Widget>[
          CasesOverviewPage(
              lCovid19ZATimeline.last, lProvincialCumulativeTimeline.last),
          SuburbPage(),
        ].toColumn().parent(page),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var result = await _navigateAndDisplaySelection(context);
            if (result != null) {
              var exist = litems.any((e) => e.suburbCode == result.suburbCode);
              if (!exist) {
                setState(() {
                  suburbItems.add(SettingsItemModel(
                      subPlaceLookup: result,
                      icon: Icons.location_on,
                      color: Color(0xff8D7AEE)));
                });
              }
            }
          },
        ));
  }

  Future<SubPlaceLookup> _navigateAndDisplaySelection(
      BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchList()),
    );
  }
}

class CasesOverviewPage extends StatelessWidget {
  CasesOverviewPage(this.covid19ZATimeline, this.provincialCumulativeTimeline);

  final Covid19ZATimeline covid19ZATimeline;
  final ProvincialCumulativeTimeline provincialCumulativeTimeline;

  Widget _buildUserRow(BuildContext context) {
    return <Widget>[
      Icon(Icons.public).iconSize(50).iconColor(Colors.white)
          .constrained(height: 50, width: 50)
          .padding(right: 10),
      <Widget>[
        Text(
          'South Africa',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ).padding(bottom: 5),
        Text(
          'Cases overview',
          style: TextStyle(fontSize: 12, color: Colors.white),
        ).padding(bottom: 5),
        Text(
          covid19ZATimeline.date,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    ].toRow();
  }

  Widget _buildUserStats() {
    return <Widget>[
      _buildUserStatsItem(
          covid19ZATimeline.cumulativeTests.toString(), 'Tests'),
      _buildUserStatsItem(
          provincialCumulativeTimeline.total.toString(), 'Confirmed'),
      _buildUserStatsItem(covid19ZATimeline.recovered.toString(), 'Recovered'),
      _buildUserStatsItem(covid19ZATimeline.deaths.toString(), 'Deaths'),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padding(vertical: 10);
  }

  Widget _buildUserStatsItem(String value, String text) => <Widget>[
        Text(value).fontSize(20).textColor(Colors.white).padding(bottom: 5),
        Text(text).fontSize(12).textColor(Colors.white),
      ].toColumn();

  @override
  Widget build(BuildContext context) {
    return <Widget>[_buildUserRow(context), _buildUserStats()]
        .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padding(horizontal: 20, vertical: 10)
        .decorated(
            color: Color(0xff5E78DE), borderRadius: BorderRadius.circular(20))
        .elevation(
          10,
          shadowColor: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        )
        .padding(bottom: 5)
        .height(175)
        .alignment(Alignment.center);
  }
}

class SettingsItemModel {
  final SubPlaceLookup subPlaceLookup;
  final IconData icon;
  final Color color;
  const SettingsItemModel({
    @required this.subPlaceLookup,
    @required this.color,
    @required this.icon,
  });
}

class SuburbPage extends StatefulWidget {
  @override
  _SuburbPage createState() => _SuburbPage();
}

class _SuburbPage extends State<SuburbPage> {
  @override
  Widget build(BuildContext context) {
    setState(() {});

    return suburbItems
        .map((settingsItem) {
          return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: UniqueKey(),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  suburbItems.removeWhere((x) =>
                      x.subPlaceLookup.suburbCode ==
                      settingsItem.subPlaceLookup.suburbCode);
                });

                // Then show a snackbar.
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "${settingsItem.subPlaceLookup.suburbName} dismissed")));
              },
              child: SuburbItem(settingsItem.subPlaceLookup, settingsItem.icon,
                  settingsItem.color));
        })
        .toList()
        .toColumn();
  }
}

class SuburbItem extends StatefulWidget {
  SuburbItem(this.subPlaceLookup, this.icon, this.iconBgColor);

  final SubPlaceLookup subPlaceLookup;
  final IconData icon;
  final Color iconBgColor;

  @override
  _SuburbItemState createState() => _SuburbItemState();
}

class _SuburbItemState extends State<SuburbItem> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final settingsItem = ({Widget child}) => Styled.widget(child: child)
        .alignment(Alignment.center)
        .borderRadius(all: 15)
        .ripple()
        .backgroundColor(Theme.of(context).scaffoldBackgroundColor,
            animate: true)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(
          pressed ? 0 : 10,
          borderRadius: BorderRadius.circular(20),
          shadowColor: Theme.of(context).scaffoldBackgroundColor,
        ) // shadow borderRradius
        .constrained(height: 100)
        .padding(vertical: 5) // ma4gin
        .gestures(
            onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            _RegulationsState(widget.subPlaceLookup)),
                  )
                })
        .scale(pressed ? 0.95 : 1, animate: true)
        .animate(Duration(milliseconds: 100), Curves.easeIn);

    final Widget icon =
        CircleAvatar(child: Text(widget.subPlaceLookup.level.toString()))
            .padding(all: 5)
            .decorated(borderRadius: BorderRadius.circular(30))
            .padding(left: 8);

    final Widget suburbName = Text(
      widget.subPlaceLookup.suburbName,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ).padding(bottom: 5);

    final Widget municipalityName = Text(
      widget.subPlaceLookup.municipalityName,
      style: TextStyle(fontSize: 10),
    );

    final Widget districtName = Text(
      widget.subPlaceLookup.districtName,
      style: TextStyle(fontSize: 10),
    );

    final Widget provinceConfirmedCases = Text(
      '${widget.subPlaceLookup.provinceName} ${_getProvinceConfirmedCases(widget.subPlaceLookup.provinceName)} Confirmed Cases',
      style: TextStyle(fontSize: 13),
    ).padding(top: 5);

    return settingsItem(
      child: <Widget>[
        icon,
        VerticalDivider(),
        <Widget>[
          suburbName,
          municipalityName,
          districtName,
          provinceConfirmedCases
        ].toColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ].toRow(),
    );
  }

  int _getProvinceConfirmedCases(String provinceName) {
    return lProvincialCumulativeTimeline.last
        .getProvinceConfirmedCases(provinceName);
  }
}

class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);
  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Widget appBarTitle = new Text(
    "Search Suburb",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<SubPlaceLookup> _list = [];

  bool _IsSearching;
  String _searchText = "";

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map<String, dynamic> dmap =
          await parseJsonFromAssets('assets/data/subplacelokuptable.json');

      var spLookup = SubPlace.fromJson(dmap);
      _list = spLookup.subPlaceLookup;
      setState(() {});
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      appBar: buildBar(context),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: _IsSearching ? _buildSearchList() : _buildList(),
      ),
    );
  }

  List<ChildItem> _buildList() {
    return _list.map((contact) => new ChildItem(contact)).toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new ChildItem(contact)).toList();
    } else {
      List<SubPlaceLookup> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        SubPlaceLookup subPlaceLookup = _list.elementAt(i);
        if (subPlaceLookup.suburbName
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          _searchList.add(subPlaceLookup);
        }
      }
      return _searchList.map((contact) => new ChildItem(contact)).toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _searchQuery,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Suburb",
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }
}

class ChildItem extends StatelessWidget {
  final SubPlaceLookup subPlaceLookup;
  ChildItem(this.subPlaceLookup);
  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new ListTile(
            title: new Text(
                "${subPlaceLookup.suburbName}, ${subPlaceLookup.municipalityName}, ${subPlaceLookup.districtName}, ${subPlaceLookup.provinceName}"),
            onTap: () {
              Navigator.pop(context, subPlaceLookup);
            }));
  }
}

class _RegulationsState extends StatefulWidget {
  final SubPlaceLookup selectedItem;
  _RegulationsState(this.selectedItem);

  @override
  _RegulationsStateState createState() =>
      _RegulationsStateState(this.selectedItem);
}

class _RegulationsStateState extends State<_RegulationsState> {
  final SubPlaceLookup selectedItem;
  _RegulationsStateState(this.selectedItem);

  List<Regulation> regulations = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map<String, dynamic> dmap =
          await parseJsonFromAssets('assets/data/regulation.json');

      var regulationMap = RegulationLookup.fromJson(dmap);
      setState(() {
        regulations = regulationMap.regulation;
      });
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("Level ${selectedItem.level}: ${selectedItem.suburbName}"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: new ListView.builder(
                    itemCount: regulations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = regulations[index];
                      return Container(
                        key: Key(item.id.toString()),
                        child: ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(item.getRestrictionIcon(),
                                            color: Colors.white)
                                        .decorated(
                                          color: randColor.randomColor(
                                              colorBrightness:
                                                  ColorBrightness.veryDark),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        )
                                        .constrained(height: 50, width: 50)
                                        .padding(right: 10),
                                    VerticalDivider()
                                  ],
                                ),
                                title: Text(item.restrictionName),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            _RegulationRulesState(
                                                selectedItem, item)),
                                  );
                                })
                            .alignment(Alignment.center)
                            .ripple()
                            .backgroundColor(
                                Theme.of(context).scaffoldBackgroundColor)
                            .clipRRect(all: 25) // clip ripple
                            .borderRadius(all: 25)
                            .elevation(
                              25,
                              borderRadius: BorderRadius.circular(20),
                              shadowColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                            ) // shadow borderRradius
                            .constrained(height: 80)
                            .padding(top: 5, bottom: 5),
                      );
                    }))
          ],
        )));
  }
}

class _RegulationRulesState extends StatefulWidget {
  final SubPlaceLookup selectedSubPlaceLookupItem;
  final Regulation selectedRegulationItem;

  _RegulationRulesState(
      this.selectedSubPlaceLookupItem, this.selectedRegulationItem);

  @override
  _RegulationsRuleStateState createState() => _RegulationsRuleStateState(
      this.selectedSubPlaceLookupItem, this.selectedRegulationItem);
}

class _RegulationsRuleStateState extends State<_RegulationRulesState> {
  final SubPlaceLookup selectedSubPlaceLookupItem;
  final Regulation selectedRegulationItem;

  _RegulationsRuleStateState(
      this.selectedSubPlaceLookupItem, this.selectedRegulationItem);

  List<String> regulationRules = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map<String, dynamic> dmap =
          await parseJsonFromAssets('assets/data/regulationrule.json');

      var regulationRuleMap = RegulationRulesLookup.fromJson(dmap);
      setState(() {
        final tempList = regulationRuleMap.regulationRule;

        final regulationRuleList = tempList
            .where((item) =>
                item.regulationRuleLevel == selectedSubPlaceLookupItem.level &&
                item.regulationId == selectedRegulationItem.id)
            .toList();

        regulationRules = regulationRuleList.first.regulationRules.toList();
      });
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Level ${selectedSubPlaceLookupItem.level}: ${selectedRegulationItem.restrictionIcon}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: new ListView.builder(
                    itemCount: regulationRules.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = regulationRules[index];
                      final count = ++index;
                      return Container(
                        key: UniqueKey(),
                        child: new Card(
                            child: ListTile(
                                leading: ExcludeSemantics(
                                  child: CircleAvatar(child: Text('$count')),
                                ),
                                title: Text(item.toString()))),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
