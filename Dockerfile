FROM debian:stable-slim

RUN apt-get update && apt-get install smbclient -y && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD []