$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

POSITIVE VARIABLES
         x1 variable 1
         x2 variable 2
         x3 variable 3

         x11 Disgregación de x1
         x12
         x13
         x14
         x15
         x16
         x17

         x21 Disgregación de x2
         x22
         x26
         x27

         x33 Disgregación de x3
         x34
         x35
         x36
         x37

         ;

BINARY VARIABLES
         y1 variables bianria asociada a Y1
         y2 variables bianria asociada a Y2
         y3 variables bianria asociada a Y3
         y4 variables bianria asociada a Y4
         y5 variables bianria asociada a Y5
         y6 variables bianria asociada a Y6
         y7 variables bianria asociada a Y7
         ;

VARIABLES
         z valor de la funcion objetivo a minimizar
         ;


EQUATIONS
         fo

         rest1
         disg1,disg2
         ec1,ec2,ec3,ec4,ec5,ec6
*lim1,lim2,lim3,lim4,lim5,lim6,lim7,lim8

         rest2
         disg3,disg4
         ec7,ec8,ec9,ec10,ec11,ec12,ec13,ec14
*lim9,lim10,lim11,lim12,lim13,lim14,lim15,lim16,lim17,lim18,lim19,lim20

         rest3
         disg5,disg6,disg7
         ec15,ec16
*lim21,lim22,lim23,lim24,lim25,lim26,lim27,lim28,lim29,lim29,lim30,lim31,lim32
         ;

fo.. z =e= exp(-log(x1)+x2*log(x2)-sqrt(x3));

rest1.. y1+y2 =e= 1;
disg1.. x1 =e= x11+x12;
disg2.. x2 =e= x21+x22;
ec1..   x11-x21 =l= 0;
ec2..   x11+x21-5*y1 =g= 0;
ec3..   x11 =l= 10*y1-x21;
ec4..   x12 =l= 20*y2-x22;
ec5..   x12-0.5*x22-5*y2 =l= 0;
ec6..   x12 =g= 8*y2-0.6*x22;
*lim1..  y1*1 =l= x11;
*lim2..  x11 =l= y1*10;
*lim3..  y1*1 =l= x21;
*lim4..  x21 =l= y1*10;
*lim5..  y2*1 =l= x12;
*lim6..  x12 =l= y2*10;
*lim7..  y2*1 =l= x22;
*lim8..  x22 =l= y2*10;

rest2.. y3+y4+y5 =e= 1;
disg3.. x1 =e= x13+x14+x15;
disg4.. x3 =e= x33+x34+x35;
ec7..   x13 =l= 2*x33;
ec8..   2*x33+x13 =l= 10*y3;
ec9..   x13 =g= 4*y3-1.2*x33;
ec10..  x14-5*x34-4*y4 =l= 0;
ec11..  3*x34-15*y4 =l= x14;
ec12..  x14 =l= 25*y4-3*x34;
ec13..  x35 =e= 2*y5;
ec14..  x15 =e= 1*y5;
*lim9..  y3*1 =l= x13;
*lim10.. x13 =l= y3*10;
*lim11.. y3*1 =l= x33;
*lim12.. x33 =l= 10*y3;
*lim13.. 1*y4 =l= x14;
*lim14.. x14 =l= 10*y4;
*lim15.. 1*y4 =l= x34;
*lim16.. x34 =l= 10*y4;
*lim17.. 1*y5 =l= x15;
*lim18.. x15 =l= 10*y5;
*lim19.. 1*y5 =l= x35;
*lim20.. x35 =l= 10*y5;

rest3.. y6+y7 =e= 1;
disg5.. x1 =e= x16+x17;
disg6.. x2 =e= x26+x27;
disg7.. x3 =e= x36+x37;
ec15..  x36 =l= -0.5*x26+7*y6+x16;
ec16..  x17 =l= x27-0.5*x37+6*y7;
*lim21.. 1*y6 =l= x16;
*lim22.. x16 =l= 10*y6;
*lim23.. 1*y6 =l= x26;
*lim24.. x26 =l= 10*y6;
*lim25.. 1*y6 =l= x36;
*lim26.. x36 =l= 10*y6;
*lim27.. 1*y7 =l= x17;
*lim28.. x17 =l= 10*y7;
*lim29.. 1*y7 =l= x27;
*lim30.. x27 =l= 10*y7;
*lim31.. 1*y7 =l= x37;
*lim32.. x37 =l= 10*y7;

x1.lo=1;
x2.lo=1;
x3.lo=1;
x1.up=10;
x2.up=10;
x3.up=10;
         ;

MODEL P2 /all/;

SOLVE P2 using MINLP minimizing z;
