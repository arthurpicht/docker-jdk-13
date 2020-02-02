FROM arthurpicht/debian-10:latest

ENV DOCKER_NAME="jdk-13"
ENV JAVA_HOME /man/java
ENV PATH $JAVA_HOME/bin:$PATH

# see https://github.com/docker-library/docs/tree/master/openjdk

# TEMP: cache file locally, dev-time only
# COPY openjdk.tar.gz .

RUN set -eux; \
	export OPENJDK_URL="https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz"; \
	export OPENJDK_FILE=openjdk.tar.gz; \
	export OPENJDK_SHA256_URL="https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz.sha256"; \
	export OPENJDK_SHA256_FILE=openjdk.tar.gz.sha256; \
	wget -O "$OPENJDK_FILE" "$OPENJDK_URL"; \	
	wget -O "$OPENJDK_SHA256_FILE" "$OPENJDK_SHA256_URL"; \
	HASH=$(cat $OPENJDK_SHA256_FILE); \
	HASH="$HASH $OPENJDK_FILE"; \
	echo $HASH | sha256sum -c; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract \
		--file "$OPENJDK_FILE" \
		--directory "$JAVA_HOME" \
		--strip-components 1 \
		--no-same-owner \
	; \
	rm "$OPENJDK_FILE"; \
	echo "$OPENJDK_URL" >> /.components; \
	javac --version; \
	java --version; 
