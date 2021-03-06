# Building a deployment bundle
FROM gradle:4.10 as builder

COPY . /home/gradle/src
USER root
RUN chown -R gradle:gradle /home/gradle/src
USER ${ENTRYPOINT_UID}

WORKDIR /home/gradle/src
RUN gradle build

FROM caapim/gateway:9.4.00
# Copying the deployment package to the Gateway image
COPY --from=builder /home/gradle/src/deployment/build/gateway/deployment-1.0.0.gw7 /opt/docker/rc.d/deployment.gw7
# Make restman available
RUN touch /opt/SecureSpan/Gateway/node/default/etc/bootstrap/services/restman