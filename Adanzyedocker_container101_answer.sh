1: Öncelikle sistemdeki tüm container, image ve volumeleri görelim. 
Bunun için ayrı ayrı listeleme komutlarını girelim. Ve ardından temizlik 
yapmak adına makinenizdeki tüm containerları, imageleri ve volumeleri temizleyelim.
Bunun iki yöntemi var. Bakalım siz kolay olanı mı seçeceksiniz. 

docker container ls
docker container ls -a
docker container ps 
docker container ps -a
docker volume list
docker volume ls 
docker image ls 
docker volume list 
docker image rm ...
docker image prune 
docker image prune -a 
docker volume rm 

2: centos, alpine, nginx, httpd:alpine, ozgurozturknet/adanzyedocker, 
ozgurozturknet/hello-app, ozgurozturknet/app1 isimli imajları çalıştığımız
sisteme çekelim. 

docker pull centos
docker pull alpine 
docker pull nginx
docker pull httpd:alpine
docker pull ozgurozturknet/adanzyedocker
docker pull ozgurozturknet/hello-app
docker pull ozgurozturknet/app1
docker image ls 

3: ozgurozturknet/app1 isimli imajdan bir container yaratalım.

docker container run ozgurozturknet/app1 

4: httpd:alpine isimli imajdan detached bir container yaratalım. 
Yarattığımız container ismini ve id’sini görelim. 

docker container run -d httpd:alpine
docker container ps

5: Yarattığımız bu contaier’ın loglarına bakalım.

docker container logs ...

6: Container’ı durduralım, ardından yeniden çalıştıralım ve 
son olarak container’ı sistemden kaldıralım. 

docker container stop ...
docker container start ...
docker container rm -f ... (calismaya devam ettigi icin -f yi kullaniyoruz veya
ilk once stop ederiz sonra tekrar calistiririz)

7: ozgurozturknet/adanzyedocker isimli imajdan websunucu adında detached ve 
“-p 80:80” ile portu publish edilmiş bir container yaratalım. 
Kendi bilgisayarımızın browserından bu web sitesine erişelim.

docker container run -d -p 80:80 --name websunu ozgurozturknet/adanzyedocker
127.0.0.1 ip si ile de browserdan gorebiliriz

8: websunucu adlı bu container’ın içerisine bağlanalım. 
/usr/local/apache2/htdocs klasörünün altına geçelim ve 
echo “denemedir” >> index.html komutuyla buradaki dosyaya 
denemedir yazısını ekleyelim. Web tarayıcıya geçerek dosyaya 
ekleme yapabildiğimizi görmek için refresh edelim. Sonrasında 
container içerisinden exit ile çıkalım.

docker ps 
docker container exec -it ... sh
cd /usr/local/apache2/htdocs
ls 
echo “denemedir” >> index.html
exit 

9: websunucu isimli container’ı çalışırken silelim.

docker container rm -f ...

10: alpine isimli imajdan bir container yaratalım. Ama varsayılan 
olarak çalışması gereken uygulama yerine “ls” uygulamasının çalışmasını sağlayalım.

docker container run alpine ls 

11: “alistirma1” isimli bir volüme yaratalım. 

docker volume create alistirma1
docker volume ls 

12: alpine isimli imajdan “birinci” isimli bir container yaratalım.
Bu container’ı interactive modda yaratalım ve bağlanabilelim. 
Aynı zamanda “alistirma1” isimli volume’u bu containerın “/test” isimli 
folder’ına mount edelim. Bu folder içerisine geçelim ve “touch abc.txt” 
komutuyla bir dosya yaratalım daha sonra “echo deneme >> abc.txt” komutuyla 
bu dosyanın içerisine yazı ekleyelim. 

docker container run --name birinci -it -v alistirma1:/test alpine
ls
cd test
touch abc.txt
echo "denemedir ben ekledim birinci containerdan"
cat abc.txt 

13: alpine isimli imajdan “ikinci” isimli bir container yaratalım. 
Bu container’ı interactive modda yaratalım ve bağlanabilelim. 
Aynı zamanda “alistirma1” isimli volume’u bu containerın “/test” 
isimli folder’ına mount edelim. Bu folder içerisinde “ls” komutyla 
dosyaları listeleyelim ve abc.txt dosyası olduğunu görelim. “cat abc.txt” 
ile dosyanın içeriğini kontrol edelim. 

docker container run --name ikinci -it -v alistirma1:/test alpine
cd test
ls
cat abc.txt

14: alpine isimli imajdan “ucuncu” isimli bir container yaratalım. 
Bu container’ı interactive modda yaratalım ve bağlanabilelim. Aynı
zamanda “alistirma1” isimli volume’u bu containerın “/test” isimli
folder’ına mount edelim fakat Read Only olarak mount edelim. Bu folder 
içerisine geçelim ve “touch abc1.txt” komutuyla bir dosya yaratmaya çalışalım. 
Ve yaratamadığımızı görelim.

docker container run -it --name ucuncu alistirma1:/test:ro alpine
cd test
ls
touch deneme.txt 

15: Bilgisayarımızda bir klasör yaratalım “örneğin c:\deneme” ve 
bu klasörün içerisinde index.html adlı bir dosya yaratıp bu dosyanın 
içerisine birkaç yazı ekleyelim.



16: ozgurozturknet/adanzyedocker isimli imajdan websunucu1 adında detached ve 
“-p 80:80” ile portu publish edilmiş bir container yaratalım. 
Bilgisayarımızda yarattığımız klasörü container’ın içerisindeki 
/usr/local/apache2/htdocs klasörüne mount edelim. Web browser açarak 
127.0.0.1’e gidelim ve sitemizi görelim. Daha sonra bilgisayarımızda 
yarattığımız klasörün içerisindeki index.html dosyasını edit edelim ve 
yeni yazılar ekleyelim. Web sayfasını refresh ederek bunların geldiğini görelim.

docker container run -d -p 80:80 --name websunucu1 -v c:/deneme:/usr/local/apache2/htdocs ozgurozturknet/adanzyedockerdocker ps 
browserdan degisiklikleri gorebiliriz

17: Tüm çalışan container’ları silelim. 

docker container prune 
docker container rm -f ...