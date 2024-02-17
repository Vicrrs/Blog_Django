#!/bin/sh
set -e

echo "Aguardando o banco de dados estar pronto..."
while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
  sleep 1
done

echo "Banco de dados pronto!"

echo "Executando comandos de migração e coleta de arquivos estáticos..."
python manage.py collectstatic --noinput
python manage.py makemigrations --noinput
python manage.py migrate --noinput

echo "Iniciando o servidor Django..."
python manage.py runserver 0.0.0.0:8000
