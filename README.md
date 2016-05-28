# Projeto 2 - SCC-5900  – Projeto de algoritmos

A proposta deste projeto é explorar e entender o algoritimo Dynamic Time Warping (DTW) que calcula a similaridade entre séries temporais e usá-lo junto ao KNN em tarefas de classificação de dados.

Os detalhes do projeto podem ser [consultados aqui](https://github.com/DaniloOliveira28/Dynamic_Time_Warping/blob/master/Data/Projeto2.pdf)

# Dynamic Time Warping (DTW)
Em análises de séries temporais, medir similaridade requer algoritmos e estratégias particulares, pois sequências de dados discretos que variam conforme o tempo e velocidade possuem estrutura e natureza distintas de dados mais simples, por exemplo: binários. Neste sentido, o algoritmo Dynamic Time Warping(DTW)[1] é um ótimo candidato para esta tarefa.

O algoritmo DTW encontra o alinhamento ótimo entre duas sequências de observações por entortar a dimensão de tempo com certas restrições.

Devido a esta deformação dimensão temporal, DTW é bom para a classificação de sequências que têm diferentes frequências ou que estão fora de fase.

O diagrama abaixo mostra como uma representação matriz de distância DTW.

<img src="https://upload.wikimedia.org/wikipedia/commons/a/ab/Dynamic_time_warping.png" alt="Drawing" style="width: 200px;"/>

![alt DTW]()

# KNN com DTW
KNN é um algoritmo de classificação de dados familiar para muitos no mundo aprendizado de máquina. Basicamente ele funciona do seguinte modo, dado uma observação não rotulada (a estrela abaixo), ele é comparado com uma população de observações rotuladas (círculos azuiz e laranjas). Ao encontrar os círculos mais próximos K para a estrela, podemos inferir o rótulo de classe para a estrela por meio de votação por maioria. Por exemplo, para K = 6 a estrela é classifica como da classe A.

Usando o DTW para o cálculo de distâncias podemos  usar KNN no contexto dos dados de séries de tempo. 

![alt KNN com DTW](https://raw.githubusercontent.com/markdregan/K-Nearest-Neighbors-with-Dynamic-Time-Warping/master/images/dtw_knn_schematic.png)

# Estudo de Caso do projeto
O objetivo deste projeto é implementar um algoritmo de classificação de séries temporais utilizando a distância Dynamic Time Warping (DTW) e dados obtidos a partir de acelerômetros.
Essa base consiste de movimentos realizados com um controle do videogame Wii.

## Janela Sakoe-Chiba
O uso da matriz completa da DTW pode levar a alguns casamentos espúrios. Isso porque os pontos da matriz distantes da diagonal ascendente representam casamentos entre observações distantes das séries em comparação. Uma solução para esse problema é implementar uma banda de restrição, como a banda de Sakoe-Chiba. Essa banda restringe os pontos que podem ser casados para uma distância máxima da diagonal, como ilustrado abaixo.

![alt Sakoe-Chiba](https://raw.githubusercontent.com/DaniloOliveira28/Dynamic_Time_Warping/master/images/sakoechiba.png)

## Cython

O DTW, em sua implementação mais simples, possui uma ordem de complexidade de O(n^2) e apesar das melhorias de perfomance decorrentes do uso da banda Sakoe-Chiba, usando a implementação em Python, a sua execução fica extremamente lenta, por isso, afim de melhorar o tempo de execução usamos o Cython [5].

## Classe KnnDTW
A classe KnnDtw, possui 6 métodos:
## KnnDtw.set_bandwidth
Ajusta o tamanho da largura da janela e dos pontos que serão casados.

## KnnDtw.fit
Este método treina o algoritmo com a base de treino e de referência no cálculo de distâncias.

## KnnDtw._distance_points
Este método calcula a distância entre dois pontos dados.

## KnnDtw._dtw_distance
Este método calcula a distância entre duas séries temporais dadas.

## KnnDtw._dist_matrix
Dada uma base de testes, para cada série de teste este método calcula a distância desta série-teste para cada série na base de treino.

## KnnDtw.predict
Dada a matriz, para cada série de testes, este métodos, através do 1-KNN prediz qual é o seu rótulo.

## Script run1d 
O script run1d.py executa a classificação para a base de dados proposta pelo projetos com bandas de: 0%, 1%, 5%, 10%, 20%,100%. Um banda de 100% corresponde a todos os casamentos possíveis, ou seja, como se não houvesse a implementação da janela Sakoe-Chiba.

## Execução
Para executar o algoritmo, basta seguir os passos abaixo:
### Checar Requerimentos
Os seguintes pacotes em python são necessários:
* numpy
* scipy
* progressbar
* unicodecsv
* csv
### Compilar
Para compilar:

    python setup.py build_ext --inplace

### Executar o programa
Para rodar:

    python run1D.py 

# Resultados
Puro Python*
![alt text](http://raw.githubusercontent.com/DaniloOliveira28/Dynamic_Time_Warping/master/images/results.png)
*infelizmente com o algoritmo puro em python não foi calculada para todas as bandas propostas no projeto.

Python com Cython
![alt text](https://raw.githubusercontent.com/DaniloOliveira28/Dynamic_Time_Warping/master/images/results_cython.png "Histograma de Tempo")

# Conclusões
O DTW + KNN implementados em uma linguagem e ambiente de alta performance e com estrategia como o Sakoe-Chiba mostra-se um ótimo aliado para classificação de séries temporais e que podem ser aplicados em projetos como classificação de movimentos.
O melhor resultado encontrado foi com uma janela de 20% e que roda com praticamente metade do tempo considerando uma janela de 100%.

# To Do
O projeto propões a adaptação para séries temporais representadas por 3 dimensões. Para isso é necessário adaptar o modo como o algoritmo calcula a similaridade. 

# Referências
[1] Dynamic Time Warping. https://en.wikipedia.org/wiki/Dynamic_time_warping.
[2] Eduardo T. Bogue, Edson T. Matsubara, Anderson C. Bessa. Uma Abordagem em Reconhecimento de Movimentos Utilizando TRKNN e Dynamic Time Warping. ENIA 2012.
[3] Mohammad Shokoohi-Yekta, Jun Wang and Eamonn Keogh. On the Non-Trivial Generalization of Dynamic Time Warping to the Multi-Dimensional Case. SDM 2015.
[4] DTW-KNN. https://github.com/markdregan/K-Nearest-Neighbors-with-Dynamic-Time-Warping
[5] Speeding up python numpy cython http://technicaldiscovery.blogspot.com.br/2011/06/speeding-up-python-numpy-cython-and.html
