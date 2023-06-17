FROM alpine:3.17

ENV BASE_URL="https://get.helm.sh"

ENV HELM_2_FILE="helm-v2.17.0-linux-amd64.tar.gz"
ENV HELM_3_FILE="helm-v3.12.0-linux-amd64.tar.gz"

RUN apk add --no-cache ca-certificates \
    jq curl bash nodejs aws-cli git && \
    curl -L ${BASE_URL}/${HELM_3_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64

# install helm secrets plugin
RUN /usr/bin/helm plugin install https://github.com/jkroepke/helm-secrets
ENV PYTHONPATH "/usr/lib/python3.8/site-packages/"

COPY . /usr/src/
ENTRYPOINT ["node", "/usr/src/index.js"]
