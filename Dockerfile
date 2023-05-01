FROM rclone/rclone 

RUN apk add ca-certificates \
	fuse3 \
	tzdata \
	unzip \
	aspnetcore6-runtime \
    bash
    
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