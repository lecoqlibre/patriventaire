# This image is inspired by the documentation found in
# https://hub.docker.com/_/django.
FROM python:3

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		postgresql-client \
	&& rm -rf /var/lib/apt/lists/*

# Inside the container we work in a dedicated directory.
WORKDIR /usr/src/app

# We copy into the container the list of dependancies 
# to install by pip.
COPY requirements.txt ./

# To use pip it's better to use a virtual environment.
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# We install the Python dependancies in the virtual 
# environment as advised by pip.
RUN pip install --no-cache-dir -r requirements.txt

# We copy the Django application into the container.
COPY ./app .

# We collect the static files for serving.
RUN python manage.py collectstatic --noinput

# We expose the Django internal web server on port 8000
# for development only!
EXPOSE 8000
