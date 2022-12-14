1: İlk olarak sistemde bir temizlik yapalım ki alıştırmalarımızla çakışma olmasın. 
    Varsa sistemdeki tüm containerları ve kullanıcı tanımlı bridge networkleri silelim.

    docker container ps
    docker container ps -a
    docker container prune
    docker container rm ...
    docker container rm -f ...
    docker network prune 
    docker network ls 
    docker netvork rm ...

2: "alistirma-agi" adında ve 10.10.0.0/16 subnetinde, 10.10.10.0/24 ip-aralığından ip 
dağıtacak ve gateway olarak da 10.10.10.10 tanımlanacak bir kullanıcı tanımlı bridge 
network yaratalım. (bu sizin yerel ağınızda kullandığınız bir ağ aralığıysa başka bir 
cidr kullanabilirsiniz). Bu ağın özelliklerini inspect komutuyla kontrol edin. 

  docker network create --driver=bridge --subnet=10.10.0.0/16 --ip-range=10.10.10.0/24 --gateway=10.10.10.10 alistirma-agi # driver girmesek de default olarak bridge sececekti
  docker network inspect alistirma-agi 

3: nginx imajının 1.16 versiyonundan web1 adından detached bir container yaratın. 
Bu containerı default bridge networküne değil de alistirma-agi networküne bağlı 
olarak yaratın. Hostun 8080 tcp portuna gelen isteklerin bu containerın 80 portuna 
gitmesini sağlayın.

  docker container run -d --name web1 --net alistirma-agi -p 8080:80 nginx:1.16 
  docker ps 

4: Bu sisteme browser üzerinden erişin ve daha sonra bir kaç kez sayfayı refresh edin. 
Ardından bu containerın loglarına erişerek az önceki erişimlerinizin loglarını kontrol edin. 

  browserdan 127.0.0.1:8080 ni acalim 
  docker logs web1 # or id

5: Container loglarını follow modunda takip ederken browserdan bu web sitesinde olmayan 
bir urle gitmeye çalışın. Örneğin xyz.html Bunun ürettiği hatayı canlı olarak loglardan
takip edin. 

  docker ps
  docker logs -f web1 # -f canli gormemizi saglamaktadir
  sayfada yenileme yaptigimizda veya olmayan bir url ye gittigimizde hatayi gorecegiz

6: ozgurozturknet/adanzyedocker imajından test1 adından bir container yaratın. 
-dit ile yaratın sh shellini açın. Bu container default bridge networke bağlı olsun. 

  docker container run -dit --name test1 ozgurozturknet/adanzyedocker sh
  docker ps 

7: Bu containerı "alistirma-agi" networküne de bağlayın.

  docker network connect alistirma-agi test1

8: Containera attach işlemiyle bağlanın ve container içerisinden web1i pinglemeye çalışın. 
Containerı kapamadan çıkın. 

  docker attach test1
  ping web1 # ayni baga baglandigi icin pingleyebilmekteyiz. birbirlerinin DNS olarak isimlerini cozumleyebiliyorlardi
  ctrl + p + q
  docker ps 

9: Bu containerların çalıştığını kontrol edin ve ardından çalışıyor haldeyken bunları silin. 

  docker container rm -f  test1 web1
  docker ps

10: Terminalde eğitim klasörünün altındaki kisim4/bolum43 klasörüne geçin.

11: ozgurozturknet/webkayit imajından websrv adinda detached bir container yaratın. 
"alistirma-agi" networküne bağlı olsun. Maksimum 2 logical cpu kullanacak şekilde kısıtlansın. 
80 portunu host üstündeki 80 portuyla publish edin. env.list dosyasının bu containera
 enviroment variable olarak aktarılmasını sağlayın. 

  docker container run -d --name websrv --net alistirma-agi -p 80:80 --cpus="2" --env-file ./env.list ozgurozturknet/webkayit

12: ozgurozturknet/webdb imajından mysqldb adinda detached bir container yaratın.
 "alistirma-agi" networküne bağlı olsun. Maksimum 1gb memory kullanacak şekilde kısıtlansın.
  envmysql.list dosyasının bu containera enviroment variable olarak aktarılmasını sağlayın. 

  docker container run -d --name mysqldb --env-file .\envmysql.list --net alistirma-agi --memory=1g ozgurozturknet/webdb

13: mysqldb containerının loglarını kontrol ederek düzgün şekilde başlatılabildiğini teyit
 edin. 

  docker logs mysqldb
  "mysqld: ready for connections."

14: Browserdan websrv containerının yayınladığı web sitesine bağlanın. 
Karşınıza çıkan formu doldurup bir tane jpg dosyayı da seçerek add tuşuna basın. Ardından kayitlari gör diyerek işlemin başarılı olduğunu teyit edin. 

127.0.0.1 browser a gir bilgileri ve jpg dosyasini ekle

15: Oluşturduğunuz containerları ve alistirma-agini silin.