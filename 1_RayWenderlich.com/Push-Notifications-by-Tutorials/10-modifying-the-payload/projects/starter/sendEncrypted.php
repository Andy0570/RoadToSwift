<?php

const TOKEN = 'ad1ed2b3c3e86b29d7f8eeecd9b15a474ecfa994c0132200dad0072302b30a46';
const AUTH_KEY_PATH = '/Users/huqilin/Nutstore Files/我的坚果云/4_海店街_2020/1_项目文档/Push_Notification_Key/AuthKey_9HH35JRDD4.p8';
const AUTH_KEY_ID = '9HH35JRDD4';
const TEAM_ID = 'A8F7U6DN75';
const TOPIC = 'Haidian.PushNotifications';

# ---- Shouldn't need any changes below this line ----

$payload = [
  'aps'  => [
    'mutable-content' => 1,
    'alert' => [
      'title' => str_rot13('Your Target'),
      'body' => str_rot13('This is your next assignment.')
    ],
    'badge' => 1,
    'sound' => 'default',
  ],
  "media-url" => str_rot13('https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4')
];

function generateAuthenticationHeader() {
    $header = base64_encode(json_encode(['alg' => 'ES256', 'kid' => AUTH_KEY_ID]));
    $claims = base64_encode(json_encode(['iss' => TEAM_ID, 'iat' => time()]));

    $pkey = openssl_pkey_get_private('file://' . AUTH_KEY_PATH);
    openssl_sign("$header.$claims", $signature, $pkey, 'sha256');

    $signed = base64_encode($signature);
    return "$header.$claims.$signed";
}

$ch = curl_init();
curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_2_0);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
  'apns-topic: ' . TOPIC,
  'Authorization: Bearer ' . generateAuthenticationHeader(),
  'apns-push-type: alert'
]);

$url = 'https://api.development.push.apple.com/3/device/' . TOKEN;
curl_setopt($ch, CURLOPT_URL, "{$url}");

$response = curl_exec($ch);
if ($response === false) {
  echo "Failed to send push notification\n";
}

$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
if ($code === 400) {
  $json = @json_decode($response);
  var_dump($json);
}

curl_close($ch);
