*columna 2,4 y 5
*Debe dar z =e= 689.948

$offsymxref
$offsymlist
option limrow=0;
option limcol=0;
option sysout=off;
option solprint=on;
option optcr=0;

SETS
         i columnas /c1*c5/
         k nodos /n1,n2,n3/
         j componentes /A,B,C/
         alias(j,p)
         ;

SCALAR
         Qalim caudal molar total de la alimentación en kmol por h
         /100/
         ;

PARAMETERS
         cf(i) coste fijo de la columna i
         /c1=100,c2=100,c3=100,c4=75,c5=30/
         cv(i) coste variable de columna i
         /c1=20,c2=10,c3=15,c4=8,c5=5/
         xalim(j)
         /A=0.2,B=0.3,C=0.5/
         ;

TABLE
         xcolum(i,j) fracción de componente j que sale con el destilado de la columna i

                     A      B      C
             c1   0.98   0.02      0
             c2   0.98    0.5   0.02
             c3   0.98   0.98   0.02
             c4      1   0.98   0.02
             c5   0.98   0.02      0
         ;

TABLE
         porcentaje(k,j)

                    A      B     C
             n1   0.8   0.15  0.05
             n2   0.1    0.8   0.1
             n3  0.05   0.10  0.80
         ;

POSITIVE VARIABLES
         Q(i,j) caudal molar de componente j que llega a cada columna i
         Qdest(i,j) caudal molar de componente j que sale con el destilado en la columna i
         Qres(i,j)  caudal molar de componente j que sale con el residuo en la columna i
         C(i) coste de cada columna
         cstf(i) coste fijo asociado a la columna i en caso de que este operativa
         S1(j),S2(j),S3(j)
         ;

VARIABLES
         z valor de la función objetivo que minimiza el coste total del proceso
         ;

BINARY VARIABLES
         y(i) variable binaria asociada a la disyunción de la columna i
         ;

EQUATIONS
         fo,cst,rest
         ec1,ec2
         ec3,ec4
         ec5,ec6,ec7
         ec8,ec9,ec10,ec11,ec12
         ec13 balance de materia en el divisor inicial
         lim1,lim2,lim3,lim4,lim5,lim6,lim7,lim8,lim9
         ;


fo..          z =e= sum(i,C(i));
cst(i)..      C(i) =e= cstf(i)+cv(i)*sum(j,Qdest(i,j));
rest..        y('c1')+y('c2')+y('c3') =e= 1;

*Defino los caudales molar de destilado y residuo, para elcomponente j en cada columna i.
*Conocidos estos, puedo definir Q('c4',j) y Q('c5',j) como veremos mas adelante.
ec1(i,j)..    Qdest(i,j) =e= Q(i,j)*xcolum(i,j);
ec2(i,j)..    Qres(i,j) =e= Q(i,j)-Qdest(i,j);

*Aplico ENVOLVENTE CONVEXA PARA CADA DISYUNCIÓN de DOS TÉRMINOS en cada columna i
ec3(i)..      cstf(i) =e= cf(i)*y(i);
ec4(i,j)..    Q(i,j) =l= Qalim*xalim(j)*y(i);

*Sabiendo que la composición de las corrientes que salen del divisor inicial deben ser las mismas que Qalim
*puedo definir S1,S2,S3 asi como Q('c1',j),Q('c2',j) y Q('c3',j).
*Añado ademas el BM total en el divisor inicial.
ec5(j)..      S1(j) =e= xalim(j)*sum(p,S1(p));
ec6(j)..      S2(j) =e= xalim(j)*sum(p,S2(p));
ec7(j)..      S3(j) =e= xalim(j)*sum(p,S3(p));
ec8(j)..      Q('c1',j) =e= xalim(j)*sum(p,Q('c1',p));
ec9(j)..      Q('c2',j) =e= xalim(j)*sum(p,Q('c2',p));
ec10(j)..     Q('c3',j) =e= xalim(j)*sum(p,Q('c3',p));

ec11(j)..     Q('c4',j) =e= Qres('c1',j)+Qres('c2',j);
ec12(j)..     Q('c5',j) =e= Qdest('c2',j)+Qdest('c3',j);

ec13(j)..     Qalim*xalim(j) =e= S1(j)+S2(j)+S3(j)+Q('c1',j)+Q('c2',j)+Q('c3',j);

*LIMITES PARA CADA NODO
*NODO A (llamado n1)
lim1..        Qalim*xalim('A')*porcentaje('n1','A') =l= Qdest('c1','A')+Qdest('c5','A')+S1('A');
lim2..        Qalim*xalim('B')*porcentaje('n1','B') =g= Qdest('c1','B')+Qdest('c5','B')+S1('B');
lim3..        Qalim*xalim('C')*porcentaje('n1','C') =g= Qdest('c1','C')+Qdest('c5','C')+S1('C');
*NODO B (llamado n2)
lim4..        Qalim*xalim('A')*porcentaje('n2','A') =g= Qdest('c4','A')+Qres('c5','A')+S2('A');
lim5..        Qalim*xalim('B')*porcentaje('n2','B') =l= Qdest('c4','B')+Qres('c5','B')+S2('B');
lim6..        Qalim*xalim('C')*porcentaje('n2','C') =g= Qdest('c4','C')+Qres('c5','C')+S2('C');
*NODO c (llamado n3)
lim7..        Qalim*xalim('A')*porcentaje('n3','A') =g= Qres('c3','A')+Qres('c4','A')+S3('A');
lim8..        Qalim*xalim('B')*porcentaje('n3','B') =g= Qres('c3','B')+Qres('c4','B')+S3('B');
lim9..        Qalim*xalim('C')*porcentaje('n3','C') =l= Qres('c3','C')+Qres('c4','C')+S3('C');

MODEL P6 /all/;

SOLVE P6 using MIP minimizing z;



