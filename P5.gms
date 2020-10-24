$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

POSITIVE VARIABLES
         x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18
         x19,x20,x21,x22,x23,x24,x25
         c1,c2,c3,c4,c5,c6,c7,c8
         ;

SCALARS
         M valor de la M grande /1000/
         ;

BINARY VARIABLES
         y1 variables binaria asociada a Y1
         y2 variables binaria asociada a Y2
         y3 variables binaria asociada a Y3
         y4 variables binaria asociada a Y4
         y5 variables binaria asociada a Y5
         y6 variables binaria asociada a Y6
         y7 variables binaria asociada a Y7
         y8 variables binaria asociada a Y8
         ;

VARIABLES
         z valor de la funcion objetivo a minimizar
         ;

EQUATIONS
         fo
*Restricciones de algunas variables
         r1,r2,r3,r4
*Balances de materia en los nodos
         BM1,BM2,BM3,BM4,BM5,BM6,BM7,BM8
*Incompatibilidad de procesos
         rest1,rest2,rest3
*Usando evolvente convexa
         ec1,ec2,lim1,lim2
         ec3,ec4,lim3,lim4
         ec5,ec6,lim5
*Usando M grande
         ec7,ec8,ec9,ec10,ec11,ec12,ec13
         ec14,ec15,ec16,ec17,ec18,ec19,ec20
         ec21,ec22,ec23,ec24,ec25,ec26,ec27
         ec28,ec29,ec30,ec31,ec32,ec33,ec34
         ec35,ec36,ec37,ec38,ec39,ec40,ec41,ec42,ec43
         ;

fo..     z =e= c1+c2+c3+c4+c5+c6+c7+c8+x2-10*x3+x4-15*x5-40*x9+15*x10+15*x14+80*x17-65*x18+25*x19-60*x20+35*x21-80*x22-35*x25+122;

r1..     x10 =g= 0.4*x17;
r2..     x10 =l= 0.8*x17;
r3..     x14 =g= 0.2*x12;
r4..     x14 =l= 0.8*x12;

BM1..    x1 =e=  x2+x4;
BM2..    x11 =e= x12+x15;
BM3..    x6 =e= x7+x8;
BM4..    x25+x16+x9 =e= x17;
BM5..    x23 =e= x20+x22;
BM6..    x23 =e= x24+x14;
BM7..    x3+x5 =e= x6+x11;
BM8..    x13 =e= x19+x21;

rest1..  y1+y2 =e= 1;
rest2..  y4+y5 =e= 1;
rest3..  y6+y7 =e= 1;

*Con evolvente convexa tengo que meter Y3,Y4 e Y5 (y contrarias)
*Para Y3
ec1..    1.5*x9-x8+x10 =e= 0;
ec2..    c3 =e= 6*y3;
lim1..   x9 =l= 2*y3;
lim2..   x10 =l= 1*y3;
*Para Y4
ec3..    1.25*(x12+x14)-x13 =e= 0;
ec4..    c4 =e= 10*y4;
lim3..   x13 =l= 5*y4;
lim4..   x14 =l= 1*y4;
*Para Y5
ec5..    x15-2*x16 =e= 0;
ec6..    c5 =e= 6*y5;
lim5..   x16 =l= 5*y5;

*Con M grande tengo que meter Y1,Y2,Y6,Y7 e Y8 (y contrarias)
*Para Y1
ec7..    exp(x3)-1-x2 =l= M*(1-y1);
ec8..    exp(x3)-1-x2 =g= -M*(1-y1);
ec9..    x2 =l= M*y1;
ec10..   x2 =g= -M*y1;
ec11..   x3 =l= M*y1;
ec12..   x3 =g= -M*y1;
ec13..   c1 =e= 5*y1;
*Para Y2
ec14..   exp(x5/1.2)-1-x4 =l= M*(1-y2);
ec15..   exp(x5/1.2)-1-x4 =g= -M*(1-y2);
ec16..   x4 =l= M*y2;
ec17..   x4 =g= -M*y2;
ec18..   x5 =l= M*y2;
ec19..   x5 =g= -M*y2;
ec20..   c2 =e= 8*y2;
*Para Y6
ec21..   exp(x20/1.5)-1-x19 =l= M*(1-y6);
ec22..   exp(x20/1.5)-1-x19 =g= -M*(1-y6);
ec23..   x19 =l= M*y6;
ec24..   x19 =g= -M*y6;
ec25..   x20 =l= M*y6;
ec26..   x20 =g= -M*y6;
ec27..   c6 =e= 7*y6;
*Para Y7
ec28..   exp(x22)-1-x21 =l= M*(1-y7);
ec29..   exp(x22)-1-x21 =g= -M*(1-y7);
ec30..   x21 =l= M*y7;
ec31..   x21 =g= -M*y7;
ec32..   x22 =l= M*y7;
ec33..   x22 =g= -M*y7;
ec34..   c7 =e= 4*y7;
*Para Y8
ec35..   exp(x18)-1-x10-x17 =l= M*(1-y8);
ec36..   exp(x18)-1-x10-x17 =g= -M*(1-y8);
ec37..   x10 =l= M*y8;
ec38..   x10 =g= -M*y8;
ec39..   x17 =l= M*y8;
ec40..   x17 =g= -M*y8;
ec41..   x18 =l= M*y8;
ec42..   x18 =g= -M*y8;
ec43..   c8 =e= 5*y8;
         ;

x1.up=5;
x2.up=5;
x3.up=2;
x4.up=5;
x5.up=2;
x6.up=5;
x7.up=5;
x8.up=5;
x9.up=2;
x10.up=1;
x11.up=5;
x12.up=5;
x13.up=5;
x14.up=1;
x15.up=5;
x16.up=5;
x17.up=2;
x18.up=5;
x19.up=2;
x20.up=5;
x21.up=2;
x22.up=5;
x23.up=5;
x24.up=5;
x25.up=3;

MODEL P5 /all/;

P5.optfile = 1;
$onecho > dicopt.opt
          stop
$offecho

SOLVE P5 using MINLP minimize z;




