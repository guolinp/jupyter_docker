FROM ubuntu:18.10

MAINTAINER "Pan Guolin"

RUN mkdir -p /notebooks

ENV PYTHONIOENCODING UTF-8
ENV PYTHON_PATH /usr/bin/python3
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get clean && apt-get upgrade -y && apt-get update -y --fix-missing

RUN apt-get -y install \
        git \
        python3 \
        python3-dev \
        curl

# slim down image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
        python3 get-pip.py && \
        rm -rf get-pip.py

RUN pip3 --no-cache-dir install \
        numpy \
        pandas \
        matplotlib \
        ipython \
        ipykernel \
        ipywidgets \
        ipyparallel \
        jupyter \
        && \
    python3 -m ipykernel.kernelspec

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
WORKDIR /notebooks
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--allow-root", "--ip=0.0.0.0", "--notebook-dir=/notebooks"]
