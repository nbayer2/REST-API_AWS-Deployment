FROM python:3.9-alpine
COPY src src
COPY requirements.txt ./
RUN pip3 install -r requirements.txt
#ENV FLASK_APP app.py
#ENV FLASK_ENV development
#ENV DB_IP 34.159.3.127
#ENV DB_USER pexon-training
#ENV DB_PASSWORD pexon-training2022!
#ENV DB_NAME books
EXPOSE 8080
CMD ["python", "src/app.py"]