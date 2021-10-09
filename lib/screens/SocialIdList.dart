import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';

import 'ProfileScreen.dart';

class SocialIdList extends StatefulWidget {
  final String headText;
  final List userSocialData;
  final Function refreshData;
  final GlobalKey<ScaffoldState> scaffoldKey;

  SocialIdList({Key key, this.userSocialData, this.headText, this.refreshData, this.scaffoldKey}) : super(key: key);

  @override
  _SocialIdListState createState() => _SocialIdListState();
}

class _SocialIdListState extends State<SocialIdList> {
  @override
  void initState() {
    super.initState();
    // widget.refreshData();
    print('my list social data');
    print(widget.userSocialData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.headText,
                style: kSocialText,
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.826,
            ),
            shrinkWrap: true,
            itemCount: widget.userSocialData.length,
            itemBuilder: (BuildContext context, int index) {
              return SocialPlatformsTile(
                isPremium: widget.userSocialData[index]['is_premium'],
                venmoSHareUrl: '${widget.userSocialData[index]['social_link_2']}',
                padKey: index.toString(),
                socialMediaId: '${widget.userSocialData[index]['link_id']}',
                refreshData: () => widget.refreshData(),
                inputHint: widget.userSocialData[index]['hint'],
                headText: widget.userSocialData[index]['head_text'],
                context: widget.scaffoldKey.currentContext,
                socialIcon: widget.userSocialData[index]['social_platform_icon'],
                socialIdl: '${widget.userSocialData[index]['social_id']}',
                gradientStart: int.parse(widget.userSocialData[index]['gradient_start']),
                gradientEnd: int.parse(widget.userSocialData[index]['gradient_end']),
                userSocialName: widget.userSocialData[index]['social_link'],
                socialPlatformNName: widget.userSocialData[index]['social_platform_name'],
              );
            },
          ),
        ),
      ],
    );
  }
}
