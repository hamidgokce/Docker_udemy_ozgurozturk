FROM python:alpine
COPY . /app 
# konumdaki butun dosyalari imagenin icerisinde app klasorune kopyaliyoruz
WORKDIR /app
RUN pip install -r requirements.txt 
# Flaski yukluyoruz
EXPOSE 5000
# container in disindan container in icerisine ulasilacak port
CMD python ./index.py