FROM ubuntu:14.04

# Initial deps
RUN apt update -y
RUN apt install -y git build-essential diffstat gawk chrpath texinfo wget libtool gcc-multilib python2.7 
RUN ln -s /usr/bin/python2.7 /usr/bin/python

# Fetch the IE BSP
RUN wget https://downloadmirror.intel.com/25028/eng/edison-src-ww25.5-15.tgz
RUN tar -zxvf edison-src-ww25.5-15.tgz
RUN rm edison-src-ww25.5-15.tgz

# Init the build environment for building the Edison Device Software
RUN cd edison-src && \
    mkdir bitbake_download_dir \
        bitbake_sstate_dir && \
    ./meta-intel-edison/setup.sh \
        --dl_dir=`pwd`/bitbake_download_dir \
        --sstate_dir=`pwd`/bitbake_sstate_dir

# Build the Edison Image
RUN cd edison-src/out/linux64 && \
    sed -i 's/^INHERIT/#&/' ./poky/meta/conf/sanity.conf && \
    source poky/oe-init-build-env && \
    bitbake edison-image