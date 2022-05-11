FROM httpd:2.4.49
RUN apt update -y 
RUN apt install  -y \
        python3 \
        python3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli 
RUN aws --version
RUN apt install -y nmap
COPY ./vulnerable-httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./nc /bin/nc
COPY ./mv /usr/bin/mv
RUN chmod u+s /bin/nc
RUN chmod u+s /usr/bin/mv
RUN chmod +x /usr/bin/mv
RUN apt install -y vim 
RUN apt install -y less
