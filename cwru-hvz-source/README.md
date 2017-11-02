These are instructions for deployment on Ubuntu 16.04

<b>1) Install Apache:</b></br>
and follow standard setup. The link that I've found to be the most useful is this: https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-16-04

<b>2) Install Passenger:</b> </br>

- First, install the PGP key for the repository server:</p>
<code langs="">sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
</code>
<p>Create an APT source file:</p>
<code langs="">sudo nano /etc/apt/sources.list.d/passenger.list
</code>
- Insert the following line to add the Passenger repository to the file:</p>
<code langs="">deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main
</code>
- Press <strong>CTRL+X</strong> to exit, type <strong>Y</strong> to save the file, and then press ENTER to confirm the file location.</p>
- Change the owner and permissions for this file to restrict access to <strong>root</strong>:</p>
<code langs="">sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
</code>
- Update the APT cache:</p>
<code langs="">sudo apt-get update
</code>
- Finally, install Passenger:</p>
<code langs="">sudo apt-get install libapache2-mod-passenger
</code>
- Make sure the Passenger Apache module; it maybe enabled already:</p>
<code langs="">sudo a2enmod passenger
</code>
- Restart Apache:</p>
<code langs="">sudo service apache2 restart
</code>
</br>
<b> 3) Install Ruby using rvm </b></br>
<p> Install RVM

</p></br>
<code>sudo apt-get update </code></br>
<code>sudo apt-get install -y curl gnupg build-essential </code></br>
<code>sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 </code></br>
<code>curl -sSL https://get.rvm.io | sudo bash -s stable </code></br>
<code>sudo usermod -a -G rvm `whoami` </code></br>
<code>rvm install ruby-2.2.0p0 </code></br>
<code>rvm --default use ruby-2.2.0p0 </code></br>
<code>gem install bundler </code></br>

<b> 4) Clone this Repo into your home directory: </b></br>
<code> git clone https://github.com/rohanezio/eecs395HvZ.git </code></br>

<b> 5) Install postgresql: This link is quite helpful </b></br>
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04 </br>

 - Create the users hvz_development, hvz, hvz_prod
 - Instructions are in the link above
 - Change the passwords for all 3 users to password
 <code> sudo -u postgres psql hvz</code></br>
 <code>\password hvz </code> </br>
 <code>\q</code></br>
 - Repear for the other 2 users
 </br>
 <b>7) Change Apache2 Config File </b></br>
 <code>cd /etc/apache2/sites-available</code></br>
 <code> sudo nano 000-default.conf </code></br>
 - Replace with the following code
 <code>
  <VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin rxr353@case.edu
	DocumentRoot /home/INSERT_USERNAME_HERE/eecs395HvZ/cwru-hvz-source
	RailsEnv development

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	<Directory "/home/INSERT_USERNAME_HERE/eecs395HvZ/cwru-hvz-source">
	    Require all granted 
	    Options FollowSymLinks
	</Directory>
	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
</code></br>

- Remember to change INSERT_USERNAME_HERE in the config file
