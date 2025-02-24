<?php

/**
 * MAKE AVATAR FUNCTION
 */
if (!function_exists('makeAvatar')) {
  function makeAvatar($fontPath, $dest, $char)
  {
    $path = $dest;
    $image = imagecreate(200, 200);
    $red = rand(0, 255);
    $green = rand(0, 255);
    $blue = rand(0, 255);
    imagecolorallocate($image, $red, $green, $blue);
    $textcolor = imagecolorallocate($image, 255, 255, 255);
    imagettftext($image, 100, 0, 50, 150, $textcolor, $fontPath, $char);
    imagepng($image, $path);
    imagedestroy($image);
    return $path;
  }
}

/**
 * TRANSLATE TEXT FUNCTION
 * ฟังก์ชันนี้จะใช้สำหรับแปลข้อความต้นฉบับ (ภาษาอังกฤษ)
 * ให้เป็นภาษาที่เลือกโดยใช้ stichoza/google-translate-php
 */
// if (!function_exists('translateText')) {
//   function translateText($text)
//   {
//     // ดึง locale ปัจจุบันของแอปพลิเคชัน
//     $locale = app()->getLocale();
//     // หาก locale ไม่ใช่ 'en' (ภาษาอังกฤษ) ให้แปลข้อความจากอังกฤษไปเป็น target locale
//     if ($locale !== 'en') {
//       $tr = new \Stichoza\GoogleTranslate\GoogleTranslate($locale);
//       return $tr->translate($text);
//     }
//     // หากเป็นภาษาอังกฤษ ให้คืนค่าข้อความต้นฉบับ
//     return $text;
//   }
// }

if (!function_exists('translateText')) {
  function translateText($text, $shouldTranslate = true)
  {
    // ตรวจสอบค่า null หรือค่าว่าง
    if ($text === null || trim($text) === '') {
      return '';
    }

    // แปลงค่าให้เป็น string อย่างชัดเจน
    $text = (string)$text;

    // ดึง locale ปัจจุบันของแอปพลิเคชัน
    $locale = app()->getLocale();

    // หาก locale ไม่ใช่ 'en' ให้แปลข้อความ
    if ($locale !== 'en') {
      try {
        $tr = new \Stichoza\GoogleTranslate\GoogleTranslate($locale);
        return $tr->translate($text);
      } catch (\Exception $e) {
        \Log::error('Translation error: ' . $e->getMessage());
        return $text;
      }
    }

    return $text;
  }
}
