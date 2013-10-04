include 'docker'

docker::image { 'benschw/lamp-test02':
	tag => 'latest'
}



docker::run { 'lamp-test-2':
	image   => 'benschw/lamp-test02',
	command => ''
}

