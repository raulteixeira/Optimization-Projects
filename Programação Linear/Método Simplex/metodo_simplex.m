

%Recebe os dados de input: vetores, matrizes


prompt='Digite o n�mero de restri��es m: ';
m=input(prompt);

prompt='Digite o n�mero de vari�veis n: ';
n=input(prompt);

prompt='Digite o vetor dos custos c (deitado): ';
c=input(prompt);

prompt='Digite a matriz A: ';
A=input(prompt);

prompt='Digite o vetor dos recursos b (em p�): ';
b=input(prompt);


indic=-1;
fprintf('\n')

B=eye(m);
N=A(:,1:n);

%Vetores b�sico e n�o b�sico iniciais:

cb=c(n-m+1:n);
cN=c(1:n-m);

for i=1:m %Vetor dos �ndices das vari�veis b�sicas
  xbindice(i)=n-m+i;
end

for i=1:n-m %Vetor dos �ndices das vari�veis n�o b�sicas
  xnindice(i)=i;
end

for j=1:10000 %loop para resolver o problema

  %solu��o b�sica fact�vel:

  xb=linsolve(B,b);
  
  %vetor multiplicador simplex:
  
  lambda=linsolve(B',cb');
  
  %custos reduzidos das vari�veis n�o b�sicas:
  
  for i=1:n-m
    r(i)=cN(i)-lambda' * N(:,i);
  end
  [R,entra]=min(r); %Retorna o m�nimo custo e seu �ndice
  
  if R>0 %Se o menor custo reduzido for maior que zero
    indic=0;
    break
  elseif R==0
    indic=1;
    break
  end
  
  %Dire��o Simplex
    
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
    
    %Atualiza os �ndices de xb
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


  %Verifica se � um caso de degenera��o:
  
  for i=1:m
    if xb(i)==0
      indic = 3;
    end
  end
  
  
  %Sa�das---------------------------------------------------------
  
if indic == 0
  fprintf('O problema tem solu��o �tima, que � f = %f\nPara o qual os valores das vari�veis do problema s�o: \n',cb*xb)
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
  fprintf('O problema tem soluc�es m�ltiplas. O valor  �timo da fun��o � f = %f\nPara a qual os valores das vari�veis do problema s�o: \n',cb*xb)
  
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
  disp('O problema � ilimitado.')
  
    %---------------------------------------------------------
    
elseif indic == 3
  fprintf('O problema tem solu��o degenerada. O valor  �timo da fun��o � f = %f\nPara a qual os valores das vari�veis do problema s�o: \n',cb*xb)
  
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
indic=0 -> solu��o otima
indic=1 -> multiplas solucoes
indic=2 -> problema ilimitado
indic=3 ->caso degenerado
%}