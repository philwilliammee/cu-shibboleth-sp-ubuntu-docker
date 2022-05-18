<?php

require_once __DIR__ . '/layout.php';

$script = <<<HTML
<div id='root'></div>
<script>
    $(function() {
        const root = $('#root');
        $.get('/Shibboleth.sso/Session', function(data) {
            console.log(data);
            if (data && data.includes('A valid session was not found.')) {
                root.html('<p>You are not logged in.</p>');
                root.append('<p><a href="/Shibboleth.sso/Login>Login</a></p>');
            } else if (data && data.includes('Attributes')) {
                root.html('<p>You are logged in.</p>');
                root.append(data);
            } else {
                root.html('<p>Unknown error.</p>');
            }
        });
    });
</script>
HTML;

render($script);
