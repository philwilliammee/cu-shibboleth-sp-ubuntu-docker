<?php

function render(string $content)
{
    $is_logged_in = isset($_SERVER['REMOTE_USER']);
    $secure_icon = $is_logged_in ? "🔓 " : "🔒";

    $html = <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shibboleth Service Provider on Ubuntu Linux</title>
    <style>
        .container {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
        }
        #main-nav {
            background-color: #eee;
            padding: 15px;
            margin-bottom: 20px;
        } 
        #main-nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        #main-nav ul li {
            display: inline-block;
            margin: 0 10px;
        }
        #main-nav a {
            text-decoration: none;
            color: #000;
            background-color: transparent;
            text-transform: capitalize;
        }
        #main-nav a:hover {
            text-decoration: underline;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
</head>
<body class='container'>
    <h1>Shibboleth Service Provider on Ubuntu Linux</h1>
    <p>
        This is a simple Shibboleth Service Provider (SP) on Ubuntu Linux.
        It is a simple PHP application that uses the <a href='https://shibboleth.net/'>Shibboleth</a>
        authentication framework to authenticate users. This repo contains a Docker Compose file that implements 
        the <a href='https://confluence.cornell.edu/display/SHIBBOLETH/Install+Shibboleth+Service+Provider+on+Linux'>CU-SHIBB-SP-LINUX</a> instructions,
    </p>
    <nav id='main-nav'>
        <ul>
            <li><a href='/'>Home</a></li>
            <li><a href='/secure'>$secure_icon Secure</a></li>
            <li><a href='/Shibboleth.sso/Login' >Login</a></li>
            <li><a href='/Shibboleth.sso/Logout'>Logout</a></li>
            <li><a href='/Shibboleth.sso/Session'>Session</a></li>
            <li><a href='/Shibboleth.sso/Metadata'>Metadata</a></li>
            <li><a href='/Shibboleth.sso/DiscoFeed'>DiscoFeed</a></li>
        </ul>
    </nav>
        $content
</body>
</html>
HTML;

    echo ($html);
}
