# Select base-image
FROM rocker/r-apt:bionic

# Get info of updated packages from Internet
RUN apt-get update
 
# Install R packages that are required for app
RUN apt-get install -y -qq r-cran-shiny r-cran-reticulate

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda install anaconda tensorflow==1.14
RUN conda install keras opencv
RUN conda install -c powerai imageai


# Make a new directory for storing your R Shiny app. Call it "app”
RUN mkdir /app
RUN mkdir -p /app/www

# Copy code of R Shiny app in new directory “app”
COPY app.R /app/
COPY idenprof_060-0.811492.h5 /app/
COPY idenprof_model_class.json /app/
COPY predicting.py /app/

WORKDIR /app/www

COPY www/Capture.PNG /www/

# Select port for viewing app
EXPOSE 15015

# Set working directory for app
WORKDIR /app

# Run R Shiny app
CMD ["Rscript", "/app/app.R"]
