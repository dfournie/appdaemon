FROM python:3.7-alpine

VOLUME /conf
VOLUME /certs
EXPOSE 5050

# Environment vars we can configure against
# But these are optional, so we won't define them now
#ENV HA_URL http://hass:8123
#ENV HA_KEY secret_key
#ENV DASH_URL http://hass:5050
#ENV EXTRA_CMD -D DEBUG

# Copy appdaemon into image
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . .

# Install timezone data
RUN apk add tzdata

# Install dependencies
RUN apk add --no-cache gcc libffi-dev openssl-dev musl-dev \
    && pip install --no-cache-dir .

RUN pip uninstall -y astral
RUN pip install astral==1.10.1

# Install additional packages
RUN apk add --no-cache curl

# Start script
RUN chmod +x /usr/src/app/dockerStart.sh
CMD [ "./dockerStart.sh" ]
