

%Recebe os dados de input: vetores, matrizes


prompt='Digite o número de restrições m: ';
m=input(prompt);

prompt='Digite o número de variáveis n: ';
n=input(prompt);

prompt='Digite o vetor dos custos c (deitado): ';
c=input(prompt);

prompt='Digite a matriz A: ';
A=input(prompt);

prompt='Digite o vetor dos recursos b (em pé): ';
b=input(prompt);


indic=-1;
fprintf('\n')

B=eye(m);
N=A(:,1:n);

%Vetores básico e não básico iniciais:

cb=c(n-m+1:n);
cN=c(1:n-m);

for i=1:m %Vetor dos índices das variáveis básicas
  xbindice(i)=n-m+i;
end

for i=1:n-m %Vetor dos índices das variáveis não básicas
  xnindice(i)=i;
end

for j=1:10000 %loop para resolver o problema

  %solução básica factível:

  xb=linsolve(B,b);
  
  %vetor multiplicador simplex:
  
  lambda=linsolve(B',cb');
  
  %custos reduzidos das variáveis não básicas:
  
  for i=1:n-m
    r(i)=cN(i)-lambda' * N(:,i);
  end
  [R,entra]=min(r); %Retorna o mínimo custo e seu índice
  
  if R>0 %Se o menor custo reduzido for maior que zero
    indic=0;
    break
  elseif R==0
    indic=1;
    break
  end
  
  %Direção Simplex
    
  d=linsolve( B,N(:,entra) );
    
  %Tamanho do passo:
    
  epslonaux=xb./d; %checar o que acontece p/ d=0
  epslon=999999999;
    
  for i=1:m %computa o valor de epslon
      if ( d(i)>0 ) && (epslonaux(i)<epslon) 
        epslon=epslonaux(i);
        sai=i;
      end
  end
       
  if epslon==999999999
    indic=2;
    break
  end
  
    %Atualizando a base:
    
    %Atualiza os índices de xb
    auxindiceentra=xnindice(entra);
    auxindicesai=xbindice(sai);
    
    xbindice(sai)=auxindiceentra;
    xnindice(entra)=auxindicesai;
    
    
    B(:,sai)=A(:,entra); %Sai=o que sai ; entra = o que entra
    
    N(:,entra)=A(:,sai);
      
    aux1=cN(entra);
    aux2=cb(sai);
      
    cb(sai)=aux1;
    cN(entra)=aux2;
    

end


  %Verifica se é um caso de degeneração:
  
  for i=1:m
    if xb(i)==0
      indic = 3;
    end
  end
  
  
  %Saídas---------------------------------------------------------
  
if indic == 0
  fprintf('O problema tem solução ótima, que é f = %f\nPara o qual os valores das variáveis do problema são: \n',cb*xb)
  for i=1:m  %valor para cada xi
    if ( xbindice(i)>=1 ) && ( xbindice(i)<=n-m )
      fprintf('x%d = %f\n',xbindice(i),xb(i))
    end
  end
  
  for i=1:n-m
    if ( xnindice(i)>=1 ) && ( xnindice(i)<=n-m )
      fprintf('x%d = %f\n',xnindice(i),0)
    end
  end
  %------------------------------------------------------------
  
elseif indic == 1
  fprintf('O problema tem solucões múltiplas. O valor  ótimo da função é f = %f\nPara a qual os valores das variáveis do problema são: \n',cb*xb)
  
  for i=1:m  %valor para cada xi
    if ( xbindice(i)>=1 ) && ( xbindice(i)<=n-m )
      fprintf('x%d = %f\n',xbindice(i),xb(i))
    end
  end
  
  for i=1:n-m
    if ( xnindice(i)>=1 ) && ( xnindice(i)<=n-m )
      fprintf('x%d = %f\n',xnindice(i),0)
    end
  end
    %------------------------------------------------------------
  
elseif indic == 2
  disp('O problema é ilimitado.')
  
    %---------------------------------------------------------
    
elseif indic == 3
  fprintf('O problema tem solução degenerada. O valor  ótimo da função é f = %f\nPara a qual os valores das variáveis do problema são: \n',cb*xb)
  
  for i=1:m  %valor para cada xi
    if ( xbindice(i)>=1 ) && ( xbindice(i)<=n-m )
      fprintf('x%d = %f\n',xbindice(i),xb(i))
    end
  end
  
  for i=1:n-m
    if ( xnindice(i)>=1 ) && ( xnindice(i)<=n-m )
      fprintf('x%d = %f\n',xnindice(i),0)
    end
  end
end


%{
indic=0 -> solução otima
indic=1 -> multiplas solucoes
indic=2 -> problema ilimitado
indic=3 ->caso degenerado
%}