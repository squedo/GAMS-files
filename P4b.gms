$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

SETS
         i producto /p1*p2/
         j semana /s1*s4/
         ;

PARAMETERS
         Tlimp(i) tiempo de limpieza para el producto i
         /p1=6,p2=11/
         Climp(i) coste de limpieza del producto i
         /p1=250,p2=400/
         Tprod(i) tiempo necesario para producir el producto i
         /p1=0.5,p2=0.75/
         Cprod(i) coste de producción por unidad del producto i
         /p1=9,p2=14/
         Calm(i) coste de almacenar una semana una unidad del producto i
         /p1=3,p2=3/
         Penal(i) penalización por unidad y semana del producto i no satisfecho
         /p1=15,p2=20/
         P(i) precio de venta del producto i
         /p1=25,p2=35/
         Dtot(i) demanda total del producto i
         /p1=320,p2=125/
         T tiempo de producción por semana
         /80/
         ;

TABLE
         D(i,j) demanda del producto i en la semana j

               s1   s2   s3   s4
         p1    75   95   60   90
         p2    20   30   45   30
         ;


POSITIVE VARIABLES
         x(i,j) producto i en la semana j
         xa(i,j) almacenado del producto i en la semana j
         xn(i,j) no satisfecho del producto i en la semana j
         Cv(i,j) coste variable de producción de producto i en la semana j
         Cf(i,j) coste fijo de producción de producto i en la semana j
         Tlimpieza(i,j)
         ;

BINARY VARIABLES
         y(i,j) variable binaria asociada a la disyunción del producto i en la semana j
         w(i,j) variable binaria asociada a la limpieza o no de producto i en la semana j

VARIABLES
         z valor de la función objetivo a maximizar
         ;

EQUATIONS
         fo,ec0
         rest1
         rest2,rest3,rest4,rest5
         ec1,ec2,ec3,ec4
         ec5,ec6,ec7,ec8
         ;

*función objetivo empleada para maximizar los beneficios
fo..        z =e= sum((i,j),x(i,j)*P(i)-(Cv(i,j)+Cf(i,j)));
ec0(i,j).. Cv(i,j) =e= Cprod(i)*x(i,j)+Calm(i)*xa(i,j)+Penal(i)*xn(i,j);

*Restricciones
rest1(j)..   sum(i,y(i,j)) =e= 1;

rest2(i,j).. 1-y(i,j)+y(i,j+1) + w(i,j) =g= 1;
rest3(i,j).. 1-w(i,j)+y(i,j) =g= 1 ;
rest4(i,j).. 1-w(i,j)+1-y(i,j+1) =g= 1 ;
rest5(i)..   w(i,'s4') =e= y(i,'s4');

*Relaciones entre lo almacenado, no satisfecho, producido y demanda entre dos semanas consecutivas
ec1(i).. xn(i,'s1')+x(i,'s1') =e= D(i,'s1')+xa(i,'s1');
ec2(i).. xn(i,'s2')+xa(i,'s1')+x(i,'s2') =e= D(i,'s2')+xn(i,'s1')+xa(i,'s2');
ec3(i).. xn(i,'s3')+xa(i,'s2')+x(i,'s3') =e= D(i,'s3')+xn(i,'s2')+xa(i,'s3');
ec4(i).. xn(i,'s4')+xa(i,'s3')+x(i,'s4') =e= D(i,'s4')+xn(i,'s3')+xa(i,'s4');

*Ec resultantes de emplear envolvente convexa para las disyunciones del problema
ec5(i,j)..  Cf(i,j) =e= Climp(i)*w(i,j);
ec6(i,j)..  Tlimpieza(i,j) =e= Tlimp(i)*w(i,j);

ec7(i,j)..  T*y(i,j) =g= Tlimpieza(i,j)+Tprod(i)*x(i,j);
ec8(i,j)..  x(i,j) =l= Dtot(i)*y(i,j);

*Al final de s4 no puede haber nada almacenado
xa.fx(i,'s4')=0;

MODEL P4a /all/;

SOLVE P4a using MIP maximize z;



$ontext
rest1(j).. sum(i,y(i,j)) =e= 1;


rest2(i,j)$(ord(j) lt card(j))..
                 1-y(i,j) + y(i,j+1) + w(i,j) =g= 1;

rest3(i,j)$(ord(j) le card(j))..
                 1-w(i,j) + y(i,j) =g= 1 ;
rest4(i,j)$(ord(j) lt card(j))..
                1-w(i,j) + 1-y(i,j+1) =g= 1 ;


rest5(i).. w(i,'s4') =e= y(i,'s4');
$offtext
