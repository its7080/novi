import 'package:flutter/material.dart';
import 'package:fluttercollege/screens/payment_gateway.dart';
import 'package:fluttercollege/screens/singup_screen.dart';
import 'package:get/get.dart';
import 'forgot_password.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
        
        
              height: 447,
              child: Stack(
                children: <Widget>[
                  Positioned(
        
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/AI logo.png'),
                            fit: BoxFit.fill
        
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Login", style:  TextStyle(color: Color.fromRGBO(49, 39, 79, 1), fontWeight: FontWeight.bold, fontSize: 30),),
                  SizedBox(height: 25,),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(196, 135, 198, .3),
                          blurRadius: 10,
                          offset: Offset(0,10),
                        )
                      ] ,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                  color: Colors.grey
                              ))
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "User Name",
                                hintStyle: TextStyle(color: Colors.blueGrey)
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
        
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.blueGrey)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Get.to(()=> ForgotPassword());
                    },
                    child: Container(
                        child: Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(196, 135, 198, 1)),)),
                  ),
                  SizedBox(height: 40,),
                  GestureDetector(
                    onTap: (){
                      Get.to(()=>Check());
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 90),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue,
        
                      ),
                      child: Center(
                        child: Text("Login",style: TextStyle(fontSize: 25, ) ,),
                      ),
                    ),
                  ),
        
        
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Get.to(()=>SignUp());
                    },
                    child: Container(
                        child: Center(child: Text("Create Account", style: TextStyle(fontSize: 15,color: Color.fromRGBO(196, 135, 198, 1)),),)),
                  ),
        
                ],
              ),
            ),
        
          ],
        ),
      )
      ,
    );
  }
}
