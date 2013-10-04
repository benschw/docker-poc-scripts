
	sudo docker build -t benschw/lamp-test02 .


	sudo puppet apply --modulepath=modules/ docker.pp



#	sudo docker run -d -p 8080:80 -t benschw/lamp-test02

#	sudo docker run -i -t ubuntu /bin/bash