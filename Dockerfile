FROM python:3.6-slim

COPY . /python-test-calculator
WORKDIR /python-test-calculator

RUN /usr/local/bin/python -m pip install --upgrade pip && pip3 install --no-cache-dir -r requirements.txt
RUN ["pytest", "-v", "--junitxml=reports/result.xml"]

CMD tail -f /dev/null
