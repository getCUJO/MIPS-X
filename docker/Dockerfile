FROM alpine:latest
#NFS part cloned from "https://github.com/sjiveson/nfs-server-alpine"

RUN apk -U upgrade
RUN apk add --no-cache --update --verbose nfs-utils bash iproute2 socat qemu dialog bridge-utils gdb-multiarch openssh util-linux gdb busybox-extras w3m curl build-base py3-pip  && \
    rm -rf /var/cache/apk /tmp /sbin/halt /sbin/poweroff /sbin/reboot && \
    mkdir -p /var/lib/nfs/rpc_pipefs /var/lib/nfs/v4recovery && \
    echo "rpc_pipefs    /var/lib/nfs/rpc_pipefs rpc_pipefs      defaults        0       0" >> /etc/fstab && \
    echo "nfsd  /proc/fs/nfsd   nfsd    defaults        0       0" >> /etc/fstab && \
    wget --no-check-certificate -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

RUN mkdir /tmp
RUN chmod 1777 /tmp

COPY exports /etc/
COPY nfsd.sh /usr/bin/nfsd.sh
COPY .bashrc /root/.bashrc


ENV PATH="/armx/run:/usr/arm-none-eabi:${PATH}"

RUN chmod +x /usr/bin/nfsd.sh
RUN mkdir /root/.ssh
COPY config /root/.ssh/config
COPY id_rsa* /root/.ssh/
RUN chmod 400 /root/.ssh/id_rsa*


ENV SHARED_DIRECTORY=/armx

CMD ["/usr/bin/nfsd.sh"]
ENTRYPOINT ["/bin/bash"]

