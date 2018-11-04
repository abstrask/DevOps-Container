FROM alpine:latest

RUN apk add --no-cache bash bash-completion gawk sed grep bc coreutils curl nano git openssh-client py-pip jq

RUN pip install awscli && \
    echo "complete -C '$(which aws_completer)' aws" >> ~/.bashrc

RUN curl -L https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    rm terraform.zip && \
    mv terraform /usr/local/bin/ && \
    echo #/bin/bash -c "terraform -install-autocomplete"

RUN curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.16.8/terragrunt_linux_amd64 -o terragrunt && \
    chmod +x terragrunt && \
    mv terragrunt /usr/local/bi

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.8.4/bin/linux/amd64/kubectl -o kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    echo "source <(kubectl completion bash)" >> ~/.bashrc

# RUN wget -O kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 && \
#     chmod +x ./kops && \
#     mv ./kops /usr/local/bin/ && \
#     echo "source <(kops completion bash)" >> ~/.bashrc

RUN echo "alias update='apk update && apk upgrade'" >> ~/.bashrc && \
    echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc && \
    echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \[\033[00m\]# "' >> ~/.bashrc && \
    echo "alias l='ls -CF'" >> ~/.bashrc && \
    echo "alias la='ls -A'" >> ~/.bashrc && \
    echo "alias ll='ls -alF'" >> ~/.bashrc && \
    echo "alias ls='ls --color=auto'" >> ~/.bashrc && \
    echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc

RUN echo '"\e[1;5C": forward-word   # ctrl + right' >> ~/.inputrc && \
    echo '"\e[1;5D": backward-word  # ctrl + left' >> ~/.inputrc

RUN mkdir ~/code

WORKDIR ~/code

ENTRYPOINT [ "bash" ]
