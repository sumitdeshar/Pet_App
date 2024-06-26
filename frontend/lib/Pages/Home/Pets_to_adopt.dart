import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/Controllers/Popular_product_controller.dart';
import 'package:frontend/Controllers/Shelter_controller.dart';
import 'package:frontend/Routes/route_helper.dart';
import 'package:frontend/Utils/Colors.dart';
import 'package:frontend/Utils/appConstants.dart';
import 'package:frontend/Utils/dimentions.dart';
import 'package:frontend/Widgets/App_column.dart';
import 'package:frontend/Widgets/Big_texts123.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:frontend/Widgets/Icon_Text.dart';
import 'package:frontend/Widgets/Small_texts.dart';

class PetAdoptChoices extends StatefulWidget {
  const PetAdoptChoices({super.key});

  @override
  State<PetAdoptChoices> createState() => _PetAdoptChoicesState();
}

class _PetAdoptChoicesState extends State<PetAdoptChoices> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<ShelterController>(builder: (popularPets) {
          return popularPets.isLoaded
              ? SizedBox(
                  // color: Colors.red,
                  height: Dimensions.pageView,
                  child: PageView.builder(
                      controller: pageController,
                      itemCount: popularPets.shelterList.isEmpty
                          ? 1
                          : popularPets.shelterList.length,
                      itemBuilder: (context, position) {
                        return _buildPageItem(
                            position, popularPets.shelterList[position]);
                      }),
                )
              : const CircularProgressIndicator(
                  color: AppColors.mainColor,
                );
        }),
        GetBuilder<ShelterController>(builder: (popularPets) {
          return DotsIndicator(
            dotsCount: popularPets.shelterList.isEmpty
                ? 1
                : popularPets.shelterList.length,
            position: _currPageValue.round(),
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeColor: AppColors.mainColor,
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        //Gap
        SizedBox(height: Dimensions.height30),
        //Text
        Container(
          margin: EdgeInsets.only(left: Dimensions.height30),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                BigText(text: "Avaliabe"),
                SizedBox(
                  width: Dimensions.height10,
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: SmallText(text: "Recommended For You"))
              ]),
        ),

        //List of pets avaliable

        GetBuilder<PopularProductController>(builder: (Avaliable) {
          return Avaliable.isLoaded
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Avaliable.popularProductList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteHelper.getDogs(index));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: Dimensions.height20,
                              right: Dimensions.height20,
                              bottom: Dimensions.height10),
                          child: Row(
                            children: [
                              //Image Section
                              Container(
                                height: Dimensions.ListViewImgSize,
                                width: Dimensions.ListViewImgSize,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.height20),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "${AppConstants.BASE_URL}${AppConstants.ADOPT_PET_URL}/" +
                                                Avaliable
                                                    .popularProductList[index]
                                                    .img!))),
                              ),
                              //Text Container
                              Expanded(
                                child: Container(
                                  height: Dimensions.ListViewTextContSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            Dimensions.height20),
                                        bottomRight: Radius.circular(
                                            Dimensions.height20)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimensions.height10,
                                        right: Dimensions.height5),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //Text Title for Pet Name
                                          BigText(
                                              text: Avaliable
                                                  .popularProductList[index]
                                                  .name!),
                                          SizedBox(
                                            height: Dimensions.height10,
                                          ),
                                          //Shelther name
                                          SmallText(text: "Shena's Care"),
                                          SizedBox(
                                            height: Dimensions.height10,
                                          ),
                                          //Icons And Locations
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconAndText(
                                                  icon: Icons.circle_sharp,
                                                  text: " Normal",
                                                  iconColor:
                                                      AppColors.iconColor1),
                                              IconAndText(
                                                  icon: Icons.gps_fixed_sharp,
                                                  text: " 2.1Km",
                                                  iconColor:
                                                      AppColors.mainColor),
                                              IconAndText(
                                                  icon: Icons
                                                      .access_alarm_rounded,
                                                  text: " 3.2 mins",
                                                  iconColor:
                                                      AppColors.iconColor2),
                                            ],
                                          )
                                        ]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                  })
              : const CircularProgressIndicator(color: AppColors.mainColor);
        })
      ],
    );
  }

  Widget _buildPageItem(int index, sheltherList) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 0);
    }

    return Transform(
        transform: matrix,
        child: Stack(children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getShelter(index));
            },
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.height10, right: Dimensions.height10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.height30),
                color: index.isEven
                    ? const Color(0xFF69c5df)
                    : const Color(0xFF9294cc),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "${AppConstants.BASE_URL}${AppConstants.SHELTER_URL}/" +
                            sheltherList.img)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.height30,
                  right: Dimensions.height30,
                  bottom: Dimensions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.height20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, 5),
                    ),
                  ]),
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimensions.height15,
                    left: Dimensions.height10,
                    right: Dimensions.height10),
                child: AppColumn(
                  text: sheltherList.name,
                ),
              ),
            ),
          )
        ]));
  }
}
