FROM sdal/mro-ldap-ssh-c7

LABEL maintainer="Aaron D. Schroeder" \
      contributors="Daniel Chen <chend@vt.edu>"

# WORKDIR /home/root

# Add RStudio binaries to PATH
# export PATH="/usr/lib/rstudio-server/bin/:$PATH"
# ENV PATH /usr/lib/rstudio-server/bin/:$PATH
# ENV LANG en_US.UTF-8

RUN groupadd shiny \
	&& useradd -g shiny shiny \
	&& echo shiny | passwd shiny --stdin

RUN su - -c "R -e \"install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')\""

RUN wget -O shiny-server.rpm https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.5.4.869-rh5-x86_64.rpm \
    && yum -y install --nogpgcheck shiny-server.rpm

RUN systemctl enable shiny-server

RUN mkdir -p /var/log/shiny-server \
	&& chown shiny:shiny /var/log/shiny-server \
	&& chown shiny:shiny -R /srv/shiny-server \
	&& chmod 755 -R /srv/shiny-server \
	&& chown shiny:shiny -R /opt/shiny-server/samples/sample-apps \
	&& chmod 755 -R /opt/shiny-server/samples/sample-apps

# Get the Rprofile.site file
# RUN wget -O /usr/lib64/R/etc/Rprofile.site https://raw.githubusercontent.com/bi-sdal/mro-ldap-ssh-c7/master/Rprofile.site

EXPOSE 3838

CMD ["/lib/systemd/systemd"]
