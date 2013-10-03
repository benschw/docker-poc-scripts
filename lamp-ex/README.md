
	sudo docker build -t benschw/lamp-test .


	sudo docker run -d -p 8080:80 -t benschw/lamp-test