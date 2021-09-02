clear
tic
%Leitura da entrada

fileID = fopen('Ken-07.txt') %Abre o arquivo de entrada
E = fscanf(fileID,'%f',2);    %L� a quantidade de n�s e de arestas
m = E(1);                     %N�mero de n�s
n = E(2);                     %N�mero de arestas
E = fscanf(fileID,'%f',m);    %Ignora o vetor b
E = fscanf(fileID,'%f',[6,n]);%Continua a leitura da entrada
fclose(fileID);               %Fecha o arquivo de entrada

E = E';%Formata��o da matriz de entrada E
E(:,5) = [];  %Remove limite superior
E(:,4) = [];  %Remove limite inferior
E(:,1) = [];  %Remove �ndices das arestas

%{
Testes com matrizes menores

E = [1 2 28; 2 3 16; 4 3 12; 5 4 22; 5 6 25; 5 7 24; 7 2 14; 4 7 18; 6 1 10]  %Grafo teste da internet (passou no teste)
m = 7;  %Num n�s
n = 9;  %Num arestas


E = [1 2 35; 2 3 10; 5 3 20; 4 1 45; 4 2 25; 4 3 20; 5 4 15]; %Grafo das notas de aula (passou no teste)
m = 5;
n = 7;


E = [1 2 6; 2 1 9; 1 3 3; 3 4 3; 4 2 2; 2 3 4; 3 3 1; 5 1 7; 5 3 8; 2 6 5; 4 6 2] %Grafo teste da internet 2 (passou no teste)
m = 6;
n = 11;


E = [1 2 4; 2 3 8; 3 4 7; 4 5 9; 5 6 10; 6 7 2; 7 8 1; 8 1 8; 2 8 11; 4 6 14; 3 9 2; 9 8 7; 9 7 6; 3 6 4] %Grafo teste da internet 3 (passou no teste)
m = 9;
n = 14;


E = [1 6 10; 6 3 3; 3 4 3; 4 5 1; 5 7 3; 7 8 3; 8 1 5; 1 2 8; 6 2 4; 2 3 4; 6 4 6; 8 2 4; 7 4 2; 2 5 4] %Grafo teste da internet 4 (passou no teste)
m = 8;
n = 14;
%}

M = sparse(m,m);  %Matriz M que armazenar� a �rvore Geradora de Custo M�nimo final

%A matriz A fica no final com: E(:,1) = n� de origem, E(:,2) = n� de destino, E(:,3) = custo da aresta

%--------------------------------------------------------------------------------------------------------------------------------------------------

%Ordenar os n�s

E = sortrows(E,[3 1 2]); %Coloca as arestas em ordem crescente de: custos, �ndice do n�-origem e �ndice do n�-destino

%--------------------------------------------------------------------------------------------------------------------------------------------------

%Resolver o problema: Para cada passo, ver se adicionar o pr�ximo n� da lista forma um ciclo. Se n�o formar, adicionar. Se formar, n�o adicionar.
i = 1;            %Numero de iteracoes
num_arestas = 0;  %Contador de arestas na �rvore
custo = 0;        %Custo da �rvore

node.mae = 1:m;               %Vetor com m casas; node.mae(i) armazena o n�-m�e de cada n� i
node.filhos = sparse(eye(m)); %Matriz mxm; node.filhos(i,j) = aij = 1 significa que o n� j � filho do n� i

while ( (num_arestas<m-1) && (i <= n) )

  fprintf('Aresta %d\n',i); %Imprime o n�mero da itera��o
    
  origem = E(i,1);  %Indice do n�-origem da aresta em an�lise
  destino = E(i,2); %Indice do n�-destino da aresta em an�lise

  if ( (node.mae( origem ) != node.mae( destino )) && (origem!=destino) ) %Se a m�e do n�-origem e a m�e do n�-destino forem diferentes
    
    %Identificamos que os n�s-m�e s�o diferentes. Ent�o, como n�o haver� ciclo se incluirmos a aresta,
    % vamos juntar as duas �rvores em uma s�, com o n�-m�e do n�-origem da aresta como nova m�e de todos
    
    num_arestas += 1; %Contador de arestas na �rvore +=1
    custo += E(i,3);  %Custo da aresta � somado ao custo final da �rvore
    
    node.filhos( node.mae(origem),: ) +=  node.filhos( node.mae(destino),: ); %Atualiza os filhos da m�e do n�-origem, incluindo os filhos da m�e do n�-destino
    
 
    aux = find(node.filhos( node.mae(destino), : )); %Vari�vel que armazena os �ndices dos filhos da m�e do n�-destino
    maeaux = node.mae(destino); %Vari�vel auxiliar que armazena a m�e original do n�-destino

    node.mae(aux) = node.mae(origem); %Coloca que o n�-m�e de todos os filhos da m�e do n�-destino ser�o, agora, o n�-m�e do n�-origem
    node.mae(destino) = maeaux; %Volta o n�-m�e do destino para o original para executar a pr�xima linha corretamente
    
   
    node.filhos(node.mae(destino), :) = zeros(1,m); %Zera os filhos do n�-m�e do n�-destino (Ele vira um n�-filho e n�o ser� mais um n�-m�e) 
    
    node.mae(destino) = node.mae(origem); %Atualiza a m�e do n�-destino

    M(origem,destino) = 1;  %Vai preenchendo a matriz de adjac�ncias da �rvore
    
  endif
  
  i++;
  
  fprintf('Quantidade de arestas preenchidas: %d%s\n',(num_arestas*100)/(m-1),'%'); %Imprime a quantidade de arestas preenchidas para se formar uma agcm
  
end

M += M';  %Matriz de adjac�ncias da agcm ou a �rvore m�xima ac�clica do problema

%--------------------------------------------------------------------------------------------------------------------------------------------------
%Imprimir resposta

timeElapsed = toc;  %Tempo de execu��o

%Impress�es em tela finais:

fprintf('\n');
if(num_arestas == m-1)  %Caso achou agcm
  fprintf('O grafo possui �rvore Geradora de Custo M�nimo, e seu custo � c = %d\nA matriz de adjac�ncias dessa �rvore geradora est� armazenada na vari�vel esparsa M.\n',custo)
elseif(num_arestas != m-1)  %Caso n�o foi achada uma agcm para o grafo
  fprintf('O grafo n�o possui �rvore Geradora de Custo M�nimo\n')
  fprintf('N�mero de arestas inclu�das pelo algoritmo: %d/%d = %d%s do necess�rio\n',num_arestas,m-1,(num_arestas*100)/(m-1),'%')
end

fprintf('N�mero de arestas testadas: %d/%d = %d%s do total\n',i-1,n,((i-1)*100)/n,'%')  %N�mero de arestas testadas do problema
fprintf('Tempo de execu��o: %d segundos\n',timeElapsed)

