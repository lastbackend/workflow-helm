FROM alpine:3.17

ENV BASE_URL="https://get.helm.sh"
ENV HELM_3_FILE="helm-v3.12.0-linux-amd64.tar.gz"
ENV SOPS_VERSION 3.7.3

RUN apk add --no-cache ca-certificates \
    jq curl bash nodejs aws-cli git gpg gpg-agent go make

RUN curl -L ${BASE_URL}/${HELM_3_FILE} | tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64

# Download the release; untar it; make it
RUN wget  https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux.amd64 -O /bin/sops 
RUN chmod +x /bin/sops 

# install helm secrets plugin
RUN /usr/bin/helm plugin install https://github.com/jkroepke/helm-secrets
ENV PYTHONPATH "/usr/lib/python3.8/site-packages/"

COPY . /usr/src/
ENTRYPOINT ["node", "/usr/src/index.js"]
