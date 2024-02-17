FROM python:3.11.6-alpine3.18
LABEL mantainer="enricofermi2019@gmail.com"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Copia os arquivos necessários para o container
COPY ./djangoapp /djangoapp
COPY ./scripts /scripts

WORKDIR /djangoapp

EXPOSE 8000

# Instala as dependências do projeto
RUN apk add --no-cache postgresql-dev gcc musl-dev && \
    python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /djangoapp/requirements.txt && \
    adduser --disabled-password --no-create-home duser

# Ajusta as permissões dos scripts
RUN chmod +x /scripts/*.sh

ENV PATH="/scripts:/venv/bin:$PATH"

USER duser

# Usa o entrypoint.sh como o ponto de entrada
ENTRYPOINT ["/scripts/entrypoint.sh"]

