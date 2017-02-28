# Overview

This is a simple cookbook that will change the port used by Microsoft RDP to whatever port you specify.

The default port for RDP is 3389.  That is also the default of this cookbook.  The default behavior will create firewall rules on port 3389 to allow inbound traffic.

Change the port by overriding the `node['rdp']['port']` attribute in the normal Chef ways.  The default recipe includes a line to do this and change the port to 443.  Uncomment this line to change the port to 443.  Uncomment the line and change the value to a different port to use a custom port.

The `node['rdp']['port']` attribute can be overridden in all of the standard Chef ways.

# .kitchen.yml

The default `.kitchen.yml` behavior will map port 443 on the guest system to port 4443 on the host system.
