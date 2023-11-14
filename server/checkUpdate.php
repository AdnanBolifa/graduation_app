<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: *');

function generateUniqueId() {
    return uniqid();
}

function getApkFilePath() {
    // Specify the directory where the APK file is located
    $directory = __DIR__;

    // Get a list of APK files in the directory
    $apkFiles = glob("$directory/*.apk");

    if (count($apkFiles) !== 1) {
        throw new Exception('There should be exactly one APK file in the directory');
    }

    // Return the path of the only APK file
    return $apkFiles[0];
}

function generateApkUrl($apkFilePath) {
    // Create the URL based on the file name
    $url = 'https://download1594.mediafire.com/vdbjdjgyi8bg3HIJDTPECpWBInHlh3K3pJ55S-FFdfaA6zuAsmBrmuv64Le5wE1tl8WLtZaNKqtEZxGjCrlmLNSnwKBIOKYSSiJQjAqUrwNh0Mc3z5IG2ZLqlu9VstgGjKM4sc2i4fvjMFk7TKxW7IiImks8lx-fTvJmfStCr4n8SNI/h5sl2es0lp6t2u5/' . basename($apkFilePath);

    return $url;
}

function respondWithJson($data) {
    echo json_encode($data);
}

try {
    // Get the frontend version from the request (replace 'frontend_version' with the actual parameter name)
    $frontendVersion = $_GET['frontend_version'] ?? null;

    if ($frontendVersion === null) {
        throw new Exception('Frontend version not provided');
    }

    // Local version
    $localVersion = "1.0.1";

    // Compare versions
    if (version_compare($frontendVersion, $localVersion, '<')) {
        // Frontend version is smaller, generate and return APK URL
        $apkFilePath = getApkFilePath();
        $url = generateApkUrl($apkFilePath);

        // Create an associative array with the response data
        $response = [
            'version' => $localVersion,
            'url' => $url,
            'status'=> true,
        ];

        // Output the JSON response
        respondWithJson($response);
    } else {
        // Frontend version is equal or greater, return false and do nothing
        respondWithJson(['status' => false]);
    }
} catch (Exception $e) {
    // Handle exceptions
    http_response_code(500); // Internal Server Error
    respondWithJson(['error' => $e->getMessage()]);
}
?>
