import 'package:flutter/material.dart';


class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          //image
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
                Text("Reset Password", style:  TextStyle(color: Color.fromRGBO(49, 39, 79, 1), fontWeight: FontWeight.bold, fontSize: 27),),
                SizedBox(height: 5,),

                Text("We will send you an email to reset your password", style: TextStyle(color: Color.fromRGBO(196, 135, 198, 1), fontSize: 15),),
                SizedBox(height: 30,),


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
                              hintText: "Email ID",
                              hintStyle: TextStyle(color: Colors.blueGrey)
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                SizedBox(height: 40,),

                // reset button
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 90),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue,

                  ),
                  child: Center(
                    child: Text("Continue",style: TextStyle(fontSize: 25, ) ,
                    ),
                  ),
                ),




              ],
            ),
          ),

        ],
      )
      ,
    );
  }
}
