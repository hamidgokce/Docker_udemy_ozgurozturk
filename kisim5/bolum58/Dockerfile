FROM mcr.microsoft.com/java/jdk:8-zulu-alpine AS derleyici
# image olusturma islemini derleyici isimli bir asamaya ceviriyoruz
COPY /source /usr/src/uygulama
WORKDIR /usr/src/uygulama
RUN javac uygulama.java
# CMD ["java" , "uygulama"]

# buraya kadar source kodumuzu derleyici asamasina kadar getirecek

FROM mcr.microsoft.com/java/jre:8-zulu-alpine 
WORKDIR /uygulama 
# burada derlenen imageyi getirmek istiyoruz
COPY --from=derleyici /usr/src/uygulama .
CMD [ "java" , "uygulama" ]
