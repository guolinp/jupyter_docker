FROM panguolin/ubuntu

MAINTAINER "Pan Guolin"

RUN mkdir -p /notebooks

RUN apt-get clean && apt-get upgrade -y && apt-get update -y --fix-missing

RUN apt-get -y install \
        pandoc \
        texlive-xetex

# slim down image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

RUN pip3 --no-cache-dir install \
        numpy \
        pandas \
        scipy \
        sklearn \
        matplotlib \
        graphviz \
        ipython \
        ipykernel \
        ipywidgets \
        ipyparallel \
        jupyter \
        nbconvert \
        pyzmq \
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
