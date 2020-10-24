$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

$ontext
Al ser un MINLP podria haber sido necesario emplear esto para ayudar
al programa a encontrar una solución:
option MINLP = SBB;
option MINLP = DICOPT;
$offtext

SETS
         i columnas /c1*c4/
         j componentes /A,B,C,D/
         alias(j,p)
         ;

SCALARS
         PA precio de compra de A
         /0.125/
         PB precio de venta de B
         /0.625/
         k1
         /2/
         k2
         /3/
         top
         /8000/
         Qtmax
         /20000/
         Qalim
         /200/
         ;

PARAMETERS
         xalim(j)
         /A=0.5,B=0,C=0,D=0.5/
         cstf(i) coste fijo de la columna k
         /c1=2000,c2=2000,c3=2000,c4=2000/
         cv1(i)
         /c1=5,c2=5,c3=5,c4=5/
         cv2(i)
         /c1=6,c2=1,c3=1,c4=6/
         ;

TABLE
         xcolum(i,j)
                 A       B       C       D
         c1      1       0       0       1
         c2      1       1       0       1
         c3      0       1       0       0
         c4      1       0       0       1
         ;

BINARY VARIABLE
         y(i) variable binaria asociada a la existencia de la columna k
         ;

POSITIVE VARIABLES
         tau
         Cv(i) coste variable total de la columna k
         Cf(i) coste fijo de la columna k
         E(j) flujo molar de componente j que entra al reactor
         S(j) flujo molar de componente j que sale del reactor
         xS(j) fraccion molar de componente j a la salida del reactor
         Q(i,j) flujo molar de componente j que entra a la columna k
         Qdest(i,j) flujo molar de componente j que se destila en la columna k
         Qres(i,j)  flujo molar de componente j que sale como residuo en la columna k
         F5(j),B5(j),B6(j)
         ;

VARIABLE
         z valor de la función ojetivo a maximizar
         ;

EQUATIONS
         fo
         r1,r2,r3,r4
         c1,c2,c3,c4,c5,c6,c7,c8,c9
         c10,c11,c12,c13
         bm1,bm2,bm3
         ;

fo..        z =e= (Qdest('c3','B')+Qres('c4','B'))*PB*top-Qalim*xalim('A')*PA*top-sum(i,Cv(i))-sum(i,Cf(i));

*REACTOR
r1..        S('A') =e= E('A')*exp(-k1*tau);
r2..        S('B') =e= (k1/(k1-k2))*(exp(-k2*tau)*E('A')-S('A'));
r3..        S('C') =e= E('A')-S('A')-S('B');
r4..        S('D') =e= E('D');

*COLUMNAS
*costes variable de las columnas
c1..        Cv('c1') =e= Cv1('c1')*sum(j,Q('c1',j))+Cv2('c1')*Q('c1','A');
c2..        Cv('c2') =e= Cv1('c2')*sum(j,Q('c2',j))+Cv2('c2')*Q('c2','B');
c3..        Cv('c3') =e= Cv1('c3')*sum(j,Q('c3',j))+Cv2('c3')*Q('c3','B');
c4..        Cv('c4') =e= Cv1('c4')*sum(j,Q('c4',j))+Cv2('c4')*Q('c4','A');

*Defino caudales molares de entrada a las columnas, de destilado y residuo
c5(j)..     Q('c1',j)*sum(p,S(p)) =e=  S(j)*sum(p,Q('c1',p));
c6(j)..     Q('c2',j)*sum(p,S(p)) =e=  S(j)*sum(p,Q('c2',p));
c7(j)..     Q('c3',j) =e= Qres('c1',j);
c8(j)..     Q('c4',j) =e= Qdest('c2',j);
c9(j)..     S(j) =e= Q('c1',j)+Q('c2',j);

*Q('c1',j) =e= xS(j)*sum(p,Q('c1',p));
*Q('c2',j) =e= xS(j)*sum(p,Q('c2',p));
*con xS(j)*sum(p,S(p)) =e= S(j) lo que he hecho es poner esto directamente para que el programa funcione

c10(i,j)..  Qdest(i,j) =e= Q(i,j)*xcolum(i,j);
c11(i,j)..  Qres(i,j) =e= Q(i,j)-Qdest(i,j);

*Aplico ENVOLVENTE CONVEXA A CADA DISYUNCIÓN, donde se decide si se emplea la columna k
c12(i)..    Cf(i) =e= cstf(i)*y(i);
c13(i)..    Qtmax*y(i) =g= sum(j,Q(i,j));

*BALANCES EN NODOS Y SEPARADOR
*BM1 y BM2
bm1(j)..    F5(j) =e= Qdest('c1',j)+Qdest('c4',j);
bm2(j)..    E(j) =e= B5(j)+Qalim*xalim(j);
*SEPARADOR
bm3(j)..    F5(j) =e= B6(j)+B5(j);

$ontext
Al ser problema MINLP, GAMS puede tener problemas,
Por ello conviene darle limites a algunas variables, para ayudarle
a encontrar una solución al problema.
Lo he quitado porque finalmente no hacia falta, pero podria ser util si alguna
vez no se que probar.
Q.l(i,j)=0.1;
B5.l(j)=0.1;
B6.l(j)=0.1;
F5.l(j)=0.1;
$offtext

MODEL P8 /all/;

SOLVE P8 using MINLP maximize z;
