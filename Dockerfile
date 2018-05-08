FROM java:openjdk-8-jdk

MAINTAINER manhduongvtt@gmail.com

VOLUME ["/var/lib/android"]

# Installs i386 architecture required for running 32 bit Android tools
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean
   
# Installs Android SDK
ENV ANDROID_SDK_FILENAME android-sdk_r24.4.1-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVELS android-23,android-24,android-25,android-26,android-27  
ENV ANDROID_HOME /opt/android-sdk-linux
#ENV ANDROID_HOME /home/likewise-open/FRAMGIA/nguyen.viet.manh/Android/Sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN cd /opt && \
    wget -q ${ANDROID_SDK_URL} && \
    tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME}

#RUN cd /home/likewise-open/FRAMGIA/nguyen.viet.manh/Android && \
#    wget -q ${ANDROID_SDK_URL} && \
#    tar -xzf ${ANDROID_SDK_FILENAME} && \
#    rm ${ANDROID_SDK_FILENAME}

# Update Android SDK
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter tools && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter platform-tools && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter extra-android-support && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter extra-android-m2repository && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter extra-google-google_play_services && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter extra-google-m2repository 

RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter ${ANDROID_API_LEVELS} && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-23.0.3 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-23.0.2 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-23.0.1 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-23.0.0 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-24.0.1 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-24.0.2 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-24.0.3 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-25.0.0 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-25.0.1 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-25.0.2 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-25.0.3 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-26.0.0 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-26.0.1 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-26.0.2 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-26.0.3 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-27.0.0 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-27.0.1 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-27.0.2 && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a --filter build-tools-27.0.3

# Update Android licenses
COPY licenses /opt/android-sdk-linux/licenses
#COPY /home/likewise-open/FRAMGIA/nguyen.viet.manh/Android/Sdk/licenses

# Install Framgia CLI
RUN curl -o /usr/bin/framgia-ci https://raw.githubusercontent.com/framgia/ci-report-tool/master/dist/framgia-ci && \
    chmod +x /usr/bin/framgia-ci

# Install Gradle
ENV GRADLE_VERSION 4.1

RUN cd /usr/bin && \
    wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip && \
    unzip gradle-${GRADLE_VERSION}-all.zip && \
    ln -s gradle-${GRADLE_VERSION} gradle && \
    rm gradle-${GRADLE_VERSION}-all.zip

ENV GRADLE_HOME /usr/bin/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

# Cleaning
RUN apt-get clean