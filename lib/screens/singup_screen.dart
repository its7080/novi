import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_screen.dart';


class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child:
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50,),
                    Text("Create Account", style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                    SizedBox(height:6),
                    Text("Sign up to get started!", style: TextStyle(fontSize: 20, color: Colors.grey.shade400)),
        
        
        
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText:"Name",
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
        
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                    ),
                    SizedBox(height:20,),
        
                    TextField(
                      decoration: InputDecoration(
                        labelText:"User Name",
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
        
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                    ),
                    SizedBox(height:20,),
                    TextField(
                      decoration: InputDecoration(
                        labelText:"Email Id",
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
        
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText:"phone Number",
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
        
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                    ),
                    SizedBox(height:20,),
        
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText:"Password",
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
        
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                    ),
                    SizedBox(height:20,),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText:"Confirm Password",
                        labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
        
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                    ),
        
                    SizedBox(height:30,),
                    GestureDetector(
                      onTap: (){
                        Get.to(()=>LoginScreen());
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 90),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blue,
        
                        ),
                        child: Center(
                          child: Text("Sign Up",style: TextStyle(fontSize: 25, ) ,),
                        ),
                      ),
                    ),
                    SizedBox(height: 150,),
        
                  ],
                ),
              ],
            ),
        
          ),
        
        ),
      ) ,

    );
  }
}
