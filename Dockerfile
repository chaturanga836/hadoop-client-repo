# Base: lightweight Java image
FROM eclipse-temurin:11-jre-jammy

ENV HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$HADOOP_HOME/bin:$PATH

# Install basic tools
RUN apt-get update && apt-get install -y curl bash tini && rm -rf /var/lib/apt/lists/*

# Download Hadoop binaries
RUN curl -L https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    | tar -xz -C /opt && \
    mv /opt/hadoop-${HADOOP_VERSION} ${HADOOP_HOME}

# Cleanup extra binaries (keep only client libs)
RUN rm -rf ${HADOOP_HOME}/share/doc \
           ${HADOOP_HOME}/share/hadoop/mapreduce \
           ${HADOOP_HOME}/share/hadoop/yarn

# Add config directory
RUN mkdir -p /opt/hadoop/conf

# Copy config files
COPY conf/core-site.xml /opt/hadoop/conf/core-site.xml
COPY conf/hdfs-site.xml /opt/hadoop/conf/hdfs-site.xml

WORKDIR /opt/hadoop

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash"]
