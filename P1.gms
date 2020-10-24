$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

POSITIVE VARIABLES
         x1,x2,x3,x4
         c1,c2
         ;

BINARY VARIABLES
         y1 variable binaria asociada a la restricción 1
         y2 variable binaria asociada a la restricción 2
         y3 variable binaria asociada a la restricción 3
         y4 variable binaria asociada a la restricción 4
         y5 variable binaria asociada a la restricción 5
         ;

VARIABLES
         z valor de la función objetivo a minimizar
         ;

SCALARS
         M valor de la M grande /1000/
         ;

EQUATIONS
         fo
         ec0
         rest1,rest2
         ec1,ec2,ec3,ec4,ec5,ec6,ec7,ec8,ec9,ec10,ec11,ec12,ec13,ec14,ec15,ec16
         ;


fo..     z =e= 10+c1+c2-x1+4*x3-5*x2-4*x4;
ec0..    x2-x3 =e= 0;

rest1..  y1+y2 =e= 1;
rest2..  y3+y4+y5 =e= 1;

*Para Y1
ec1..    -log(1+x1)+x2 =l= M*(1-y1);
ec2..    c1-5 =l= M*(1-y1);
ec3..    c1-5 =g= -M*(1-y1);
*Para Y2
ec4..    -log(2+x1)+3*x2 =l= M*(1-y2);
ec5..    c1-2 =l= M*(1-y2);
ec6..    c1-2 =g= -M*(1-y2);

*Para Y3
ec7..    exp(x4)-2-x3 =l= M*(1-y3);
ec8..    c2-6 =l= M*(1-y3);
ec9..    c2-6 =g= -M*(1-y3);
*Para Y4
ec10..   exp(x4/2)-1-x3 =l= M*(1-y4);
ec11..   c2-3 =l= M*(1-y4);
ec12..   c2-3 =g= -M*(1-y4);
*Para Y5
ec13..   x4-0.9*x3 =l= M*(1-y5);
ec14..   x4-0.9*x3 =g= -M*(1-y5);
ec15..   c2-10 =l= M*(1-y5);
ec16..   c2-10 =g= -M*(1-y5);

x1.up=4;
x2.up=4;
x3.up=4;
x4.up=4;
         ;

MODEL P1 /all/;

SOLVE P1 using MINLP minimizing z;
