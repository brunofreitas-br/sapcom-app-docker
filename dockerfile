# Use a imagem base Mariner
FROM mcr.microsoft.com/cbl-mariner/base/python:3

# Instalar pip e outras ferramentas necessárias
RUN tdnf install -y python3-pip

# Copiar os arquivos necessários do diretório de trabalho
COPY ./sapcon-app /sapcon-app

# Ajustar permissões
RUN chmod -R 755 /sapcon-app

# Instalar dependências do Python a partir do arquivo requirements.txt
RUN if [ -f /sapcon-app/requirements.txt ]; then pip3 install --no-cache-dir --force-reinstall -r /sapcon-app/requirements.txt; else echo "requirements.txt não encontrado."; fi

# Remover qualquer versão existente de setuptools e instalar a versão corrigida
RUN pip3 uninstall -y setuptools && \
    pip3 install --no-cache-dir setuptools==65.5.1

# Remover o PIP para reduzir a superficie de ataque
RUN pip3 uninstall -y pip

# Definir o diretório de trabalho
WORKDIR /sapcon-app

# Definir o ponto de entrada
ENTRYPOINT ["python3", "/sapcon-app/sapcon/dist/startup_acr.pyc"]

# Adicionar rótulos, se necessário
LABEL com.visualstudio.msazure.image.build.repository.name="ASI-Sentinel4SAP"
LABEL com.visualstudio.msazure.image.release.definitionname="ASI-Sentinel4SAP-Release-Master"
LABEL com.visualstudio.msazure.image.release.releaseid="13240584"
LABEL com.visualstudio.msazure.image.release.releaseweburl="https://msazure.visualstudio.com/b32aa71e-8ed2-41b2-9d77-5bc261222004/_release?releaseId=13240584&_a=release-summary"
LABEL com.visualstudio.msazure.image.system.teamfoundationcollectionuri="https://msazure.visualstudio.com/"
LABEL com.visualstudio.msazure.image.system.teamproject="One"
LABEL image.base.digest="sha256:2677b3abc4f05868da9687235aa23ba42ba45ccf3be0960fdbd000276d01b392"
LABEL image.base.ref.name="mcr.microsoft.com/cbl-mariner/base/python:3"

