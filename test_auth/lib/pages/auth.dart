import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:masked_text/masked_text.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool checkValue = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String verifId = '';
  final _numberController = TextEditingController();
  final _smsController = TextEditingController();

  

  final _formKey = GlobalKey<FormState>();

  // final _codeKey = GlobalKey<FormState>();

  bool _validatePhone = true;
  bool _validateCode = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.black,
            tabs: [
              Tab(text: "Войти"),
              Tab(
                text: "Зарегистрироваться",
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 52.0, right: 53),
                  child: Text(
                    "Регистрация нового аккаунта",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 74.5, right: 75.5),
                    child: MaskedTextField(
                      mask: "(###)###-##-##",
                      validator: validatorPhone,
                      keyboardType: TextInputType.phone,
                      controller: _numberController,
                      decoration: InputDecoration(
                          prefixText: "+7",
                          hintText: "(***)***-**-**",
                          label: Text("Номер телефона"),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: (_validatePhone)
                                      ? Colors.black
                                      : Colors.red),
                              borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 124, 124, 124)),
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                    width: 210,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          log(_numberController.text);

                          await auth.verifyPhoneNumber(
                            phoneNumber: "+7${_numberController.text}",
                            //// timeout: const Duration(seconds: 60),
                            codeAutoRetrievalTimeout: (verificationId) {},
                            codeSent:
                                (verificationId, forceResendingToken) async {
                              log("send $verificationId");
                              setState(() {
                                verifId = verificationId;
                              });
                            },
                            verificationFailed: (error) {
                              log("Error $error");
                            },
                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                              log("Complete");

                              try {
                                await auth.signInWithCredential(credential);

                                log("Succes auth");
                              } catch (e) {
                                log("Tresh");
                              }

                              await auth.signInWithCredential(credential);
                            },
                          );
                        }
                      },
                      child: Text("Выслать SMS-код"),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          )),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                    )),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      log(_numberController.text);

                      await auth.verifyPhoneNumber(
                        phoneNumber: "+7${_numberController.text}",
                        //// timeout: const Duration(seconds: 60),
                        codeAutoRetrievalTimeout: (verificationId) {},
                        codeSent: (verificationId, forceResendingToken) async {
                          log("send $verificationId");
                          setState(() {
                            verifId = verificationId;
                          });
                        },
                        verificationFailed: (error) {
                          log("Error $error");
                        },
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          log("Complete");

                          try {
                            await auth.signInWithCredential(credential);

                            log("Succes auth");
                          } catch (e) {
                            log("Tresh");
                          }

                          await auth.signInWithCredential(credential);
                        },
                      );
                    }
                  },
                  child: Text(
                    "Выслать повторно",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Form(
                  /// key: keys[1],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 74.5, right: 75.5),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _smsController,
                   ///   validator: validatorCode,

                      ////   controller: _numberController,
                      decoration: InputDecoration(
                          hintText: 'XXXXXX',
                          label: Text("Код из смс"),
                          errorText: (_validateCode)?null : validatorCode(_smsController.text) ,
                          errorBorder:OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ) ,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: (_validateCode)
                                      ? Colors.black
                                      : Colors.red),
                              borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: (_validateCode)? Color.fromARGB(255, 124, 124, 124): Colors.red),
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  /// width: 248,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      Checkbox(
                        value: checkValue,
                        onChanged: (value) {
                          setState(() {
                            checkValue = !checkValue;
                          });
                        },
                        fillColor: MaterialStatePropertyAll(Colors.red),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Container(
                        width: 248,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ознакомлен с Договором оферты",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "и согласен на Рассылку",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                SizedBox(
                    width: 210,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!checkValue) {
                          Fluttertoast.showToast(
                              msg:
                                  "Подтвердите ознакомление с договором Оферты",
                              gravity: ToastGravity.BOTTOM);
                        }
                        if ((validatorCode(_smsController.text) == null) &&
                            checkValue) {
                          try {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verifId,
                                    smsCode: _smsController.text);

                            await auth.signInWithCredential(credential);
                            log("Succes tiiiitih");
                          } catch (e) {
                            log("Tresh");
                          }
                        }
                      },
                      child: Text("Далее"),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          )),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validatorPhone(String? phone) {
    if ((phone!.isEmpty) || (phone!.length < 10)) {
      _validatePhone = false;
      setState(() {});
      return "Введите номер телефона";
    }

    _validatePhone = true;
    setState(() {});
    return null;
  }

  String? validatorCode(String? code) {
    if ((code!.isEmpty) || (code!.length < 6)) {
      _validateCode = false;
      setState(() {});
      return "Введите код из SMS";
    }

    _validateCode = true;
    setState(() {});
    return null;
  }
}
