FROM rclone/rclone AS rclone

FROM ubuntu

COPY --from=rclone /usr/local/bin/ /usr/local/bin/
RUN apt-get update && apt-get install -y ca-certificates fuse3 tzdata unzip \
    && echo "user_allow_other" >> /etc/fuse.conf
    
WORKDIR '/app/brec'
COPY brec.zip /app/brec
RUN unzip brec.zip \
    && chmod 777 * \
    && rm brec.zip
WORKDIR '/app'
COPY start.sh /app
RUN chmod +x start.sh
EXPOSE 2356/tcp
ENTRYPOINT ["/bin/bash","./start.sh"]
