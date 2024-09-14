import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController flatBuildingController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final _addressFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pinCodeController.dispose();
    cityController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    var address = '101, Fake street, London';

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:  Column(
            children: [
              if(address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(address, style: const TextStyle(fontSize: 18),),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text("OR", style: TextStyle(fontSize: 18),),
                    const SizedBox(height: 20,),
                  ],
                ),
              Form(
                            key:  _addressFormKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: flatBuildingController,
                                  hintText: 'Flat, House NO, Building',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: areaController,
                                  hintText: 'Area, Street',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: pinCodeController,
                                  hintText: 'Pincode',
                                ),
                                    const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: cityController,
                                  hintText: 'City',
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