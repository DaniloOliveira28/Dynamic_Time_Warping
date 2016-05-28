# Projeto 2 - SCC-5900  – Projeto de algoritmos

A proposta deste projeto é explorar e entender o algoritimo Dynamic Time Warping (DTW) que calcula a similaridade entre séries temporais e como usá-lo em tarefas de classificação de dados.
Os detalhes do projeto podem ser [consultados aqui](https://github.com/DaniloOliveira28/Dynamic_Time_Warping/blob/master/Data/Projeto2.pdf)

# Dynamic Time Warping (DTW)
Em análises de séries temporais, medir simlaridade requer algoritmos e estratégias particulares, pois sequencias de dados discretos que variam conforme o tempo e velocidade possuem estrutura e natureza distintas de dados mais simples, por exemplo: binários.

Neste sentido, apresentamos o Dynamic Time Warping(DTW)[1] que é um algoritmo desenvolvido para calcular a similaridade entre séries temporais que podem variar na velocidade ou no tempo.

O algoritmo DTW encontra o alinhamento ótimo entre duas sequências de observações por entortar a dimensão de tempo com certas restrições.

Devido a esta deformação dimensão temporal, DTW é bom para a classificação de sequências que têm diferentes frequências ou que estão fora de fase. Mais tarde vamos ver como podemos usar DTW para classificar se uma pessoa está andando, deitado, sentado etc.

O diagrama à direita acima mostra como uma representação matriz de distância DTW. Cada célula é calculado através da medição da distância entre AiAi e BjBj. O caminho vermelho representa o caminho mais curto e alinhamento, portanto, ideal das duas sequências.

![alt DTW](https://upload.wikimedia.org/wikipedia/commons/a/ab/Dynamic_time_warping.png)

# KNN com DTW
KNN é um algoritmo de classificação de dados familiar para muitos no mundo aprendizado de máquina. Basicamente ele funciona do seguinte modo, dado uma observação não rotulada (a estrela abaixo), ele é comparado com uma população de observações rotuladas (círculos azuiz e laranjas). Ao encontrar os círculos mais próximos K para a estrela, podemos inferir o rótulo de classe para a estrela por meio de votação por maioria. Por exemplo, para K = 6 a estrela é classifica como da classe A.

Podemos também usar KNN no contexto dos dados de séries de tempo. Porém não é intuitivo calcular distância entre séries temporais. Para resolver este problema usamos o DTW apresentado anteriormente. 

![alt KNN com DTW](https://raw.githubusercontent.com/markdregan/K-Nearest-Neighbors-with-Dynamic-Time-Warping/master/images/dtw_knn_schematic.png)

# Estudo de Caso do projeto
Nesta seção detalhamos a classe KNN_DTW implementada como a execução com os dados disponibilizados por [2].

## Janela Sakoe-Chiba
O uso da matriz completa da DTW pode levar a alguns casamentos espúrios. Isso porque os pontos da matriz distantes da diagonal ascendente representam casamentos entre observações distantes das séries em comparação. Uma solução para esse problema é implementar uma banda de restrição, como a banda de Sakoe-Chiba. Essa banda restringe os pontos que podem ser casados para uma distância máxima da diagonal, como ilustrado abaixo.

![alt Sakoe-Chiba](https://raw.githubusercontent.com/DaniloOliveira28/Dynamic_Time_Warping/master/images/sakoechiba.png)

## Cython

O DTW, em sua implementação mais simples, possui uma ordem de complexidade de O(n^2) e apesar das melhorias de perfomance decorrentes do uso da banda Sakoe-Chiba, usando a implementação em Python, a sua execução fica extremamente lenta, por isso, afim de melhorar o tempo de execução usamos o Cython [5].

## Implementação
A classe KnnDtw, possui 6 métodos:
## KnnDtw.set_bandwidth
Ajusta o tamanho da largura da janela e dos pontos que serão casados.

## KnnDtw.fit


## KnnDtw._distance_points
## KnnDtw._dtw_distance
## KnnDtw._dist_matrix
## KnnDtw.predict

O script run1d.py executa a classificação para a base de dados proposta pelo projetos com bandas de: 0%, 1%, 5%, 10%, 20%,100%. Um banda de 100% corresponde a todos os casamentos possíveis, ou seja, como se não houvesse a implementação da janela Sakoe-Chiba.

## Execução
Para executar o algoritmo, basta seguir os passos:
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

# To Do
O projeto propões a adaptação para séries temporais representadas por 3 dimensões. Para isso é necessário adaptar o modo como o algoritmo calcula a similaridade. 

# Referências
[1] Dynamic Time Warping. https://en.wikipedia.org/wiki/Dynamic_time_warping.
[2] Eduardo T. Bogue, Edson T. Matsubara, Anderson C. Bessa. Uma Abordagem em Reconhecimento de Movimentos Utilizando TRKNN e Dynamic Time Warping. ENIA 2012.
[3] Mohammad Shokoohi-Yekta, Jun Wang and Eamonn Keogh. On the Non-Trivial Generalization of Dynamic Time Warping to the Multi-Dimensional Case. SDM 2015.
[4] DTW-KNN. https://github.com/markdregan/K-Nearest-Neighbors-with-Dynamic-Time-Warping
[5] Speeding up python numpy cython http://technicaldiscovery.blogspot.com.br/2011/06/speeding-up-python-numpy-cython-and.html
