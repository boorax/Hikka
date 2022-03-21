ENV TZ=Europe/Moscow

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && git clone https://github.com/hikariatama/Hikka.git /root/Hikka/ \
    && pip3 install --no-cache-dir -r root/Hikka/requirements.txt

WORKDIR /root/Hikka/

CMD ["python3", "-m", "hikka", "--root"]