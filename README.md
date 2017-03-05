# Project for practicing with Varnish Cache

A project for trying things out with Varnish. To set up:

1. Call `vagrant up` to create the web server and cache. If there's an error
   using `apt`, restart the VM with `vagrant reload [VM name]`. It's a problem with the Vagrant box.
2. To reload changes to the Varnish files or website files, call `vagrant provision [VM name]`.

Examples:

* Update the web server's files:
```
~$ vagrant provision web
```

* Update the cache:
```
~$ vagrant provision cache
```

You can add website files (HTML, CSS, JS, images, etc.) to *webserver/files/html* and then call `provision` on the *web* 
virtual machine to copy the files that server's NGINX folder. 

There are lots of free website templates (unzip, copy to the folder, provision)
can be found at http://www.free-css.com/free-css-templates.