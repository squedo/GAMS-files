$offsymxref
$offsymlist
option limrow=50;
option limcol=50;
option sysout=off;
option solprint=on;
option LP = CPLEX ;
option MIP = CPLEX;
option NLP = CONOPT;
option MINLP = DICOPT;
option optcr=0;


SETS
        i nodos
        /n1*n11/
        alias (i,j)
        ;

SETS
        R(i,j) relacion entre nodo i y nodo j
        /n1.(n2,n5,n9),n2.(n3,n4),n3.(n10,n11),n4.(n5,n6,n10),n5.n6,n6.(n7,n9),n7.n9,n8.n7,n9.n11,n10.(n8,n11)/
        ;

TABLE
         C(i,j) coste de transportar los bariles del nodo i al j

         n1      n2      n3      n4      n5      n6      n7      n8      n9     n10     n11
n1        0       5       0       0       3       0       0       0      15       0       0
n2        0       0       4       6       0       0       0       0       0       0       0
n3        0       0       0       0       0       0       0       0       0       9       2
n4        0       0       0       0       6       2       0       0       0       3       0
n5        0       0       0       0       0       3       0       0       0       0       0
n6        0       0       0       0       0       0       5       0       8       0       0
n7        0       0       0       0       0       0       0       0       9       0       0
n8        0       0       0       0       0       0       2       0       0       0       0
n9        0       0       0       0       0       0       0       0       0       0       4
n10       0       0       0       0       0       0       0       4       0       0       6
n11       0       0       0       0       0       0       0       0       0       0       0
         ;

POSITIVE VARIABLES
         x(i,j) numero de barriles transportados del nodo i al j
         ;

VARIABLES
         z coste total del transporte
         ;

*Situación inicial y final de los barriles
PARAMETERS
         E(i) situación de los barriles al comienzo
         /n1=500,n2=0,n3=0,n4=0,n5=0,n6=0,n7=0,n8=0,n9=0,n10=0,n11=0/
         S(i) situación de los barriles al final
         /n1=0, n2=0, n3=0, n4=0, n5=0, n6=0, n7=0, n8=0, n9=0, n10=200, n11=300/
         ;

EQUATIONS
         fo,bm
         ;

fo..     z =e= sum((i,j), x(i,j)*C(i,j));
bm(i)..  E(i)+sum(j$(R(j,i)), x(j,i))-S(i)-sum(j$(R(i,j)), x(i,j)) =e= 0;

MODEL P0a /all/;

SOLVE P0a using LP minimizing z;



