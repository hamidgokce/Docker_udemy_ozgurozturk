1: İlk olarak sistemde bir temizlik yapalım ki alıştırmalarımızla çakışma olmasın. 
Varsa sistemdeki tüm containerları silelim. 

docker ps
docker rm -f ...
docker container prune

2: Docker logout ve docker login komutlarını kullanarak hesabımızdan logout olup tekrar login olalım. 

docker logout
docker login 

3: Önceden oluşturduğunuz ve saklamanız gereken imajlar var ise bunları docker huba gönderin 
ve ardından sistemdeki tüm imajları silin

docker image ls
docker image tag ozgurozturknet/merhaba:latest aytitechegitim/merhaba:latest
docker push aytitechegitim/merhaba:latest
docker image prune -a
docker image ls

4: Docker hubda kendi hesabınız altinda "alistirma" adıyla public bir repository yaratın. 

5: Centos imajının latest ve 7, ubuntu imajının latest, 18.04 ve 20.04, alpine imajının latest, 
nginx imajının latest ve alpine tagli imajlarını sisteme çekin. 

docker pull centos:latest
docker pull centos:7
docker pull ubuntu:latest
docker pull ubuntu:18.04
docker pull ubuntu:20.04
docker pull alpine:latest
docker pull nginx:latest
docker pull nginx:alpine

6: ubuntu:18.04 imajına dockerhubkullaniciadiniz/alistirma:ubuntu olarak tag ekleyin ve ardından bu yeni imajı 
docker huba gönderin. Alistirma repositoryinizden imajı check edin. 

docker image tag ubuntu:18.04 hamidgokce/alistirma:ubuntu
docker image push hamidgokce/alistirma:ubuntu

7:Bu alistirma.txt dosyasının olduğu klasörde bir Dockerfile oluşturun: 
- Base imaj olarak nginx:latest imajını kullanın
- İmaja LABEL="kendi adınız ve erişim bilgileriniz" şeklinde label ekleyiniz. 
- KULLANICI adında bir enviroment variable tanımlayın ve değer olarak adınızı atayın
- RENK adından bir build ARG tanımlayın
- Sistemi update edin ve ardından curl, htop ve wget uygulamalarını kurun
- /gecici klasörüne geçin ve https://wordpress.org/latest.tar.gz dosyasını buraya ekleyin
- /usr/share/nginx/html klasörüne geçin ve html/${RENK}/ klasörünün içeriğini buraya kopyalayın
- Healtcheck talimatı girelim. curl ile localhostu kontrol etsin. Başlangıç periodu 5 saniye, deneme aralığı 30s ve
zaman aşımı süresi de 30 saniye olsun. Deneme sayısı 3 olsun. 
- Bu imajdan bir container yaratıldığı zaman ./script.sh dosyasının çalışmasını sağlayan talimatı exec formunda girin. 

8: Bu Dockerfile dosyasından 2 imaj yaratın. Birinci imajda build ARG olarak RENK:kirmizi ikinci imajda da
build ARG olarak RENK:sari kullanın. Kirmizi olan imajın tagi dockerhubkullaniciadiniz/alistirma:kirmizi 
Sari olan imajin tagi dockerhubkullaniciadiniz/alistirma:sari olsun. 

docker image build -t hamidgokce/alistirma:kirmizi --build-arg RENK=kirmizi .
docker image build -t hamidgokce/alistirma:sari --build-arg RENK=sari .
docker image ls 

9: dockerhubkullaniciadiniz/alistirma:kirmizi imajını kullanarak bir container yaratın. Detach olsun.
Makinenin 80 portuna gelen istekler bu containerın 80 portuna gitsin. Container adi kirmizi olsun.
Browserdan http://127.0.0.1 sayfasına gidip check edin.  

docker container run -d -p 80:80 --name kirmizi hamidgokce/alistirma:kirmizi
docker ps 

10: dockerhubkullaniciadiniz/alistirma:sari imajını kullanarak bir container yaratın. Detach olsun.
Makinenin 8080 portuna gelen istekler bu containerın 80 portuna gitsin.
KULLANICI enviroment variable değerini "Deneme" olarak atayın. Container adi sari olsun. 
Browserdan http://127.0.0.1:8080 sayfasına gidip check edin.

docker container run -d -p 8080:80 --name sari --env KULLANICI:"deneme" hamidgokce/alistirma:sari 
docker ps 

11: Containerları kapatıp silelim. 

docker container rm -f kirmizi sari 

12: Bu alistirma.txt dosyasının olduğu klasörde Dockerfile.multi isimli bir Dockerfile oluşturun: 
- Bu multi stage build alıştırması olacak. 
- Birinci stagei  mcr.microsoft.com/java/jdk:8-zulu-alpine imajından oluşturun ve stage adı birinci olsun
- /usr/src/uygulama klasörüne geçin ve source klasörünün içeriğini buraya kopyalayın
- "javac uygulama.java" komutunu çalıştırarak uygulamanızı derleyin
- mcr.microsoft.com/java/jre:8-zulu-alpine imajından ikinci aşamayı başlatın. 
- /uygulama klasörüne geçin ve birinci aşamadıki imajın /usr/src/uygulama klasörünün içeriğini buraya kopyalayın
- Bu imajdan container yaratıldığı zaman "java uygulama" komutunun çalışması için talimat girin

13: Bu Dockerfile.multi dosyasından dockerhubkullaniciadiniz/alistirma:java tagli bir imaj yaratın. 


14: Bu imajdan bir container yaratın ve java uygulamanızın çıkardığı mesajı görün.

docker run hamidgokce/alistirma:java

15: dockerhubkullaniciadiniz/alistirma:kirmizi, dockerhubkullaniciadiniz/alistirma:sari, dockerhubkullaniciadiniz/alistirma:java
imajlarını Docker huba yollayın. 

docker push hamidgokce/alistirma:sari
docker push hamidgokce/alistirma:kirmizi
docker push hamidgokce/alistirma:java

16: Docker hubdaki registry isimli imajdan lokal bir Docker Registry çalıştırın. 

docker run -d -p 5000:5000 --restart always --name registry registry:2
docker ps 

17: dockerhubkullaniciadiniz/alistirma:kirmizi, dockerhubkullaniciadiniz/alistirma:sari, dockerhubkullaniciadiniz/alistirma:java
imajlarını yeniden tagleyerek bu lokal registrye gönderin ve ardından bu registrynin web arayüzünden kontrol edin. 

docker image tag hamidgokce/alistirma:sari 127.0.0.1:5000/sari/latest 
docker image tag hamidgokce/alistirma:kirmizi 127.0.0.1:5000/kirmizi/latest
docker image tag hamidgokce/alistirma:java 127.0.0.1:5000/java/latest

docker push 127.0.0.1:5000/java:latest
docker push 127.0.0.1:5000/sari:latest
docker push 127.0.0.1:5000/kirmizi:latest