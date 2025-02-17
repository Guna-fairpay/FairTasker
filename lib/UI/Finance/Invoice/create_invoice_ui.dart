import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';

class CreateInVoiceUI extends StatefulWidget {
  const CreateInVoiceUI({super.key});

  @override
  State<CreateInVoiceUI> createState() => _CreateInVoiceUIState();
}

class _CreateInVoiceUIState extends State<CreateInVoiceUI> {
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController legalRegController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  TextEditingController shippingFullNameController = TextEditingController();
  TextEditingController shippingAddressController = TextEditingController();
  TextEditingController shippingMobileNumberController =
      TextEditingController();
  TextEditingController shippingTaxNumberController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  bool isDateFieldEmpty = false;
  List<Map<String, dynamic>> paymentStatusDropdownList = [];
  String? selectPaymentStatus;
  bool same = false;
  void copyBillingToShipping() {
    if (same) {
      shippingFullNameController.text = fullNameController.text;
      shippingAddressController.text = addressController.text;
      shippingMobileNumberController.text = mobileNumberController.text;
      shippingTaxNumberController.text = taxNumberController.text;
    }
  }

  @override
  void initState() {
    super.initState();
    dateController.text =
        Utils.convertDateTimeToTheFormat(DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppC.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(35.0),
          child: HeaderView(),
        ),
        body: Builder(builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back)),
                          const SizedBox(
                            width: 10,
                          ),
                          Utils.getText('Create Invoice',
                              size: 20, weight: FontWeight.bold)
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Image.asset(
                          Assets.fairReturnsLogo,
                          height: 70,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Utils.getText('Address',
                          size: 12, weight: FontWeight.bold),
                      const SizedBox(
                        height: 5,
                      ),
                      Utils.getBorderedMultilineTextField(
                          'Company Address', companyAddressController,
                          fillColor: AppC.white,
                          minLines: 3,
                          autofocus: false,
                          ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', postalCodeController,
                                label: Utils.getText('Enter Postal Code',
                                    color: AppC.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', legalRegController,
                                label: Utils.getText('Legal Registration No',
                                    color: AppC.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', emailController,
                                textType: TextInputType.emailAddress,
                                label:
                                    Utils.getText('Email', color: AppC.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', websiteController,
                                label:
                                    Utils.getText('Website', color: AppC.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', contactController,
                                label: Utils.getText('Contact No',
                                    color: AppC.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Utils.getText('Invoice No',
                          size: 12, weight: FontWeight.bold),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', invoiceController,
                                label: Utils.getText('Invoice No',
                                    color: AppC.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getTextFormField(
                              '',
                              dateController,
                              suffixIcon: Padding(
                                padding: isDateFieldEmpty
                                    ? const EdgeInsets.only(right: 35.0)
                                    : EdgeInsets.zero,
                                child: const Icon(
                                  Icons.date_range,
                                  color: AppC.appColor,
                                ),
                              ),
                              readOnly: true,
                              onTapCallback: () {
                                Utils.datePicker(
                                  context,
                                  '',
                                  initial: DateTime
                                      .now(), // Set initial date to the current date
                                ).then((value) {
                                  if (value != null) {
                                    dateController.text =
                                        Utils.convertDateTimeToTheFormat(
                                      value.toString(),
                                    );
                                  }
                                });
                              },
                              label: Utils.getText('Date', color: AppC.grey),
                              borderColor: isDateFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isDateFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppC.fieldBase,
                              width: Num.borderWidthField),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(Num.subradiusButton)),
                        ),
                        child: DropdownButton<String>(
                          hint: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Utils.getText('Select Category',
                                color: AppC.grey),
                          ),
                          value: selectPaymentStatus,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 3,
                          dropdownColor: AppC.white,
                          underline: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectPaymentStatus = value;
                            });
                          },
                          items: paymentStatusDropdownList
                              .map<DropdownMenuItem<String>>(
                            (value) {
                              return DropdownMenuItem<String>(
                                value: value['id'].toString(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Utils.getText('${value['name']}'),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', amountController,
                                textType: TextInputType.number,
                                label: Utils.getText('Total Amount',
                                    color: AppC.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Utils.getText('BILLING ADDRESS',
                          size: 12, weight: FontWeight.bold, color: AppC.grey),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', fullNameController,
                                textType: TextInputType.number,
                                label: Utils.getText('Full Name',
                                    color: AppC.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Utils.getBorderedMultilineTextField('Address', addressController,
                          fillColor: AppC.white,
                          minLines: 3,
                          autofocus: false,
                          ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', mobileNumberController,
                                label: Utils.getText(
                                  'Mobile Number',
                                  color: AppC.grey,
                                )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', taxNumberController,
                                label: Utils.getText(
                                  'Tax Number',
                                  color: AppC.grey,
                                )),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Checkbox(
                              value: same,
                              activeColor: AppC.appColor,
                              onChanged: (newValue) {
                                setState(() {
                                  same = newValue!;
                                  copyBillingToShipping(); // Copy data when checkbox state changes
                                });
                              },
                            ),
                          ),
                          Expanded(
                              child: Utils.getText(
                                  'Will your Billing and Shipping address be the same?',
                                  weight: FontWeight.bold,
                                  size: 12)),
                        ],
                      ),
                      Utils.getText(
                        'SHIPPING ADDRESS',
                        size: 12,
                        weight: FontWeight.bold,
                        color: AppC.grey,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', shippingFullNameController,
                                textType: TextInputType.text,
                                label: Utils.getText('Full Name',
                                    color: AppC.grey)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Utils.getBorderedMultilineTextField(
                          'Address', shippingAddressController,
                          fillColor: AppC.white,
                          minLines: 3,
                          autofocus: false,
                          ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', shippingMobileNumberController,
                                label: Utils.getText(
                                  'Mobile Number',
                                  color: AppC.grey,
                                )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Utils.getText('PAYMENT DETAILS',
                          size: 12, weight: FontWeight.bold, color: AppC.grey),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                '', shippingTaxNumberController,
                                label: Utils.getText(
                                  'Tax Number',
                                  color: AppC.grey,
                                )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                                'Card Holder Name', cardHolderNameController),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                          'Card Number',
                          cardNumberController,
                          textType: TextInputType.number,
                          maxLength: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Card Type',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'MasterCard', child: Text('MasterCard')),
                            DropdownMenuItem(
                                value: 'RuPay', child: Text('RuPay')),
                            DropdownMenuItem(
                                value: 'Visa', child: Text('Visa')),
                            DropdownMenuItem(
                                value: 'PayPal', child: Text('PayPal')),
                            DropdownMenuItem(
                                value: 'Credit Card',
                                child: Text('Credit Card')),
                          ],
                          onChanged: (value) {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
