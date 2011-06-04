local_incoming_stream = input.http("http://localhost:8000/link-incoming.ogg")

<% if has_variable?("link_incoming_mode") and link_incoming_mode == "pull" and has_variable?("link_incoming_host") and has_variable?("link_incoming_port") %>
remote_incoming_stream = input.http("http://<%= link_incoming_host %>:<%= link_incoming_port %>/link-outgoing.ogg")
incoming_streams = fallback(track_sensitive = false, [local_incoming_stream, remote_incoming_stream])
<% else %>
incoming_streams = local_incoming_stream
<% end %>

output.alsa(device="<%= alsa_device %>",fallback(track_sensitive = false, [incoming_streams, blank()]))
