clear
tic
%Leitura da entrada

fileID = fopen('Ken-07.txt') %Abre o arquivo de entrada
E = fscanf(fileID,'%f',2);    %Lê a quantidade de nós e de arestas
m = E(1);                     %Número de nós
n = E(2);                     %Número de arestas
E = fscanf(fileID,'%f',m);    %Ignora o vetor b
E = fscanf(fileID,'%f',[6,n]);%Continua a leitura da entrada
fclose(fileID);               %Fecha o arquivo de entrada

E = E';%Formatação da matriz de entrada E
E(:,5) = [];  %Remove limite superior
E(:,4) = [];  %Remove limite inferior
E(:,1) = [];  %Remove índices das arestas

%{
Testes com matrizes menores

E = [1 2 28; 2 3 16; 4 3 12; 5 4 22; 5 6 25; 5 7 24; 7 2 14; 4 7 18; 6 1 10]  %Grafo teste da internet (passou no teste)
m = 7;  %Num nós
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

M = sparse(m,m);  %Matriz M que armazenará a Árvore Geradora de Custo Mínimo final

%A matriz A fica no final com: E(:,1) = nó de origem, E(:,2) = nó de destino, E(:,3) = custo da aresta

%--------------------------------------------------------------------------------------------------------------------------------------------------

%Ordenar os nós

E = sortrows(E,[3 1 2]); %Coloca as arestas em ordem crescente de: custos, índice do nó-origem e índice do nó-destino

%--------------------------------------------------------------------------------------------------------------------------------------------------

%Resolver o problema: Para cada passo, ver se adicionar o próximo nó da lista forma um ciclo. Se não formar, adicionar. Se formar, não adicionar.
i = 1;            %Numero de iteracoes
num_arestas = 0;  %Contador de arestas na árvore
custo = 0;        %Custo da árvore

node.mae = 1:m;               %Vetor com m casas; node.mae(i) armazena o nó-mãe de cada nó i
node.filhos = sparse(eye(m)); %Matriz mxm; node.filhos(i,j) = aij = 1 significa que o nó j é filho do nó i

while ( (num_arestas<m-1) && (i <= n) )

  fprintf('Aresta %d\n',i); %Imprime o número da iteração
    
  origem = E(i,1);  %Indice do nó-origem da aresta em análise
  destino = E(i,2); %Indice do nó-destino da aresta em análise

  if ( (node.mae( origem ) != node.mae( destino )) && (origem!=destino) ) %Se a mãe do nó-origem e a mãe do nó-destino forem diferentes
    
    %Identificamos que os nós-mãe são diferentes. Então, como não haverá ciclo se incluirmos a aresta,
    % vamos juntar as duas árvores em uma só, com o nó-mãe do nó-origem da aresta como nova mãe de todos
    
    num_arestas += 1; %Contador de arestas na árvore +=1
    custo += E(i,3);  %Custo da aresta é somado ao custo final da árvore
    
    node.filhos( node.mae(origem),: ) +=  node.filhos( node.mae(destino),: ); %Atualiza os filhos da mãe do nó-origem, incluindo os filhos da mãe do nó-destino
    
 
    aux = find(node.filhos( node.mae(destino), : )); %Variável que armazena os índices dos filhos da mãe do nó-destino
    maeaux = node.mae(destino); %Variável auxiliar que armazena a mãe original do nó-destino

    node.mae(aux) = node.mae(origem); %Coloca que o nó-mãe de todos os filhos da mãe do nó-destino serão, agora, o nó-mãe do nó-origem
    node.mae(destino) = maeaux; %Volta o nó-mãe do destino para o original para executar a próxima linha corretamente
    
   
    node.filhos(node.mae(destino), :) = zeros(1,m); %Zera os filhos do nó-mãe do nó-destino (Ele vira um nó-filho e não será mais um nó-mãe) 
    
    node.mae(destino) = node.mae(origem); %Atualiza a mãe do nó-destino

    M(origem,destino) = 1;  %Vai preenchendo a matriz de adjacências da árvore
    
  endif
  
  i++;
  
  fprintf('Quantidade de arestas preenchidas: %d%s\n',(num_arestas*100)/(m-1),'%'); %Imprime a quantidade de arestas preenchidas para se formar uma agcm
  
end

M += M';  %Matriz de adjacências da agcm ou a árvore máxima acíclica do problema

%--------------------------------------------------------------------------------------------------------------------------------------------------
%Imprimir resposta

timeElapsed = toc;  %Tempo de execução

%Impressões em tela finais:

fprintf('\n');
if(num_arestas == m-1)  %Caso achou agcm
  fprintf('O grafo possui Árvore Geradora de Custo Mínimo, e seu custo é c = %d\nA matriz de adjacências dessa árvore geradora está armazenada na variável esparsa M.\n',custo)
elseif(num_arestas != m-1)  %Caso não foi achada uma agcm para o grafo
  fprintf('O grafo não possui Árvore Geradora de Custo Mínimo\n')
  fprintf('Número de arestas incluídas pelo algoritmo: %d/%d = %d%s do necessário\n',num_arestas,m-1,(num_arestas*100)/(m-1),'%')
end

fprintf('Número de arestas testadas: %d/%d = %d%s do total\n',i-1,n,((i-1)*100)/n,'%')  %Número de arestas testadas do problema
fprintf('Tempo de execução: %d segundos\n',timeElapsed)

