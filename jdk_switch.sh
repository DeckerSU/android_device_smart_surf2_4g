#!/bin/bash
case $1 in
    java8)
 export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre/bin/java
 ;;
    jdk7)
 export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
 ;;
    jdk8)
 export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
 ;;
    *)
 export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
 ;;
esac

export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib

java -version