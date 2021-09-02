global epslon=10^-8;
global epslonaux=10^-2;
global tau=0.99995;
global M=10^10;

%-----Lendo os parâmetros do problema-----

%load('scfxm3');
load('scsd8');

[m,n]=size(A);

%-----Ponto Inicial-----

[x,y,z]=pontoinicial(A,b,c);

%-----Vetores e variáveis utilizados durante o programa-----

e=1;
for i=2:n
  e=[e;1];
end

%-----LOOP-----

for i=1:250
   
  d=x./z;
  
  %-----Resíduos-----
  
  rp = b - (A*x);
  rd = c -((A')*y)-z;
  ra = -diag(sparse(x))*diag(sparse(z))*e;
  
  
  %-----direção afim escala preditiva-----  
  
  [R,p]=chol(sparse(A*diag(sparse(d))*(A')));
  
  w=(R')\(rp + (A*diag(sparse(d))*(rd-(inv(diag(sparse(x)))*ra)) ));
  dy=R\w;

  dx=diag(sparse(d))*((A')*dy - rd + inv(diag(sparse(x)))*ra);
  
  dz=inv(diag(sparse(x)))*(ra-diag(sparse(z))*dx);
  
  %-----Tamanho do passo preditivo-----
  alfap=min([tampasso(x,dx,n) 1]);
  alfad=min([tampasso(z,dz,n) 1]);
  
  %-----valor do gap-----
  gamma=(x')*z
  gammatil=((x+(alfap*dx))')*(z+(alfad*dz));
  %Escolher os valores de mi dentre os 3 abaixo
  mi=((gammatil/gamma)^2)*(gammatil/n);
  %mi=gamma/(n^2);
  %{
  if gamma<1
    mi=((gammatil/gamma)^2)*(gammatil/n);
  else
    mi=gamma/(n^2);
  end
  %}
  
  %-----resíduo corretor-----
  rc=mi*e - diag(sparse(dx))*diag(sparse(dz))*e + ra;
  
  %-----direção corretora-----
   
  w=(R')\(rp + (A*diag(sparse(d))*(rd-(inv(diag(sparse(x)))*rc)) ));
  dy=R\w;

  dx=diag(sparse(d))*((A')*dy - rd + inv(diag(sparse(x)))*rc);
  
  dz=inv(diag(sparse(x)))*(rc-diag(sparse(z))*dx);

  %-----Tamanho do passo corretor-----
  
  alfap=min([tampasso(x,dx,n) 1]);
  alfad=min([tampasso(z,dz,n) 1]);
  
  %-----Atualização-----
  
  x=x+(alfap*dx);
  y=y+(alfad*dy);
  z=z+(alfad*dz);
  
  %Critério de parada
  
  criterio1=(norm(b-(A*x)))/(1+norm(b));
  criterio2=(  (norm(c-((A')*y)-z) )/(1+norm(c)));
  criterio3=(((x')*z)/(1+abs(c'*x)+abs((b')*y)));

  if criterio1<epslon && criterio2<epslon && criterio3<epslon
    break
  end
  
end

valor_da_funcao_final_primal=(c')*x
valor_da_funcao_final_dual=(b')*y
disp('Numero de iteracoes:')
disp(i)