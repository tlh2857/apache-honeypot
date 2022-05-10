FROM httpd:2.4.49-alpine
RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli \
    && rm -rf /var/cache/apk/*
    

RUN aws --version
RUN apk add nmap 
COPY ./vulnerable-httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./nc /bin/nc
COPY ./mv /usr/bin/mv
RUN chmod u+s /bin/nc
RUN chmod u+s /usr/bin/mv
