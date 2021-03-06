#  This is API docker file that is used to connect
#  the Swagger/Flask API to Gunicorn, via Supervisord.
#  Web3.py is then used to interact with the contracts
#  (written and tested in truffle)

FROM python:3.6

# connexion
RUN mkdir -p /usr/src
COPY oas3.zip /usr/src
WORKDIR /usr/src

RUN  apt-get update -y && \
     apt-get upgrade -y && \
     apt-get install unzip -y 

RUN unzip oas3.zip
RUN mv connexion-oas3 connexion
WORKDIR /usr/src/connexion
RUN pip install -e .

# API
RUN mkdir -p /usr/src/package
COPY ./package /usr/src/package
WORKDIR /usr/src/package
RUN pip install -e .

#Smart Contracts
RUN mkdir /usr/src/contracts
COPY ./build/contracts /usr/src/contracts

# Deployment
RUN apt-get install supervisor -y
RUN pip install gunicorn

# Supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start processes
CMD ["/usr/bin/supervisord"]