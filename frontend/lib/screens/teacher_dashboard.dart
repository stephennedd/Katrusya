import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  static const String routeName = "/teacher_dashboard";

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Dashboard",
        hasBackButton: false,
        backgroundColor: Color(0xFFEDEDED),
      ),
      body: _buildBody(),
      backgroundColor: Color(0xFFEDEDED),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Column(
        children: [
          getBalance(),
          SizedBox(
            height: 30,
          ),
          getCompletionChart(),
          SizedBox(height: 30,),
          getEarnings(),
        ],
      ),
    );
  }

  Widget getBalance() {
    return Container(
      padding: EdgeInsets.all(20),
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
          color: primaryDark,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "balance",
            style: TextStyle(
                fontFamily: 'Nexa-Trial',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primary),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "\$",
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 24, color: Colors.white),
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                "10.520.",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Text(
                "15",
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 20, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getCompletionChart() {
    return Container(
      padding: EdgeInsets.all(15),
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "completion rate 2023",
            style: TextStyle(
                fontFamily: 'Nexa-Trial',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor),
          ),
          // Graph of completion rate of your courses.
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0), interval: 10),
              legend: Legend(isVisible: true, position: LegendPosition.bottom, ),
              series: <ChartSeries<SalesData, String>>[
                SplineSeries<SalesData, String>(
                    name: "Completion in %",
                    animationDuration: 2.0,
                    color: Colors.red,
                    // Bind data source
                    dataSource: <SalesData>[
                      SalesData('Jan', 35),
                      SalesData('Feb', 28),
                      SalesData('Mar', 34),
                      SalesData('Apr', 32),
                      SalesData('May', 40),
                      SalesData('Jun', 55),
                      SalesData('Jul', 65),
                      SalesData('Aug', 51),
                      SalesData('Sep', 48),
                      SalesData('Oct', 75),
                      SalesData('Nov', 64),
                      SalesData('Dec', 45),
                    ],
                    xValueMapper: (SalesData sales, _) => sales.month,
                    yValueMapper: (SalesData sales, _) => sales.completedCourses,
                    dataLabelSettings: DataLabelSettings(isVisible: true)
                )
              ])
        ],
      ),
    );
  }

  Widget getEarnings() {
    return Container(
      padding: EdgeInsets.all(20),
      height: 140,
      decoration: BoxDecoration(
          color: primaryDark,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1))
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Text("earnings",
                style: TextStyle(
                    fontFamily: 'Nexa-Trial',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "this month",
                    style: TextStyle(
                        fontFamily: 'Nexa-Trial',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: primary),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "\$",
                        style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "4.170.",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      Text(
                        "15",
                        style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "this year",
                    style: TextStyle(
                        fontFamily: 'Nexa-Trial',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: primary),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "\$",
                          style: TextStyle(
                              fontFamily: 'Poppins', fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "24.170.",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        Text(
                          "55",
                          style: TextStyle(
                              fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
                        ),
                      ]
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.month, this.completedCourses);

  final String month;
  final double completedCourses;
}
