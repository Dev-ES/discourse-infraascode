#a saida será impressa no terminal assim que o terraform rodar com sucesso
output "public_ip" {
  # note que fiz referencia no objeto da instancia, consigo fazer referencia em qq objeto na mesma
  # pasta pelo terraform
  value = "${aws_instance.web.public_ip}"
}
