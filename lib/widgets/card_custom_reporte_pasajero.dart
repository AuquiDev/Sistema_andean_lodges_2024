
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:flutter/material.dart';

class CardTitleFormPax extends StatelessWidget {
  const CardTitleFormPax({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.all(8),
        surfaceTintColor: Colors.white,
        elevation: 10,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 10,
                decoration: const BoxDecoration(
                    color: Color(0xFF5F3113),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FittedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/img/andeanlodges.png',
                            width: 100,
                            color: const Color(0xFF5F3113),
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              H2Text(
                                text: 'Andean Lodges',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5F3113),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15,right: 30, left: 30, bottom: 20),
                child: Column(
                  children: [
                    H2Text(
                      text: title,
                      fontSize: 15,
                      maxLines: 10,
                      color: const Color(0xFF5F3113),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
