import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _expanded = false;
  // DateTime now = DateTime.now();
  DateTime selectedDate = DateTime.now();
  get date => DateFormat('yyy.MM.dd (E)').format(selectedDate);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ExpansionPanelList(
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return const ListTile(
                    leading: Text(
                      'Filter',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                      ),
                    ),
                    title: Center(
                      child: Text(
                        'Select Filters',
                      ),
                    ),
                  );
                },
                body: Container(
                    padding: EdgeInsets.fromLTRB(130.0, 0.0, 0.0, 30.0),
                    child: Column(
                      children: [
                        _buildCheckList('No Kids Zone'),
                        _buildCheckList('Pet-Friendly'),
                        _buildCheckList('Free breakfast'),
                      ],
                    )),
                isExpanded: _expanded,
              ),
            ],
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          SizedBox(
            height: 50.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0, 0, 20.0),
                child: Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_month),
                          Text(
                            'check-in',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        date,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text('9.30am'),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2050),
                      );
                      if (newDate == null) return;
                      setState(() {
                        selectedDate = newDate;
                      });
                    },
                    child: Text('select date'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 45.0,
                        )),
                  ),
                ],
              ),
              SizedBox(),
              Container(
                padding: EdgeInsets.only(top: 250.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Search',
                      style: TextStyle(
                          fontSize: 26.0, fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Row _buildCheckList(String label) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Checklist(),
      Text(label),
    ],
  );
}

class Checklist extends StatefulWidget {
  const Checklist({Key? key}) : super(key: key);

  @override
  State<Checklist> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<Checklist> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
