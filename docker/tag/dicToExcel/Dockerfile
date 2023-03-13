FROM python:3.9-alpine

WORKDIR /script
COPY ./script/dicToExcel.py .

#python dependency
RUN pip --default-timeout=1000 --trusted-host mirrors.aliyun.com install -i http://mirrors.aliyun.com/pypi/simple/ \
    pymysql openpyxl


CMD ["python", "/script/dicToExcel.py"]
