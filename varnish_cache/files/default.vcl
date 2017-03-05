# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and https://www.varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

# Default backend definition. Set this to point to your content server.
backend default {
    .host = "192.168.0.3";
    .port = "80";
}

# acl defines a list of IP addresses that are allowed to do something.
acl purgers {
  "127.0.0.1";
  "192.168.0.0"/24;
}

# Happens at the start of a request, before we check if we have this in cache already.
# Typically you clean up the request here, removing cookies you don't need,
# rewriting the request, etc.
sub vcl_recv {
    # Do not cache these...
    #if (req.url ~ ".js$") {
    #    return (pass);
    #}

    # Normalize Accept-Encoding header since we use Vary on it by default.
    if (req.http.Accept-Encoding ~ "gzip") {
        set req.http.Accept-Encoding = "gzip";
    }
    else {
        unset req.http.Accept-Encoding;
    }

    # Handle PURGE requests to invalidate an object in the cache.
    # Only clients within the allowed IP ranges can purge.
    # Use Postman to send this type of request with the URL of the resource to purge.
    if (req.method == "PURGE") {
        if (client.ip ~ purgers) {
          return(purge);
        }
        else {
            return(synth(405));
        }
    }
}

# Happens after we have read the response headers from the backend.
# Here you clean the response headers, removing silly Set-Cookie headers
# and other mistakes your backend does.
sub vcl_backend_response {
    # Just for demonstration purposes, .js files have a different time-to-live
    # than all other types of files.
    if (bereq.url ~ "\.js$") {
        set beresp.ttl = 30s;
    }
    else {
        set beresp.ttl = 356d;
    }
}

# Happens when we have all the pieces we need, and are about to send the
# response to the client. You can do accounting or modifying the final object here.
sub vcl_deliver {
    # Send back a response header that indicates whether there was 
    # a cache hit or miss.
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
    } 
    else {
        set resp.http.X-Cache = "MISS";
    }

    # Do not cache in the browser so we can focus on experimenting with Varnish.
    set resp.http.Cache-Control = "no-store";
}

# When return(purge) is called, this subroutine is then called.
sub vcl_purge {
    # Return a 200 response for PURGE requests instead of sending them to
    # the origin server.
    return(synth(200, "Purged"));
}
