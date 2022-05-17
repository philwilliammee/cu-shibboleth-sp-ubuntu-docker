<?php

require_once __DIR__ . '/../layout.php';

$is_logged_in = isset($_SERVER['REMOTE_USER']);
$html_server_table = "<h1>Please Login</h1>";

if ($is_logged_in) {
    $server_data_keys = [
        'Shib-Handler',
        'Shib-Application-ID',
        'Shib-Session-ID',
        'Shib-Identity-Provider',
        'Shib-Authentication-Instant',
        'Shib-Authentication-Method',
        'Shib-AuthnContext-Class',
        'Shib-Session-Index',
        'Shib-Session-Expires',
        'Shib-Session-Inactivity',
        'cn',
        'displayName',
        'eduPersonAffiliations',
        'eduPersonEntitlement',
        'eduPersonPrimaryAffiliation',
        'eduPersonPrincipalName',
        'eduPersonScopedAffiliation',
        'givenName',
        'mail',
        'sn',
        'uid',
    ];
    $html_server_table = "<h2>Server Data for Auth User {$_SERVER['cn']}</h2>";
    $html_server_table .= "<table><tr><th>Key</th><th>Value</th></tr>";
    foreach ($server_data_keys as $key) {
        $value = array_key_exists($key, $_SERVER) ? $_SERVER[$key] : "";
        $html_server_table .= "<tr><td>$key</td><td>$value</td></tr>";
    }
    $html_server_table .= "</table>";
}

render($html_server_table);

phpinfo();
