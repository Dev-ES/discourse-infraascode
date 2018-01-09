# projeto do-amanha, portal de fórum

## Objetivo do projeto

Liberar um acesso fácil para a comunidade realizar sua dúvida através de um fórum, para que nós
do dev-es possamos sanar dúvidas sobre programação.

Buscamos a solução através do [discourse](https://www.discourse.org/) e colocamos em uma máquina simples EC2 da amazon, onde futuramente iremos distribuir os serviços de forma que escale conforme a demanda da comunidade e recursos que tivermos disponíveis para o projeto.


## Tecnologias envolvidas

As tecnologias envolvidas são:

- [packer](https://www.packer.io/)
- [terraform](https://www.terraform.io/)
- [ansible](https://www.ansible.com/)
- [Docker](https://www.docker.com/)
- [EC2 da amazon](https://aws.amazon.com/pt/comecando-com-ec2/?sc_channel=PS&sc_campaign=acquisition_BR&sc_publisher=google&sc_medium=english_ec2_b&sc_content=ec2_e&sc_detail=aws%20ec2&sc_category=ec2&sc_segment=222480944808&sc_matchtype=e&sc_country=BR&s_kwcid=AL!4422!3!222480944808!e!!g!!aws%20ec2&ef_id=WVdEWAAAAG-ae38L:20180109202657:s)

O packer é responsável por criação de imagens na nuves conforme nossa personalização através de linhas de comando:

- Ao invés de ficarmos colocando comandos na mão um a um depois que pegar uma máquina ubuntu ...

```bash
comando 1
comando 2
comando 3
```

Que tal colocar esses comandos em um programa que executa e grava uma máquina persinalizada na amazon ou onde eu quiser?

- Que tal ao invés de ficar fazendo bash maroto, eu automatizar instalações e procedimentos em "receitas" feitas através do ansible?

```yaml
- name: Adding user ubuntu to group docker
  user: name=ubuntu
        groups=docker
        append=yes
```

- Que tal se ao invés de entrar no console da aws e criar a máquina com a imagem que criei, eu

rodar o terraform e deixar ele criar pra mim?

```bash
terraform apply
```

## Como eu mesmo posso iniciar o projeto e rodar por conta própria '?'

1. Personalize suas opções para rodar o discourse em um arquivo .env:

```plain
SECRET_TOKEN=<chave >

DISCOURSE_HOSTNAME=<host e porta onde será publicado o serviço>
DISCOURSE_SMTP_ADDRESS=<endereço do serviço de smtp>
DISCOURSE_SMTP_PORT=<porta do serviço, utilize a 587 porque algumas opções deles estão "fixadas e não dá pra usar a 465 por questão de falta de opções sobre o tls">
DISCOURSE_SMTP_USER_NAME=<usuário do smtp>
DISCOURSE_SMTP_PASSWORD=<senha do smtp>
DISCOURSE_DEVELOPER_EMAILS=<email dos administradores separado por virgulas>

POSTGRES_PASSWORD=<senha do usuario discourse do banco de dados>
DISCOURSE_DB_PASSWORD=<embora redundante segui a documentação e repeti a linha anterior na resposta>

```

2. Copie o conteúdo dentro da `role` do discord que será incorporado pelo ansible:

```bash
cp .env ./images/playbook/discourse/files/
```

3. Gere a ami na amazon usando packer:

`no diretório ./images/aws/ e com packer instalado`

```bash

 packer build -var-file=variables.json ubuntu-standard.json

```

4. Produza a instancia usando terraform:

`no diretório ./terraform e com terraform instalado (também deve ter cli da AWS instalado corretamente)`

```bash
AWS_PROFILE=<nome-do-profile-configurado-aws-cli> terraform init
AWS_PROFILE=<nome-do-profile-configurado-aws-cli> terraform apply
```

Não automatizamos a associação do ip publico com dns, mas futuramente iremos colocar uma automação de ponta a ponta, que inclui serviços de backup usando AWS lambda.

## Criticas, Dúvidas e Sugestões

Entre em nosso canal de #mentoria no slack, teremos prazer em tirar sua dúvida :D
