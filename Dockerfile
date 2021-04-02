FROM fpco/stack-build:lts-16.0 as dependencies
RUN mkdir /opt/build
WORKDIR /opt/build

RUN apt-get update \
  && apt-get download libgmp10
RUN mv libgmp*.deb libgmp.deb

COPY stack.yaml package.yaml stack.yaml.lock /opt/build/
RUN stack build --system-ghc --dependencies-only

FROM fpco/stack-build:lts-16.0 as build

COPY --from=dependencies /root/.stack /root/.stack
COPY . /opt/build/

WORKDIR /opt/build

RUN stack build --system-ghc

RUN mv "$(stack path --local-install-root --system-ghc)/bin" /opt/build/bin

FROM ubuntu:18.04 as app
RUN mkdir -p /opt/app
WORKDIR /opt/app

COPY --from=dependencies /opt/build/libgmp.deb /tmp
RUN dpkg -i /tmp/libgmp.deb && rm /tmp/libgmp.deb

COPY --from=build /opt/build/bin .
ENV PORT 3000
EXPOSE 3000
CMD ["/opt/app/rickastley-exe"]
