# Project for practicing with Varnish Cache

A project for trying things out with Varnish. To set up:

1. Call `vagrant up` to create the web server and cache. If there's an error
   using `apt`, restart the VM with `vagrant reload [VM name]`. It's a problem with the Vagrant box.
2. To reload changes to the Varnish files or website files, call `vagrant provision [VM name]`.