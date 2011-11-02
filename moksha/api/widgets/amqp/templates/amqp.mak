<%namespace name="tw" module="moksha.utils.mako"/>
<script type="text/javascript">
$(document).ready(function() {

if (typeof moksha_amqp_conn == 'undefined') {
	moksha_callbacks = new Object();
	moksha_amqp_remote_queue = null;
	moksha_amqp_queue = null;
	moksha_amqp_on_message = function(msg) {
		var dest = msg.header.delivery_properties.routing_key;
		var json = null;
		try {
			var json = $.parseJSON(msg.body);
		} catch(err) {
			moksha.error("Unable to decode JSON message body");
			moksha.error(msg);
		}
		if (moksha_callbacks[dest]) {
			for (var i=0; i < moksha_callbacks[dest].length; i++) {
				moksha_callbacks[dest][i](json, msg);
			}
		}
	}

	function raw_msg_callback() {
		var msg = this.fetch();
		msg.header = msg.parsed_data._header;
		msg.body = msg.parsed_data._body;
		moksha_amqp_on_message(msg);
	}
}

## Register our topic callbacks
% for topic in tw._('topics'):
	var topic = "${topic}";
	if (!moksha_callbacks[topic]) {
		moksha_callbacks[topic] = [];
	}
	moksha_callbacks[topic].push(function(json, frame) {
		${tw._('onmessageframe')[topic]}
	});
% endfor

## Create a new AMQP client
if (typeof moksha_amqp_conn == 'undefined') {
	document.domain = document.domain;
	$.getScript("${tw._('orbited_url')}/static/Orbited.js", function() {
		Orbited.settings.port = ${tw._('orbited_port')};
		Orbited.settings.hostname = '${tw._("orbited_host")}';
		Orbited.settings.streaming = true;

		jsio("import qpid_amqp as amqp");
		jsio("from amqp.protocol import register");
		// load the 0.10 version of the protocol
		register("amqp.protocol_0_10");

		moksha_amqp_conn = new amqp.Connection({
			% if tw._("send_hook"):
				send_hook: function(data, frame) { ${tw._("send_hook")} },
			% endif
			% if tw._("receive_hook"):
				recive_hook: function(data, frame) { ${tw._("receive_hook")} },
			% endif
			host: '${tw._("amqp_broker_host")}',
			port: ${tw._("amqp_broker_port")},
			username: '${tw._("amqp_broker_user")}',
			password: '${tw._("amqp_broker_pass")}',
			socket_cls: Orbited.TCPSocket,
		});
		moksha_amqp_conn.start();

		moksha_amqp_session = moksha_amqp_conn.create_session(
			'moksha_socket_' + (new Date().getTime() + Math.random()));

		moksha_amqp_remote_queue = 'moksha_socket_queue_' +
				moksha_amqp_session.name;

		moksha_amqp_session.Queue('declare', {
				queue: moksha_amqp_remote_queue,
				auto_delete: true,
				exclusive: true,
		});

		% if tw._("onconnectedframe"):
			${tw._("onconnectedframe")}
		% endif

		var receiver = moksha_amqp_session.receiver('amq.topic/*')
		receiver.onReady = raw_msg_callback;
		receiver.capacity(0xFFFFFFFF);  // ??

		// Note that $(window).unload(..) is insufficient.  The
		// moksha/orbited resources are unloaded before we can
		// explicitly close our connection.  We must use
		// 'beforeunload' instead.
		$(window).bind('beforeunload', function() {
			moksha_amqp_conn._conn_driver._socket.close();
		});

	});

} else {
	## Utilize the existing Moksha AMQP socket connection
	${tw._("onconnectedframe")}
	var receiver = moksha_amqp_session.receiver('amq.topic/*')
	receiver.onReady = raw_msg_callback;
	receiver.capacity(0xFFFFFFFF);  // ??
}

if (typeof moksha == 'undefined') {
	moksha = {
		/* Send an AMQP message to a given topic */
		send_message: function(topic, body) {
			var sender = moksha_amqp_session.sender('amq.topic/' + topic);
			sender.send(body);
		},
	}
}

});
</script>
