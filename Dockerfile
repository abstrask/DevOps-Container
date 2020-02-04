# ========================================
# CREATE UPDATED BASE IMAGE
# ========================================

# FROM debian:stretch-slim AS base
FROM mcr.microsoft.com/powershell:debian-stretch-slim AS base

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# ========================================
# GENERAL PREREQUISITES
# ========================================

FROM base

RUN apt-get update \
    && apt-get install -y bash-completion bc coreutils curl curl gawk git grep htop jq nano openssh-client sed ssh sudo unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Adding  GitHub public SSH key to known hosts
RUN ssh -T -o "StrictHostKeyChecking no" -o "PubkeyAuthentication no" git@github.com || true


# ========================================
# PYTHON
# ========================================

RUN apt-get update \
    && apt-get install -y python python-pip python3 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# ========================================
# AWS CLI
# ========================================

ENV AWSCLI_VERSION=1.17.9

RUN python3 -m pip install --upgrade pip \
    && pip3 install pipenv awscli==${AWSCLI_VERSION} \
    && echo "complete -C '$(which aws_completer)' aws" >> ~/.bashrc


# ========================================
# AWS IAM AUTHENTICATOR
# ========================================

ENV AWSIAMAUTH_VERSION=1.14.6/2019-08-22

RUN curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/${AWSIAMAUTH_VERSION}/bin/linux/amd64/aws-iam-authenticator -o aws-iam-authenticator \
    && chmod +x aws-iam-authenticator \
    && mv aws-iam-authenticator /usr/local/bin/


# ========================================
# SAML2AWS
# ========================================

ENV SAML2AWS_VERSION=2.22.1

RUN curl -L "https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VERSION}/saml2aws_${SAML2AWS_VERSION}_linux_amd64.tar.gz" -o saml2aws.tar.gz \
    && tar -zxvf saml2aws.tar.gz \
    && rm saml2aws.tar.gz \
    && mv saml2aws /usr/local/bin/


# ========================================
# TERRAFORM
# ========================================

ENV TERRAFORM_VERSION=0.12.20

RUN curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && rm terraform.zip \
    && mv terraform /usr/local/bin/ \
    && terraform -install-autocomplete


# ========================================
# TERRAGRUNT
# ========================================

ENV TERRAGRUNT_VERSION=0.21.11

RUN curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o terragrunt \
    && chmod +x terragrunt \
    && mv terragrunt /usr/local/bin/


# ========================================
# KUBECTL
# ========================================

ENV KUBECTL_VERSION=1.17.0

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/


# ========================================
# K9S
# ========================================

ENV K9S_VERSION=0.13.7

RUN curl -L https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_${K9S_VERSION}_Linux_x86_64.tar.gz -o k9s.tar.gz \
    && tar -xzf k9s.tar.gz \
    && rm k9s.tar.gz \
    && chmod +x k9s \
    && mv k9s /usr/local/bin/


# ========================================
# HELM
# ========================================

ENV HELM_VERSION=3.0.3

RUN curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz \
    && tar -xzf helm.tar.gz \
    && rm helm.tar.gz \
    && chmod +x linux-amd64/helm \
    && mv linux-amd64/helm /usr/local/bin/ \
    && rm -rf linux-amd64


# ========================================
# FLUXCTL
# ========================================

ENV FLUXCTL_VERSION=1.17.1

RUN curl -L https://github.com/fluxcd/flux/releases/download/${FLUXCTL_VERSION}/fluxctl_linux_amd64 -o fluxctl \
    && chmod +x fluxctl \
    && mv fluxctl /usr/local/bin/


# ========================================
# WRAP-UP
# ========================================

RUN \
    #echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc && \
    echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \[\033[00m\]# "' >> ~/.bashrc && \
    echo "alias la='ls -A'" >> ~/.bashrc && \
    echo "alias ls='ls --color=auto'" >> ~/.bashrc && \
    #echo "alias l='ls -CF'" >> ~/.bashrc && \
    #echo "alias ll='ls -alF'" >> ~/.bashrc && \
    echo "alias k=kubectl" >> ~/.bashrc
#echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc


RUN mkdir ~/code


# ========================================
# END
# ========================================

WORKDIR /root/code

ENTRYPOINT [ "/bin/bash" ]