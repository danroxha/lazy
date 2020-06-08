# Lazy

O script geral um repositório e o preenche com ***commits*** entre datas passadas por argumento

## Porquê?

Mais um dia se passava e eu estava ouvindo alguns podcast BR de desenvolvimento, e um teve um episodio que falava sobre como os blocos "verde" no perfil de usuários do github estava sendo usado como um certificação que o desenvolvedor produz algo (não estava parado fazendo nada), um dos integrantes do podcast informou que esse meio de filtro de contratação é meio furada e deu a ideia que podia ser feito um script que preenchesse o quadro verdinho do perfil do github.

    -- Eu fazendo "nada", pensei (...), 
    -- UHHHUMMMMMMMM!, porquê não?

E assim surgiu esse script, meio incompleto que gera um falso trabalho entre um periodo determinado pelo usuário.


## Modo de uso

Só funciona em um interpretador shell script

#### Dependências
*   ***git***: é um sistema de controle de versão distribuído de código
*   ***date*** : comando de data
*   ***touch***: comando para criação de arquivos

Acho que é normal o ***date*** e ***touch*** já vi pré instalado em distro linux, mas fica a observação

#### Obtendo o repositório

Clonando o repositório
```sh
git clone git@github.com:dannRocha/lazy.git
```

Ou você pode copia a raw do script, baixar compactado, você escolhe o meio de obter o script

#### Gerando repositório "falso"

Antes de iniciar o script dê permissões de execução
```sh
chmod +x lazy.sh
```
Agora vamos criar nosso repositório. Na pasta do script chame o com os seguintes paramentros

```sh
./lazy.sh "date from" "date to" "repository name"
```
Exemplo:
```sh
/lazy.sh "09 jun 2019" "07 jun 2020" "lazy-work"   
```
Observe que a datas tem o seguinte padrão "**day** **mouth** **year**", são datas válidas esse padrão. O dia tem que ser um numero e um dia existente, o mês tem que ser passado por extenso ou com abreviação em inglês, e o ano pode ser passado com apenas os dois ultimos digitos ou completo.

Caso seja passado uma data errada, o script não funcionará corretamente, pois não possui um verificador de parametros

Se você for muito doido, pode colocar o script em ```/usr/bin``` e deixar global no sistema.

## Conclusão

Agora finalize e suba o esse projeto do github e veja um milagre acontecer.
    
    -- "kkkkkkkkkkkkkkkkkkkk"


Esse mini projeto me deu uma oportunidade de aprender mais sobre o git, comandos do linux e também das maravilhas que o shell script pode fazer sem muita complicação.
