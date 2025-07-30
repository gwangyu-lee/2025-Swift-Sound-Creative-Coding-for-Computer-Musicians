/*:
 [Previous](@previous)
 
 # Identifier
 The name given to different programming elements.
 
 ```
 var one = 1
 ```
 * callout(Max/MSP): numbers

![two-integers](two-integers.png)
 
 ```
 {
     "boxes" : [         {
             "box" :             {
                 "maxclass" : "number",
                 "varname" : "gwangyu",
                 "patching_rect" : [ 120.0, 315.0, 50.0, 22.0 ],
                 "numoutlets" : 2,
                 "outlettype" : [ "", "bang" ],
                 "numinlets" : 1,
                 "id" : "obj-11",
                 "parameter_enable" : 0
             }

         }
 ,         {
             "box" :             {
                 "maxclass" : "number",
                 "patching_rect" : [ 120.0, 285.0, 50.0, 22.0 ],
                 "numoutlets" : 2,
                 "outlettype" : [ "", "bang" ],
                 "numinlets" : 1,
                 "id" : "obj-9",
                 "parameter_enable" : 0
             }

         }
  ],
     "appversion" :     {
         "major" : 9,
         "minor" : 0,
         "revision" : 5,
         "architecture" : "x64",
         "modernui" : 1
     }
 ,
     "classnamespace" : "box"
 }
 ```
 * callout(Max/MSP): scripting name
 
 ![scripting-name](scripting-name.png)
 */


/*:
 * Important:
 Keywords must not be used as an identifier.
 ```
 var var = 1
 //❗️
 var varNumber = 1
 // ✅
 ```
 */


/*:
 * Important:
 Identifier must begin with an alphabet a-z A-Z or an underscore_ symbol.
 ```
 var 1 = 1
 //❗️
 var 1one = 11
 //❗️
 var two = 2
 // ✅
 var _two = 2
 // ✅
 ```
 */


/*:
 * Important:
 Identifier can contains alphabets a-z A-Z, digits 0-9 and underscore _ symbol.
 ```
 var _1_000_000 = 1_000_000
 // ✅
 var pi = 3.14_159
 // ✅
 ```
 */


/*:
 * Important:
 Identifier must not contain any special character (e.g. !@$*.'[] etc.) except underscore _ symbol.
 ```
 var gwan-gyu = "my name"
 // ❗️
 var dmadkr20@ = "password"
 // ❗️
 ```
 */


//: [Next](@next)
